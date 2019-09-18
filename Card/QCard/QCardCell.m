//
//  QCardCell.m
//  Card
//
//  Created by qzp on 2019/9/17.
//  Copyright © 2019 qzp. All rights reserved.
//

#import "QCardCell.h"
#import <UIImageView+WebCache.h>

@interface QCardCell ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, assign) CGPoint currentPoint;//当前触摸的位置
@property (nonatomic, strong) UIButton * btn;
@end

@implementation QCardCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame: self.bounds];
        [self addSubview: self.imageView];
        [self initializeUserInterface];
    }
    return self;
}



- (void)setUrl:(NSString *)url {
    _url = url;
    NSURL * i_url = [NSURL URLWithString: url];
    [self.imageView sd_setImageWithURL: i_url];
}


- (void) initializeUserInterface{
    //添加拖动手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer: pan];

    self.layer.cornerRadius = 11;
    self.layer.masksToBounds = YES;
    
    self.btn = [[UIButton alloc]initWithFrame: self.bounds];
    [self.btn addTarget:self
                 action:@selector(buttonClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.btn];
}

- (void) buttonClick:(UIButton *) btn {
    if (self.Click) {
        self.Click();
    }
}


- (void) panGestureRecognizer: (UIPanGestureRecognizer *) pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.currentPoint = CGPointZero;
            if(self.TouchBegin){
                self.TouchBegin();
                
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //locationInView:获取到的是手指点击屏幕实时的坐标点；
            //translationInView：获取到的是手指移动后，在相对坐标中的偏移量
            CGPoint movePoint = [pan translationInView: pan.view];
            NSLog(@"movePoint:%.f-%.f", movePoint.x, movePoint.y);
            //移动后的位置
            self.currentPoint = CGPointMake(movePoint.x + self.currentPoint.x, movePoint.y + self.currentPoint.y);
            
//             NSLog(@"currentPoint:%.f-%.f", self.currentPoint.x, self.currentPoint.y);
            CGFloat moveScale = self.currentPoint.x / self.maxAngle;
            
//            NSLog(@"moveScale = %f", moveScale);
            //判断是像左偏转还是右偏转
            if (ABS(moveScale) > 1.0) {
                moveScale = (moveScale > 0) ? 1.0 : -1.0;
            }
            //旋转度数
            CGFloat angle = DEGREES_TO_RADIANS(self.maxAngle) * moveScale;
            CGAffineTransform transRotation = CGAffineTransformMakeRotation(angle);
            //平移和旋转
            self.transform = CGAffineTransformTranslate(transRotation, self.currentPoint.x, self.currentPoint.y);
            //设置手势的偏移量
            [pan setTranslation:CGPointZero inView:pan.view];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self didPanStateEnded];
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}

//手势结束
//   //生成一个副本 ，状态保持 为 拖动结束后那一刻， 并实现飞出动画， 之后将原视图 复原执行（self.transform =  CGAffineTransformIdentity）
- (void) didPanStateEnded {
    //右滑删除  - 超出了定义的最大滑动距离
    
    if (self.upDownClose) {
        if(self.currentPoint.x > self.maxRemoveDistance ||
           self.currentPoint.x < -self.maxRemoveDistance ||
           self.currentPoint.y > self.maxRemoveDistance ||
           self.currentPoint.y < -self.maxRemoveDistance) {
            //判断是横向移动出去还是纵向
            if (ABS(self.currentPoint.x) < ABS(self.currentPoint.y)) { //纵向
                    //获取当前view 的一个快照 NO 标示马上获得快照，取当前视图， YES 则为空白视图
                    __block UIView * snapshotView = [self snapshotViewAfterScreenUpdates: NO];
                    snapshotView.transform = self.transform;
                    //添加到 上上一级控件中
                    [self.superview.superview addSubview: snapshotView];
                    [self cellRemoveFormSupview];
                    
                    CGFloat endCenterY = [UIScreen mainScreen].bounds.size.height/2 + CGRectGetHeight(self.frame) * 1.5;
                    
                    if(self.currentPoint.y < - self.maxRemoveDistance) {
                        endCenterY = -endCenterY;
                    }
                    
                    [UIView animateWithDuration: DEFAULT_TIME animations:^{
                        CGPoint center = self.center;
                        center.y = endCenterY;
                        snapshotView.center = center;
                    } completion:^(BOOL finished) {
                        [snapshotView removeFromSuperview];
                    }];
            } else {//横向
             
                    //获取当前view 的一个快照 NO 标示马上获得快照，取当前视图， YES 则为空白视图
                    __block UIView * snapshotView = [self snapshotViewAfterScreenUpdates: NO];
                    snapshotView.transform = self.transform;
                    //添加到 上上一级控件中
                    [self.superview.superview addSubview: snapshotView];
                    [self cellRemoveFormSupview];
                    
                    CGFloat endCenterX = [UIScreen mainScreen].bounds.size.width/2 + CGRectGetWidth(self.frame) * 1.5;
                    
                    if(self.currentPoint.x < - self.maxRemoveDistance) {
                        endCenterX = -endCenterX;
                    }
                    
                    [UIView animateWithDuration: DEFAULT_TIME animations:^{
                        CGPoint center = self.center;
                        center.x = endCenterX;
                        snapshotView.center = center;
                    } completion:^(BOOL finished) {
                        [snapshotView removeFromSuperview];
                    }];
            }
            
        }
        else {
             [self restoreCellLocation];
        }
        
        
    } else {
        if(self.currentPoint.x > self.maxRemoveDistance ||  self.currentPoint.x < - self.maxRemoveDistance) {
            //获取当前view 的一个快照 NO 标示马上获得快照，取当前视图， YES 则为空白视图
            __block UIView * snapshotView = [self snapshotViewAfterScreenUpdates: NO];
            snapshotView.transform = self.transform;
            //添加到 上上一级控件中
            [self.superview.superview addSubview: snapshotView];
            [self cellRemoveFormSupview];
            
            CGFloat endCenterX = [UIScreen mainScreen].bounds.size.width/2 + CGRectGetWidth(self.frame) * 1.5;
            
            if(self.currentPoint.x < - self.maxRemoveDistance) {
                endCenterX = -endCenterX;
            }
            
            [UIView animateWithDuration: DEFAULT_TIME animations:^{
                CGPoint center = self.center;
                center.x = endCenterX;
                snapshotView.center = center;
            } completion:^(BOOL finished) {
                [snapshotView removeFromSuperview];
            }];
        } else {
            [self restoreCellLocation];
        }
    }
   
    
}


-(void)cellRemoveFormSupview {
    self.transform =  CGAffineTransformIdentity;//旋转等状态复原
    [self removeFromSuperview];
    if(self.removeCellBlock) {
        self.removeCellBlock();
    }
}
//状态复原 - 执行一个弹性动画
- (void) restoreCellLocation {
    
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
@end
