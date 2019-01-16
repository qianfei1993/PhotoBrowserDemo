# PhotoBrowserDemo
## 效果图
#### 动态图&长图
![下拉刷新](https://raw.githubusercontent.com/qianfei1993/PhotoBrowserDemo/master/PhotoBrowserDemo/gif.png)
![上拉加载](https://raw.githubusercontent.com/qianfei1993/PhotoBrowserDemo/master/PhotoBrowserDemo/long.png)

## 介绍
#### PhotoBrowserDemo
## 使用
#### 
```
    _photoVC = [[PhotoBrowserViewController alloc]init];
    _photoVC.imgArr = @[
                        @"http://img5.imgtn.bdimg.com/it/u=1876952812,4049526833&fm=26&gp=0.jpg",
                        @"http://img18.3lian.com/d/file/201704/13/373a1a79363830685afc44994e7b927d.gif",
                        @"http://img3.imgtn.bdimg.com/it/u=1355788508,3906310919&fm=26&gp=0.jpg",
                        ];
    // 从第几张开始显示
    _photoVC.currentIndex = 3;
    [self presentViewController:_photoVC animated:YES completion:nil];
```
