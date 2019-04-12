//
//  CardDemoViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/4/2.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "CardDemoViewController.h"
#import "GMCCardAnimationView.h"

@interface CardDemoViewController ()<GMDCardViewDataSource,GMDCardViewDelegate>

@property(nonatomic,strong)NSMutableArray *cardDataMulAry;

@property(nonatomic,strong)GMCCardAnimationView*cardView;

@property(nonatomic,strong)UIView *backView;


@property(nonatomic,strong)UILabel *countLbl;

@end

@implementation CardDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _backView.alpha = 0.5;
    _backView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_backView];
    
    
    [_backView addSubview:self.countLbl];
    
    [self initCardView];
    
    UIButton *clostBtn = [[UIButton alloc]init];;
    [clostBtn setImage:[UIImage imageNamed:@"tabbar_closebtn_56x56_"] forState:UIControlStateNormal];
    clostBtn.frame = CGRectMake((self.view.frame.size.width-70)/2, CGRectGetMaxY(self.cardView.frame)+20, 70, 70);
    [clostBtn addTarget:self action:@selector(closeCardView) forControlEvents:UIControlEventTouchUpInside];
    
    [_backView addSubview:clostBtn];
    
    
    
    
}

-(void)closeCardView
{

    [self.backView removeFromSuperview];
    
}

-(UILabel *)countLbl
{
    if (!_countLbl) {
        _countLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
        _countLbl.text = [NSString stringWithFormat:@"0/%ld",self.cardDataMulAry.count];
        _countLbl.font = [UIFont systemFontOfSize:30];
        _countLbl.textColor = [UIColor whiteColor];
        _countLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _countLbl;
}


-(void)initCardView
{
    GMCCardAnimationView*cardView = [[GMCCardAnimationView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, CGRectGetMaxY(self.countLbl.frame)+50, 300, 500) maxCount:4];
    cardView.delegate= self;
    cardView.dataSource = self;
    [_backView addSubview:cardView];
    
    self.cardView = cardView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        self.cardDataMulAry = [NSMutableArray arrayWithObjects:@"测试数据0",@"测试数据1",@"测试数据2", @"测试数据3", @"测试数据4", @"测试数据5", @"测试数据6",@"测试数据7",@"测试数据8",@"测试数据9",@"测试数据10",@"测试数据11",@"测试数据12",@"测试数据13",@"测试数据14",@"测试数据15",@"测试数据16",@"测试数据17",@"测试数据18",@"测试数据19",  nil];
        
      
        [self.cardView reloadDataWithOffsetIndex:[self.index integerValue]];
        
    });
}
#pragma mark ---- 协议代理实现


-(NSInteger)numberOfCountInCardView
{
    return self.cardDataMulAry.count;
}

-(id)cardViewDisplayDataForCardViewAtIndex:(NSInteger)index
{
    
    return self.cardDataMulAry[index];
    
}


-(void)cardViewScrollViewCardAtIndex:(NSInteger)index
{
    NSLog(@"滑动到了%ld页面",index);
    self.countLbl.text = [NSString stringWithFormat:@"%ld/%ld",index,self.cardDataMulAry.count-1];
}

-(void)cardViewClickCardAtIndex:(NSInteger)index
{
    
    NSLog(@"第%ld个被点击了",index);
}

@end
