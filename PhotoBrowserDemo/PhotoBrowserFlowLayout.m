//
//  PhotoBrowserFlowLayout.m
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/2.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "PhotoBrowserFlowLayout.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HIGHT [UIScreen mainScreen].bounds.size.height
@implementation PhotoBrowserFlowLayout

-(instancetype)init{

    if (self = [super init]) {
        //设置item的大小
        self.itemSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0;//水平滑动--水平间距  垂直滑动--垂直间距
        self.minimumInteritemSpacing = 0;//水平滑动--垂直间距 垂直滑动--水平间距
    }
    return self;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    //NSArray *arr = [self copyAttributes: [super layoutAttributesForElementsInRect:rect]];
    NSArray<UICollectionViewLayoutAttributes *> *arr = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
//    [arr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"下标=====%lu",(unsigned long)idx);
//        obj.transform = CGAffineTransformMakeTranslation(-10, 0);
//    }];
//    for (NSInteger i = 0; i < arr.count; i++) {
//        UICollectionViewLayoutAttributes *attribute = arr[i];
//        attribute.transform = CGAffineTransformMakeTranslation(-10*i, 0);
//    }
    //屏幕中间线
    //CGFloat centerX = self.collectionView.contentOffset.x  + self.collectionView.bounds.size.width /2.0f;
    //刷新cell缩放
    for (UICollectionViewLayoutAttributes *attribute in arr) {
        
//        CGFloat distance = fabs(attribute.center.x - centerX);
//        //移动的距离和屏幕宽的比例
//        CGFloat screenScale = distance /self.collectionView.bounds.size.width;
//        //卡片移动到固定范围内 -π/4 到 π/4
//        CGFloat scale = fabs(cos(screenScale * M_PI/4));
//        //设置cell的缩放 按照余弦函数曲线  越居中越接近于1
//        attribute.transform = CGAffineTransformMakeScale(1.0, scale);
//        //透明度
//        attribute.alpha = scale;
        
//        attribute.transform = CGAffineTransformMakeTranslation(-10, 0);
    }
    
    return arr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(NSArray *)copyAttributes:(NSArray  *)arr{
    NSMutableArray *copyArr = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in arr) {
        [copyArr addObject:[attribute copy]];
    }
    return copyArr;
}
@end
