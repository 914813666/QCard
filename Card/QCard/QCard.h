//
//  QCard.h
//  QCard
//
//  Created by qzp on 2019/9/17.
//  Copyright © 2019 qzp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


#define SHOW_COUNT 3 //页面最多显示数量
#define ITEM_COUNT 10 //需要展示的item
#define LINE_SPACING 10 //行间距
#define ROW_SPACING 10 //列间距
#define MAX_ANGLE 15 //侧滑最大角度15°
#define MAC_REMOVE_DISTANCE 100 //移动超过多大距离移除屏幕


@interface QCard : UIView
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSDictionary * propertys;//配置属性
@property (nonatomic, copy) void (^TouchBegin)(void);
@property (nonatomic, copy) void (^Click)(NSInteger index);



@end

NS_ASSUME_NONNULL_END
