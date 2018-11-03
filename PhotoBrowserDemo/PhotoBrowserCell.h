//
//  PhotoBrowserCell.h
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/1.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView+WebCache.h"

#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f
@interface PhotoBrowserCell : UICollectionViewCell


@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) FLAnimatedImageView *imageview;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL beginLoadingImage;
//判断图片是否加载成功
@property (nonatomic, assign) BOOL hasLoadedImage;
@property (nonatomic,assign) CGSize zoomImageSize;
@property (nonatomic,assign) CGPoint scrollOffset;
@property (nonatomic, assign) BOOL isFullWidthForLandScape;

@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) UIImage *placeHolderImage;

// dismiss
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
