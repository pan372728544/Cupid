//
//  ZJBaseViewController+NavBar.h
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJBaseViewController (NavBar)

// 创建标题
- (void)createNavBarViewWithTitle:(id)idTitle;

// 左侧按钮
- (void)createNavLeftBtnWithItem:(id)idItem target:(id)target action:(SEL)selAction;

-(void)setNavigationViewBackgroundColor:(UIColor *)bgcolor;

@end

NS_ASSUME_NONNULL_END
