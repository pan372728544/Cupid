//
//  ZJTabBarManager.h
//  Cupid
//
//  Created by panzhijun on 2019/1/8.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJBaseTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJTabBarManager : NSObject

+(ZJTabBarManager *)shareInstance;

// 设置VC数组
- (void)setViewControllersArray:(NSArray *)aryVC;


@property(nonatomic,strong)UIWindow *internalWindow;

@end

NS_ASSUME_NONNULL_END
