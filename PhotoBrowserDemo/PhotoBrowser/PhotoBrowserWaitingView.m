//
//  HZWaitingView.m
//  HZPhotoBrowser
//
//  Created by huangzhenyu on 15-2-6.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.
//

#import "PhotoBrowserWaitingView.h"
@implementation PhotoBrowserWaitingView


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    [self setNeedsDisplay];
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)setFrame:(CGRect)frame{
    
    //设置背景图为圆
    frame.size.width = 50;
    frame.size.height = 50;
    self.layer.cornerRadius = 25;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [[UIColor whiteColor] set];
    
    CGContextSetLineWidth(ctx, 4);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - WaitingViewItemMargin;
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
    CGContextStrokePath(ctx);
    
}

@end
