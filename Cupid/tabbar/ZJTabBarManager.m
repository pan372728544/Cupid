//
//  ZJTabBarManager.m
//  Cupid
//
//  Created by panzhijun on 2019/1/8.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJTabBarManager.h"
#import "ZJBaseNavigationController.h"


@interface ZJTabBarManager()

/// 所有导航Nav
@property (nonatomic, strong) NSMutableArray *controllers;
@end


@implementation ZJTabBarManager


+(ZJTabBarManager *)shareInstance
{
    
    static ZJTabBarManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ZJTabBarManager alloc]init];
        
    });
    return manager;
}


- (void)setViewControllersArray:(NSArray *)aryVC
{
    if (aryVC.count <=0)
    {
        return;
    }
    _controllers = [aryVC mutableCopy];
    
    [self initViewControllers];     //初始化ViewControllers
    
}

-(void)setInternalWindow:(UIWindow *)internalWindow
{
    _internalWindow = internalWindow;
}

- (void)initViewControllers
{
    ZJBaseNavigationController *nav = [_controllers objectAtIndex:0];

    self.internalWindow.rootViewController = nav;
    [self.internalWindow makeKeyAndVisible];
}
@end
