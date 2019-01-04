//
//  ZJBasePopAnimation.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBasePopAnimation.h"
#import "ZJCommonMacro.h"


@implementation ZJBasePopAnimation

// 返回动画执行的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 来自哪个VC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 到哪个VC
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //设置fromvc的阴影
    UIViewController *vc = fromVC;
    // 阴影颜色
    vc.view.layer.shadowColor = [UIColor blackColor].CGColor;
    // 偏移量
    vc.view.layer.shadowOffset = CGSizeMake(-10,0);
    // 半径
    vc.view.layer.shadowRadius = 5;
    // 透明度
    vc.view.layer.shadowOpacity = 0.3;
    
    // 转场动画是两个控制器视图的动画，需要一个containerView作为“舞台”
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    // 获取动画执行时间（实现的协议方法）
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // 动画类型
    switch (_popType) {
        case PopAnimationTypeDefault:
        {
            // 执行动画，让fromVC的view移动到屏幕最右侧
            [UIView animateWithDuration:duration animations:^{
                fromVC.view.transform = CGAffineTransformMakeTranslation(SCREEN_W,0);
            } completion:^(BOOL finished) {
                fromVC.view.transform = CGAffineTransformIdentity;
                // 当动画执行完时，这个方法必须要调用，否则系统会认为你的其余操作都在动画执行过程中
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
            
        }
            break;
            
        case PopAnimationTypeFollow:
        {
            toVC.view.transform = CGAffineTransformMakeTranslation(-SCREEN_W, 0);
            [UIView animateWithDuration:duration animations:^{
                fromVC.view.transform = CGAffineTransformMakeTranslation(SCREEN_W,0);
                toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                fromVC.view.transform = CGAffineTransformIdentity;
                toVC.view.transform = CGAffineTransformIdentity;
                // 当动画执行完时，这个方法必须要调用，否则系统会认为你的其余操作都在动画执行过程中
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
            
        }
            break;
            
        default:
            break;
    }
}

@end
