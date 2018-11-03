//
//  PhotoBrowserCell.m
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/1.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "PhotoBrowserCell.h"
#import "PhotoBrowserWaitingView.h"
@interface PhotoBrowserCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic,strong) PhotoBrowserWaitingView *waitingView;
@end

@implementation PhotoBrowserCell

- (void)layoutSubviews{
    
    [super layoutSubviews];
    CGFloat selfW = self.bounds.size.width;
    CGFloat selfH = self.bounds.size.height;
    _waitingView.center = CGPointMake(selfW * 0.5, selfH * 0.5);
    _scrollview.frame = self.bounds;
    CGFloat reloadBtnW = 200;
    CGFloat reloadBtnH = 40;
    _reloadButton.frame = CGRectMake((selfW - reloadBtnW)*0.5, (selfH - reloadBtnH)*0.5, reloadBtnW, reloadBtnH);
    [self adjustFrame];
}

//- (void)prepareForReuse{
//    [super prepareForReuse];
//     [self.scrollview setZoomScale:1.0 animated:NO]; //还原
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imageview = [[FLAnimatedImageView alloc] init];
    _imageview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    _imageview.userInteractionEnabled = NO;
//    self.contentView.userInteractionEnabled = NO;
    
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.showsHorizontalScrollIndicator = NO;
    [_scrollview addSubview:_imageview];
    _scrollview.delegate = self;
    _scrollview.clipsToBounds = YES;
    [self.contentView addSubview:_scrollview];
    
    
    //创建手势
    //单击
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
//    singleTap.numberOfTapsRequired = 1;
//    singleTap.delaysTouchesBegan = YES;
    //双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self; 
    //只能有一个手势存在
//    [singleTap requireGestureRecognizerToFail:doubleTap];
//    [_scrollview addGestureRecognizer:singleTap];
    [_scrollview addGestureRecognizer:doubleTap];

}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _waitingView.progress = progress;
}
- (void)setImageUrl:(NSURL *)imageUrl{
    
    _imageUrl = imageUrl;
    [self reloadImage];
}

- (void)adjustFrame{
    
    CGRect frame = self.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;//获得图片的size
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (_isFullWidthForLandScape) {//图片宽度始终==屏幕宽度(新浪微博就是这种效果)
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        } else{
            if (frame.size.width<=frame.size.height) {
                //竖屏时候
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{ //横屏的时候
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageview.frame = imageFrame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
        
        //根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        //超过了设置的最大的才算数
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;
        //初始化
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        //重置内容大小
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
    self.zoomImageSize = self.imageview.frame.size;
}
#pragma mark public methods
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    
    if (_reloadButton) {
        [_reloadButton removeFromSuperview];
    }
    _imageUrl = url;
    _placeHolderImage = placeholder;
    //添加进度指示器
    PhotoBrowserWaitingView *waitingView = [[PhotoBrowserWaitingView alloc] init];
    waitingView.mode = WaitingViewStyleLoopDiagram;
    waitingView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    self.waitingView = waitingView;
    [self.contentView addSubview:waitingView];
    
    //HZWebImage加载图片
    __weak __typeof(self)weakSelf = self;
    [_imageview sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //在主线程做UI更新
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.waitingView.progress = (CGFloat)receivedSize / expectedSize;
        });
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [weakSelf.waitingView removeFromSuperview];
        if (error) {
            //图片加载失败的处理，此处可以自定义各种操作（...）
            strongSelf.hasLoadedImage = NO;//图片加载失败
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            strongSelf.reloadButton = button;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            button.frame = CGRectMake(0, 0, 200, 40);
            button.center = self.contentView.center;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            //button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
            button.backgroundColor = [UIColor redColor];
            [button setTitle:@"图片加载失败，点击重新加载" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:strongSelf action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            return;
        }
        //加载成功重新计算frame,解决长图可能显示不正确的问题
        [self setNeedsLayout];
        strongSelf.hasLoadedImage = YES;//图片加载成功
    }];
}

#pragma mark private methods
- (void)reloadImage{
    [self setImageWithURL:_imageUrl placeholderImage:_placeHolderImage];
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView{
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}
#pragma mark - tap
#pragma mark 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer{
    
    _dismissBlock ? _dismissBlock() : nil;
}

#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollview.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollview.contentOffset.y;//需要放大的图片的Y点
        [self.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [self.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}


#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageview;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    self.zoomImageSize = view.frame.size;
    self.scrollOffset = scrollView.contentOffset;
}
//这里是缩放进行时调整
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.scrollOffset = scrollView.contentOffset;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
//    if ([touch.view isKindOfClass:[FLAnimatedImageView class]]) {
//        return NO;
//    }
//
//    return YES;
    return NO;
}

@end
