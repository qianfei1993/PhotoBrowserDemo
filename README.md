# PhotoBrowserDemo
## 效果图
#### 动态图&长图
![动图](https://raw.githubusercontent.com/qianfei1993/PhotoBrowserDemo/master/PhotoBrowserDemo/gif.png)
![长图](https://raw.githubusercontent.com/qianfei1993/PhotoBrowserDemo/master/PhotoBrowserDemo/long.png)
![短图](https://raw.githubusercontent.com/qianfei1993/PhotoBrowserDemo/master/PhotoBrowserDemo/short.png)
![图片加载动画](https://raw.githubusercontent.com/qianfei1993/PhotoBrowserDemo/master/PhotoBrowserDemo/loading.png)
![图片加载失败](https://raw.githubusercontent.com/qianfei1993/PhotoBrowserDemo/master/PhotoBrowserDemo/reload.png)

## 介绍&使用
#### 使用UICollectionView封装的图片浏览器，依赖于SDWebImage；支持网络图片、本地图片和二进制图片加载，支持长图，动图显示；支持双击缩放，捏合缩放，单击消失；支持图片加载动画，图片加载失败重加载，图片缓存，保存网络图片到相册等功能；
## 使用
#### 初始化PhotoBrowserViewController，传入需要显示的图片数组，可同时包含网络图片与本地图片；currentIndex表示从第几张开始显示(默认从第一张开始显示)
```
    _photoVC = [[PhotoBrowserViewController alloc]init];
    // 传入图片数组，可同时包含网络图片与本地图片
    _photoVC.imgArr = @[
                        @"http://img5.imgtn.bdimg.com/it/u=1876952812,4049526833&fm=26&gp=0.jpg",
                        @"http://img18.3lian.com/d/file/201704/13/373a1a79363830685afc44994e7b927d.gif",
                        @"gwh.jpg",
                        @"http://img3.imgtn.bdimg.com/it/u=1355788508,3906310919&fm=26&gp=0.jpg"
                        ];
    // 从第几张开始显示
    _photoVC.currentIndex = 3;
    [self presentViewController:_photoVC animated:YES completion:nil];
```
