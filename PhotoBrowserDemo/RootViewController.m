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
                        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=935292084,2640874667&fm=27&gp=0.jpg",
                        @"http://img3.imgtn.bdimg.com/it/u=3587889913,707866300&fm=214&gp=0.jpg",
                        @"http://img3.imgtn.bdimg.com/it/u=996902316,576683043&fm=26&gp=0.jpg",
                        @"http://img4.imgtn.bdimg.com/it/u=4250485907,2796756087&fm=26&gp=0.jpg",
                        @"http://img3.imgtn.bdimg.com/it/u=3015743357,2053210106&fm=26&gp=0.jpg",
                        @"http://img5.imgtn.bdimg.com/it/u=1876952812,4049526833&fm=26&gp=0.jpg",
                        @"http://img18.3lian.com/d/file/201704/13/373a1a79363830685afc44994e7b927d.gif",
                        @"http://img3.imgtn.bdimg.com/it/u=1355788508,3906310919&fm=26&gp=0.jpg",
                        @"http://img5.imgtn.bdimg.com/it/u=2564857670,1911784483&fm=26&gp=0.jpg",
                        @"http://ww4.sinaimg.cn/bmiddle/broswerPic0.jpg",
                        @"http://ww4.sinaimg.cn/bmiddle/broswerPic0.jpg"
                        ];
//    _photoVC.currentIndex = 3;
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
