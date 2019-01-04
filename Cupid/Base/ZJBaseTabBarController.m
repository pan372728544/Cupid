//
//  ZJBaseTabBarController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/3.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBaseTabBarController.h"
#import "ZJBaseNavigationController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@interface ZJBaseTabBarController ()

@end

@implementation ZJBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setChildrenViewControllers];
}


-(void)setChildrenViewControllers
{
    
    ZJBaseNavigationController * firstNav = [[ZJBaseNavigationController alloc]initWithRootViewController:[FirstViewController new]];
    ZJBaseNavigationController * secondNav = [[ZJBaseNavigationController alloc]initWithRootViewController:[SecondViewController new]];
    ZJBaseNavigationController * thirdNav = [[ZJBaseNavigationController alloc]initWithRootViewController:[ThirdViewController new]];
    ZJBaseNavigationController * fourthNav = [[ZJBaseNavigationController alloc]initWithRootViewController:[FourthViewController new]];
    
    
    firstNav.tabBarItem.title = @"微信";
    firstNav.tabBarItem.image = [UIImage imageNamed:@"home_normal"];
    firstNav.tabBarItem.selectedImage = [UIImage imageNamed:@"home_highlight"];
    
    secondNav.tabBarItem.title = @"通讯录";
    secondNav.tabBarItem.image = [UIImage imageNamed:@"message_normal"];
    secondNav.tabBarItem.selectedImage = [UIImage imageNamed:@"message_highlight"];
    thirdNav.tabBarItem.title = @"发现";
    thirdNav.tabBarItem.image = [UIImage imageNamed:@"mycity_normal"];
    thirdNav.tabBarItem.selectedImage = [UIImage imageNamed:@"mycity_highlight"];
    fourthNav.tabBarItem.title = @"我";
    fourthNav.tabBarItem.image = [UIImage imageNamed:@"account_normal"];
    fourthNav.tabBarItem.selectedImage = [UIImage imageNamed:@"account_highlight"];
    
    self.viewControllers = @[firstNav,secondNav,thirdNav];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:59.0/255.0 green:189.0/255.0 blue:202.0/255.0 alpha:1],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    

}


@end
