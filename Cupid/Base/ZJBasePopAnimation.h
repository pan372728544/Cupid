//
//  ZJBasePopAnimation.h
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PopAnimationType)
{
    
    PopAnimationTypeDefault,
    PopAnimationTypeFollow,
    
};

@interface ZJBasePopAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property(nonatomic,assign)PopAnimationType popType;
@end

NS_ASSUME_NONNULL_END
