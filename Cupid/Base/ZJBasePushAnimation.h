//
//  ZJBasePushAnimation.h
//  Cupid
//
//  Created by panzhijun on 2019/1/8.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,PushAnimationType)
{
    
    PushAnimationTypeDefault,
    PushAnimationTypeFollow,
    
};

NS_ASSUME_NONNULL_BEGIN

@interface ZJBasePushAnimation : NSObject<UIViewControllerAnimatedTransitioning>


// push类型
@property(nonatomic,assign)PushAnimationType pushType;

@end

NS_ASSUME_NONNULL_END
