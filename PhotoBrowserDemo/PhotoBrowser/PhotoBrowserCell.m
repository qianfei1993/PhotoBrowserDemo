//
//  PhotoBrowserCell.m
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/1.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "PhotoBrowserCell.h"
#import "UIView+Frame.h"
#import "PhotoBrowserWaitingView.h"
#import "FLAnimatedImageView+WebCache.h"
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define kStrongSelf(type)  __strong typeof(type) type = weak##type
@interface PhotoBrowserCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic,strong) PhotoBrowserWaitingView *waitingView;
@end

@implementation PhotoBrowserCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)prepareForReuse{
    [super prepareForReuse];
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.contentView.frame;
}
- (void)setupViews {
    
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.scrollView addGestureRecognizer:singleTap];
    [self.scrollView addGestureRecognizer:doubleTap];
}

- (void)singleTap:(UITapGestureRecognizer *)singleTap {
    self.dismissBlock ? self.dismissBlock() : nil;
}

- (void)doubleTap:(UITapGestureRecognizer *)doubleTap {
    if (self.scrollView.zoomScale > 1) {
        [self.scrollView setZoomScale:1 animated:YES];
    } else {
        CGPoint touchPoint = [doubleTap locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = self.width / newZoomScale;
        CGFloat ysize = self.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)resizesSubViews {
    
    UIImage *image = self.imageView.image;
    if (!image) return;
    if (image.size.height / image.size.width > self.contentView.height / self.contentView.width) {
        self.imageView.height = floor(image.size.height / (image.size.width / self.imageView.width));
        self.imageView.y = 0;
    } else {
        CGFloat height = image.size.height / image.size.width * self.contentView.width;
        if (height < 1 || isnan(height)) height = self.contentView.height;
        height = floor(height);
        self.imageView.height = height;
        self.imageView.centerY = self.contentView.height / 2;
    }
    if (self.imageView.height > self.height && self.imageView.height - self.contentView.height <= 1) {
        self.imageView.height = self.height;
    }
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(self.imageView.height, self.contentView.height));
    [_scrollView scrollRectToVisible:_scrollView.bounds animated:NO];
    if (self.imageView.height <= self.contentView.height) {
        _scrollView.alwaysBounceVertical = NO;
    } else {
        _scrollView.alwaysBounceVertical = YES;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1;
}
- (void)loadImageUrl:(NSString *)url{
    if (_reloadButton) {
        [_reloadButton removeFromSuperview];
    }
    //添加进度指示器
    self.waitingView = [[PhotoBrowserWaitingView alloc] init];
    self.waitingView.mode = WaitingViewStyleLoopDiagram;
    self.waitingView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    [self.contentView addSubview:self.waitingView];
    self.scrollView.maximumZoomScale = 1;
    __weak __typeof(self)weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        //NSLog(@"receivedSize = %ld \n expectedSize = %ld",receivedSize,expectedSize);
        //在主线程做UI更新
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
           strongSelf.waitingView.progress = (CGFloat)receivedSize / expectedSize;
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self.waitingView removeFromSuperview];
        if (!error) {
            self.scrollView.maximumZoomScale = 3;
            [self resizesSubViews];
        }else{
            [self.contentView addSubview:self.reloadButton];
        }
    }];
    [self resizesSubViews];
}
#pragma mark - getter & setter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _imageView;
}
- (UIButton*)reloadButton{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.layer.cornerRadius = 2;
        _reloadButton.clipsToBounds = YES;
        _reloadButton.frame = CGRectMake(0, 0, 200, 40);
        _reloadButton.center = self.contentView.center;
        _reloadButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _reloadButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
        [_reloadButton setTitle:@"图片加载失败，点击重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}
- (PhotoBrowserWaitingView *)waitingView{
    if (!_waitingView) {
        PhotoBrowserWaitingView *waitingView = [[PhotoBrowserWaitingView alloc] init];
        waitingView.mode = WaitingViewStyleLoopDiagram;
        waitingView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    }
    return _waitingView;
}
- (void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    [self loadImageUrl:imgUrl];
}
- (void)reloadImage{
    [self loadImageUrl:self.imgUrl];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - NLBottomToolbarDelegate
- (void)toolbarDidClickLikeButton {
    
}

@end
