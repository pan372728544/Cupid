//
//  PublishViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "PublishViewController.h"
#import "ZJBaseViewController+NavBar.h"

@interface PublishViewController ()

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布";
    [self initNavView];
    // Do any additional setup after loading the view.
}

-(void)initNavView
{
    [self createNavBarViewWithTitle:@"发布"];
    [self createNavLeftBtnWithItem:@"" target:self action:@selector(backClick:)];
    self.view.backgroundColor= [UIColor orangeColor];
    // Do any additional setup after loading the view.
    
}

-(void)initMainViews
{
    

}


-(void)backClick:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
