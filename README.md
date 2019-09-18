### 这是一个卡片效果的DEMO

主要使用方法：

| 字段           | 取值        | 说明                                                         |
| -------------- | ----------- | ------------------------------------------------------------ |
| scale          | number: 0-1 | 卡片每次缩减倍数，默认0.1                                    |
| rowDistance    | number      | 卡片直接的距离                                               |
| upDownClose    | bool:0 or 1 | 是否开启上下拖拽移除效果，默认开启的是左右移除效果上下移除效果未开启 |
| cornerRadius   | number      | 卡片圆角                                                     |
| removeDistance | number      | 卡片拖拽多远移出屏幕的距离                                   |



```objective-c
self.cardView = [[QCard alloc] initWithFrame: CGRectMake(50, 50, w  , w * 0.8 )];
self.cardView.propertys = @{@"scale":@"0.1",@"rowDistance":@"8",@"upDownClose":@"0",@"cornerRadius":@"11",@"removeDistance":@"150"};
self.cardView.dataSource = @[];//数据源
```

最终效果图：

![](https://tva1.sinaimg.cn/large/006y8mN6gy1g73h4dldotg307b0d41dz.gif)
