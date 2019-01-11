//
//  AppDelegate+Internal.m
//  Cupid
//
//  Created by panzhijun on 2019/1/8.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "AppDelegate+Internal.h"
#import "ZJBaseNavigationController.h"
#import "HomeViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

#import "ZJTabBarManager.h"

#import "ZJBaseTabBarController.h"


@implementation AppDelegate (Internal)


-(void)initViews
{
    // 创建出示window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    
    [self initTabBarView];
}



// 初始化tabbarview
-(void)initTabBarView
{
    
    ZJBaseTabBarController *tabBarViewController = [ZJBaseTabBarController createTabBarController:^ZJTabBarConfig *(ZJTabBarConfig * _Nonnull config) {
        
        HomeViewController * homeVC = [HomeViewController new];
        SecondViewController * secondVC = [SecondViewController new];
        ThirdViewController * thirdVC = [ThirdViewController new];
        FourthViewController * fourthVC =[FourthViewController new];
        
        config.viewControllers = @[homeVC, secondVC, thirdVC,fourthVC];
        
        config.normalImages = @[@"home_tabbar_night_32x32_",@"video_tabbar_night_32x32_",@"huoshan_tabbar_night_32x32_",@"no_login_tabbar_night_33x32_"];
        config.selectedImages = @[@"home_tabbar_press_32x32_", @"video_tabbar_press_32x32_", @"huoshan_tabbar_press_32x32_",@"no_login_tabbar_press_33x32_"];
        config.titles = @[@"首页",@"西瓜视频",@"小视频",@"未登录"];
        
        config.isNavigation = NO;
        return config;
    }];
    ZJBaseNavigationController *navRoot = [[ZJBaseNavigationController alloc]initWithRootViewController:tabBarViewController];
    navRoot.hidesBottomBarWhenPushed = YES;
    navRoot.tabBarController.tabBar.hidden = YES;
    self.window.rootViewController = navRoot;
    [self.window makeKeyAndVisible];
}


@end
