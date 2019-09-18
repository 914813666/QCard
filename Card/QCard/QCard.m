//
//  QCard.m
//  QCard
//
//  Created by qzp on 2019/9/17.
//  Copyright © 2019 qzp. All rights reserved.
//

#import "QCard.h"
#import "QCardCell.h"

@interface QCard()
@property (nonatomic, strong) UIView * contentView; //内容容器

@property (nonatomic, assign) NSUInteger removeIndex;//移除的下标

@property (nonatomic, strong) NSMutableArray<QCardCell *>* cells;

@property (nonatomic, assign) CGFloat sale;//缩放倍数 默认0.1倍
@property (nonatomic, assign) CGFloat rowDistance; //2个cell之间的距离，默认 8
@property (nonatomic, assign) CGFloat fixRowDistance; //修复后2个cell之间的距离
@property (nonatomic, assign) BOOL upDownClose;//是否开启上下移动滑出操作，默认关闭
@property (nonatomic, assign) CGFloat angle;//偏转角度 默认15度
@property (nonatomic, assign) CGFloat cornerRadius;//cell 的圆角默认没有
@property (nonatomic, assign) CGFloat removeDistance;//移除控件的距离 默认100
@end

@implementation QCard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configView];
}


- (void) configView {

    _cells = [NSMutableArray array];
    //设置后会照成拖拽 到其他视图 也被遮挡  ，不设置会照成多个 视图 显示，会超过 该视图的最大高度
//    self.layer.masksToBounds = YES;
//    self.clipsToBounds = YES;
    self.sale = 0.1;
    self.rowDistance = 8;
    self.fixRowDistance = self.rowDistance;
    self.upDownClose = false;
    self.angle = MAX_ANGLE;
    self.removeDistance = MAC_REMOVE_DISTANCE;
    
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = [[dataSource reverseObjectEnumerator] allObjects];
    [self initOrUpdateView];
}
- (void)setSale:(CGFloat)sale {
    _sale = sale;
    
    [self initOrUpdateView];
}

- (void)setPropertys:(NSDictionary *)propertys {
    _propertys = propertys;
    if ([propertys objectForKey: @"scale"]) {
        self.sale = [propertys[@"scale"] floatValue];
    }
    if ([propertys objectForKey:@"rowDistance"]) {
        self.rowDistance = [propertys[@"rowDistance"] floatValue];
    }
    if ([propertys objectForKey:@"upDownClose"]) {
        self.upDownClose = [propertys[@"upDownClose"] boolValue];
    }
    if ([propertys objectForKey:@"angle"]) {
        self.angle = [propertys[@"angle"] floatValue];
    }
    if([propertys objectForKey:@"cornerRadius"]) {
        self.cornerRadius = [propertys[@"cornerRadius"] floatValue];
    }
    if ([propertys objectForKey:@"removeDistance"]) {
        self.removeDistance = [propertys[@"removeDistance"] floatValue];
    }
    
    
    [self initOrUpdateView];
}


- (void) initOrUpdateView{
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //缩放减少的高度
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat cellHeight = h - 30;
    CGFloat newHeight = cellHeight * self.sale /2  ;
    _fixRowDistance = self.rowDistance +  newHeight;
    
    
    [_cells removeAllObjects];
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        QCardCell * cell = [self createCellWithIndex:i];
        [_cells addObject: cell];
    }
    
    //调整加入的层次
    NSArray * tempArray = [[_cells reverseObjectEnumerator] allObjects];
    NSInteger index = 0;
    for (QCardCell * cell in  tempArray) {
        [self.contentView addSubview: cell];
        if(index <  (self.dataSource.count - SHOW_COUNT)) { //大于3个的位置隐藏
            cell.hidden = YES;
        }
        index++;
    }
}


- (QCardCell *) createCellWithIndex:(NSInteger) index {
    __weak typeof(self) weakSelf = self;
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat cellHeight = h - 30;
    CGFloat left = 5;
    //距离顶部  11*2 + 8 个位置
    //计算 出距离顶部的距离
    CGFloat multiple = (self.sale / 0.1); //缩放倍数
  
    QCardCell * cell = [[QCardCell alloc] initWithFrame:
                        CGRectMake(5, 30, w-10, h- 30)];
    cell.layer.cornerRadius = self.cornerRadius;
    cell.maxAngle = self.angle;
    cell.upDownClose = self.upDownClose;
    cell.maxRemoveDistance = self.removeDistance;
    cell.url = [self.dataSource objectAtIndex:index];
    cell.TouchBegin = ^{
        if (weakSelf.TouchBegin) {
            weakSelf.TouchBegin();
        }
    };
    cell.Click = ^{
        if (weakSelf.Click) {
            weakSelf.Click(index);
        }
    };
    if (index>0) {
        //向上并且变小
        CGRect frame = cell.frame;
        frame.origin.y -= index * self.fixRowDistance;
        cell.frame = frame;
        
      
        CGFloat scale = (10.0 - index  * multiple )  / 10.0 ; //正确的缩放倍数
        if (scale<=0) {
            scale = 0.01;
        }
        
        cell.transform = CGAffineTransformMakeScale(scale, scale);
        cell.userInteractionEnabled = NO; //避免直接拖拽下面的
    }
    
    
    cell.removeCellBlock = ^{
        weakSelf.removeIndex = index;
        [weakSelf updateItems];
    };
    
    return cell;
}


- (void) updateItems{
    
    //移除到最后一个，重置视图
    if (self.removeIndex == self.dataSource.count - 1) {
        [self initOrUpdateView];
        
        return;
    }
    
    //后面的依次变大
    for (NSInteger i = self.removeIndex+1; i < self.dataSource.count; i++) {
        QCardCell * cardView = [_cells objectAtIndex:i];
        if (i == self.removeIndex+SHOW_COUNT) {
            cardView.hidden = NO; //后面一个位置视图显示出来
        }
        if(i == self.removeIndex + 1) {
            cardView.userInteractionEnabled = YES;//打开交互才能拖拽
        }
   
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = cardView.frame;
            frame.origin.y += self.fixRowDistance;
            cardView.frame = frame;
            CGFloat multiple = (self.sale / 0.1);
            CGFloat scale = (10.0 - (i - self.removeIndex -1 ) * multiple)  / 10.0 ;
            if (scale<=0) {
                scale = 0.01;
            }
            cardView.transform = CGAffineTransformMakeScale(scale, scale);
           
        }];
        
       
    }
    
    
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame: self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: _contentView];
    }
    return _contentView;
}




@end
