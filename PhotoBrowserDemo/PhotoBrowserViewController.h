//
//  PhotoBrowserViewController.h
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/1.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserViewController : UIViewController
@property (nonatomic, assign) NSInteger currentIndex;
/**
 当前展示在中间的cell下标
 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSArray *imgArr;
@end
