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
        self.isSupportRightSlide = YES;
    self.view.backgroundColor= [UIColor whiteColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 44)];
    lab.text = @"发布";
    lab.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:lab];

    
}

-(void)initMainViews
{
    

}


-(void)backClick:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
