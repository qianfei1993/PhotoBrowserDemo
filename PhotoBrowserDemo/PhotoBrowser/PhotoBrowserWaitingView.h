//
//  HZWaitingView.h
//  HZPhotoBrowser
//
//  Created by huangzhenyu on 15-2-6.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.
//

#import <UIKit/UIKit.h>

// 图片下载进度指示器内部控件间的间距
#define WaitingViewItemMargin 10
@interface PhotoBrowserWaitingView : UIView

@property (nonatomic, assign) CGFloat progress;

@end
