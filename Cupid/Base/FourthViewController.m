//
//  FourthViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "FourthViewController.h"
#import "ZJBaseViewController+NavBar.h"

@interface FourthViewController ()

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.view.backgroundColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initNavView];
    
}


-(void)initNavView
{
    [self createNavBarViewWithTitle:@"我"];
    
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
