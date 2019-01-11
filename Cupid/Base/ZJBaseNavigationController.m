//
//  ZJBaseNavigationController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/3.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBaseNavigationController.h"
#import "ZJBaseTabBarController.h"

@interface ZJBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ZJBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    
    if (self == [super initWithRootViewController:rootViewController]) {
        
        self.navigationBar.hidden = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor clearColor];
    self.tabBarController.tabBar.hidden = YES;

}



-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{


    [super pushViewController:viewController animated:animated];
}


-(nullable UIViewController *)popViewControllerAnimated:(BOOL)animated
{
//   self.tabBarController.tabBar.hidden = YES;
  return   [super popViewControllerAnimated:animated];
}
@end
