//
//  PhotoBrowserViewController.m
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/1.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "PhotoBrowserCell.h"
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
static CGFloat const kSpacing = 8.0;
@interface PhotoBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UILabel *indexLabel;
@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)setupViews {
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UICollectionView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.indexLabel];
    self.indexLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_imgArr.count];
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if (currentIndex > self.imgArr.count) {
        return;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoBrowserCellID" forIndexPath:indexPath];
    cell.imgUrl = self.imgArr[indexPath.item];
    cell.dismissBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(PhotoBrowserCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [cell.scrollView setZoomScale:1.0 animated:NO];
}
#pragma mark - getter
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 2 * kSpacing;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.itemSize = self.view.frame.size;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, kSpacing, 0, kSpacing);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kSpacing, 0, SCREEN_WIDTH + 2 * kSpacing, SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[PhotoBrowserCell class] forCellWithReuseIdentifier:@"PhotoBrowserCellID"];
    }
    return _collectionView;
}

-(UILabel*)indexLabel{
    
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 44, 60, 26)];
        _indexLabel.backgroundColor = [UIColor redColor];
        _indexLabel.layer.cornerRadius = 13;
        _indexLabel.clipsToBounds = YES;
        _indexLabel.font = [UIFont systemFontOfSize:18];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x + (SCREEN_WIDTH + kSpacing*2)/2) / (SCREEN_WIDTH + kSpacing*2);
    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)index+1,(unsigned long)_imgArr.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
