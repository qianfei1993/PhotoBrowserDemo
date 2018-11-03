//
//  PhotoBrowserViewController.m
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/1.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "PhotoBrowserCell.h"
#import "PhotoBrowserFlowLayout.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HIGHT [UIScreen mainScreen].bounds.size.height
@interface PhotoBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    CGFloat          startX;
    CGFloat          endX;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *indexLabel;
@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UICollectionView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupView];
}

- (void)setupView{
    
    self.indexLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_imgArr.count];
    self.view.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    PhotoBrowserFlowLayout *flowLayout = [[PhotoBrowserFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoBrowserCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PhotoBrowserCellID"];
    [self.view addSubview:self.indexLabel];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.imgArr) {
        return self.imgArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoBrowserCellID" forIndexPath:indexPath];
    if (self.imgArr) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",self.imgArr[indexPath.row]];
        cell.imageUrl = [NSURL URLWithString:urlStr];
    }
    cell.dismissBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"点击点击点击点击点击");
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(PhotoBrowserCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [cell.scrollview setZoomScale:1.0 animated:NO]; //还原
//    cell.scrollview.userInteractionEnabled = NO;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(PhotoBrowserCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    [cell.scrollview setZoomScale:1.0 animated:NO]; //还原
//    cell.scrollview.userInteractionEnabled = YES;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    startX = scrollView.contentOffset.x;
    scrollView.userInteractionEnabled = NO;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    endX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cellToCenter];
    });
    scrollView.userInteractionEnabled = YES;
}
-(void)cellToCenter{
    
    if (self.imgArr) {
        
        self.collectionView.scrollEnabled = YES;
        //最小滚动距离
        float dragMinDistance = _collectionView.bounds.size.width/20.0f;
        if (startX - endX >= dragMinDistance) {
            _currentIndex -= 1; //向右
        }else if (endX - startX >= dragMinDistance){
            _currentIndex += 1 ;//向左
        }
        NSInteger maxIndex  = [_collectionView numberOfItemsInSection:0] - 1;
        _currentIndex = _currentIndex <= 0 ? 0 :_currentIndex;
        _currentIndex = _currentIndex >= maxIndex ? maxIndex : _currentIndex;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
//        PhotoBrowserCell *cell = (PhotoBrowserCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathWithIndex:_currentIndex]];
//        cell.scrollview.userInteractionEnabled = YES;
        self.indexLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)_currentIndex+1,(unsigned long)_imgArr.count];
    }else{
//        self.collectionView.scrollEnabled = NO;
    }
}


-(UILabel*)indexLabel{
    
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, 88, 50, 25)];
        _indexLabel.backgroundColor = [UIColor redColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
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
