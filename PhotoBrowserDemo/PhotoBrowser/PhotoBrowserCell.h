//
//  PhotoBrowserCell.h
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/1.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinZoomScale 0.5f
#define kMaxZoomScale 2.0f
@interface PhotoBrowserCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) UIScrollView *scrollView;
@end
