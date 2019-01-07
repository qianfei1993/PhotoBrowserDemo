//
//  PhotoBrowserViewController.h
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/1.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowserViewController : UIViewController

// 从第几张图片开始展示，默认0
@property (nonatomic, assign) NSInteger currentIndex;

// 图片数组
@property (nonatomic, strong) NSArray *imgArr;

@end
