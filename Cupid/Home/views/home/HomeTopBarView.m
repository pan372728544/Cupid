//
//  HomeTopBarView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeTopBarView.h"
#import "SearchBarView.h"

#import "ResultSearchViewController.h"
#import "ListViewController.h"


@interface HomeTopBarView()<UITextFieldDelegate>

@property(nonatomic,strong) SearchBarView *searchBarView;

@property(nonatomic,strong) ResultSearchViewController *resultVC;

@end

@implementation HomeTopBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        [self setupSubviews];
    }
    return self;
}


-(void)setupSubviews
{
    self.frame=CGRectMake(15, STATUSBAR_H, SCREEN_W-30, NAVBAR_H);
    self.searchBarView = [[SearchBarView alloc]initWithFrame:CGRectMake(0, (NAVBAR_H-SearchBar_H)/2, SCREEN_W-30, SearchBar_H)];
    self.searchBarView.placeholder = @"输入搜索关键字";
    [self addSubview:self.searchBarView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.searchBarView addGestureRecognizer:tap];
    
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        
        // 更新大小
        self.frame=CGRectMake(50, STATUSBAR_H, SCREEN_W-100, NAVBAR_H);
        self.searchBarView.frame =  CGRectMake(0, (NAVBAR_H-SearchBar_H)/2, SCREEN_W-100, SearchBar_H);
        
        
    } completion:^(BOOL finished) {
        
        self.frame=CGRectMake(15, STATUSBAR_H, SCREEN_W-30, NAVBAR_H);
        self.searchBarView.frame =  CGRectMake(0, (NAVBAR_H-SearchBar_H)/2, SCREEN_W-30, SearchBar_H);
        
        
        // push搜索页面
        self.resultVC = [[ResultSearchViewController alloc] init];
        
        [self.superVC.navigationController pushViewController:self.resultVC animated:NO];
        

    }];
}





@end
