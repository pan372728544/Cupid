//
//  ResultSearchDetailViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/16.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ResultSearchDetailViewController.h"

@interface ResultSearchDetailViewController ()

@end

@implementation ResultSearchDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self initNavView];
    
}


-(void)initNavView
{
    [self createNavBarViewWithTitle:@"搜索页面"];
    [self createNavLeftBtnWithItem:@"" target:self action:@selector(backClick:)];
//    [self setNavigationViewBackgroundColor:[]];
    
}
-(void)backClick:(id)sender
{
    
    MYLog(@"返回按钮----");
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
