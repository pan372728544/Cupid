//
//  ZJBaseNavigationController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/3.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBaseNavigationController.h"

@interface ZJBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ZJBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    
    if (self == [super initWithRootViewController:rootViewController]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor clearColor];

}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
