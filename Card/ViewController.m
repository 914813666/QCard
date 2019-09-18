//
//  ViewController.m
//  Card
//
//  Created by qzp on 2019/9/17.
//  Copyright © 2019 qzp. All rights reserved.
//

#import "ViewController.h"
#import "QCard.h"

@interface ViewController ()

@property (nonatomic,strong) QCard * cardView, * card2View;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - 50) / 1.2;
    __weak typeof(self) weakSelf = self;
    
    self.cardView = [[QCard alloc] initWithFrame: CGRectMake(50, 50, w  , w * 0.8 )];
    self.cardView.propertys = @{@"scale":@"0.1",@"rowDistance":@"8",@"upDownClose":@"0",@"cornerRadius":@"11",@"removeDistance":@"150"};
    self.cardView.dataSource = @[@"https://cdn.pixabay.com/photo/2016/05/02/22/16/apple-blossoms-1368187__480.jpg",
                                 @"https://cdn.pixabay.com/photo/2017/09/12/11/56/universe-2742113__480.jpg",
                                 @"https://cdn.pixabay.com/photo/2015/07/09/22/45/tree-838667__480.jpg",
                                 @"https://cdn.pixabay.com/photo/2018/02/15/21/55/sunset-3156440__480.jpg",
                                 @"https://cdn.pixabay.com/photo/2014/12/15/17/16/pier-569314__480.jpg",
                                 @"https://cdn.pixabay.com/photo/2015/11/16/22/39/balloon-1046658__480.jpg",
                                 @"https://cdn.pixabay.com/photo/2012/08/27/14/19/evening-55067__480.png",
                                 @"https://cdn.pixabay.com/photo/2015/04/23/21/59/hot-air-balloon-736879__480.jpg",
                                 @"https://cdn.pixabay.com/photo/2013/05/12/18/55/balance-110850__480.jpg",
                                 @"https://cdn.pixabay.com/photo/2017/09/11/14/11/fisherman-2739115__480.jpg"];
    
    self.cardView.TouchBegin = ^{
        [weakSelf.view sendSubviewToBack: weakSelf.card2View];
    };
    
  
        self.card2View = [[QCard alloc] initWithFrame: CGRectMake(50, 300, w  , w * 0.8 )];
//        self.card2View.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.card2View.propertys = @{@"scale":@"0.15",@"rowDistance":@"14",@"upDownClose":@"1",@"angle":@"0",@"cornerRadius":@"0"};
        self.card2View.dataSource = @[@"https://cdn.pixabay.com/photo/2016/05/02/22/16/apple-blossoms-1368187__480.jpg",
                                     @"https://cdn.pixabay.com/photo/2017/09/12/11/56/universe-2742113__480.jpg",
                                     @"https://cdn.pixabay.com/photo/2015/07/09/22/45/tree-838667__480.jpg",
                                     @"https://cdn.pixabay.com/photo/2018/02/15/21/55/sunset-3156440__480.jpg",
                                     @"https://cdn.pixabay.com/photo/2014/12/15/17/16/pier-569314__480.jpg",
                                     @"https://cdn.pixabay.com/photo/2015/11/16/22/39/balloon-1046658__480.jpg",
                                     @"https://cdn.pixabay.com/photo/2012/08/27/14/19/evening-55067__480.png",
                                     @"https://cdn.pixabay.com/photo/2015/04/23/21/59/hot-air-balloon-736879__480.jpg",
                                     @"https://cdn.pixabay.com/photo/2013/05/12/18/55/balance-110850__480.jpg",
                                     @"https://cdn.pixabay.com/photo/2017/09/11/14/11/fisherman-2739115__480.jpg"];
        [self.view addSubview: self.card2View];
    
        self.card2View.TouchBegin = ^{
            [weakSelf.view sendSubviewToBack: weakSelf.cardView]; 
        };
    self.card2View.Click = ^(NSInteger index) {
        NSLog(@"点击的第%ld个",(long)index);
    };

    [self.view addSubview: self.cardView];
}


@end
