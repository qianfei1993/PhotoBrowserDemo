//
//  RootViewController.m
//  PhotoBrowserDemo
//
//  Created by damai on 2018/11/1.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "RootViewController.h"
#import "PhotoBrowserViewController.h"
@interface RootViewController ()
@property (nonatomic, strong) PhotoBrowserViewController *photoVC;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)buttonAction:(UIButton *)sender {
    [self photoDemo];
}

- (void)photoDemo{
    _photoVC = [[PhotoBrowserViewController alloc]init];
    _photoVC.imgArr = @[
                        @"http://ww2.sinaimg.cn/bmiddle/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                        @"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://ww4.sinaimg.cn/bmiddle/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg",
                        @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                        @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                        @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                        @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                        @"http://ww2.sinaimg.cn/bmiddle/677febf5gw1erma104rhyj20k03dz16y.jpg",
                        @"http://ww4.sinaimg.cn/bmiddle/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",
                        @"http://ww4.sinaimg.cn/bmiddle/broswerPic0.jpg",
                        @"http://ww4.sinaimg.cn/bmiddle/broswerPic0.jpg"
                        ];
//    [self.navigationController pushViewController:_photoVC animated:YES];
    _photoVC.currentIndex = 3;
    [self presentViewController:_photoVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
