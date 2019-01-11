//
//  ZJBaseViewController+NavBar.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBaseViewController+NavBar.h"
#import "ZJNavgationBarView.h"

@implementation ZJBaseViewController (NavBar)


- (void)createNavBarViewWithTitle:(id)idTitle
{
    if (!self.superNavBarView)
    {
        /// 创建导航栏
        self.superNavBarView = [[ZJNavgationBarView alloc] initWithTitle:@""];
        [self.view addSubview:self.superNavBarView];
    }
    
    /// 设置中间标题
    [self.superNavBarView setIdNavTitle:idTitle];
}


- (void)createNavLeftBtnWithItem:(id)idItem target:(id)target action:(SEL)selAction
{
    
    
    [self.superNavBarView createNavLeftBtnWithItem:idItem];
    
    [self.superNavBarView.btnLeft addTarget:target
                                     action:selAction
                           forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setNavigationViewBackgroundColor:(UIColor *)bgcolor
{
    self.superNavBarView.backgroundColor = bgcolor;
}

@end
