//
//  QCardCell.h
//  Card
//
//  Created by qzp on 2019/9/17.
//  Copyright © 2019 qzp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define DEFAULT_TIME 0.25f

@interface QCardCell : UIView
@property (nonatomic, copy) NSString * url;
@property (nonatomic, assign) CGFloat maxAngle;
@property (nonatomic, assign) CGFloat maxRemoveDistance;
@property (nonatomic, assign) BOOL upDownClose;


//移除操作
@property (nonatomic, copy) void (^removeCellBlock)(void);
@property (nonatomic, copy) void (^TouchBegin)(void);
@property (nonatomic, copy) void (^Click)(void);
@end

NS_ASSUME_NONNULL_END
