//
//  SecondViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "SecondViewController.h"
#import "ZJBaseViewController+NavBar.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.view.backgroundColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initNavView];
    
}


-(void)initNavView
{
    [self createNavBarViewWithTitle:@"通讯录"];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
