//
//  ZJPresentAnimation.h
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJPresentAnimation : NSObject <UIViewControllerAnimatedTransitioning>
//用于记录控制器是创建还是销毁
@property (nonatomic, assign ) BOOL presented;
@end

NS_ASSUME_NONNULL_END
