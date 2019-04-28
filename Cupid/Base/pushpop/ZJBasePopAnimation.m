//
//  ZJBasePopAnimation.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBasePopAnimation.h"
#import "ZJCommonMacro.h"
#import "SearchBarView.h"

@implementation ZJBasePopAnimation

// 返回动画执行的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2;
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
    vc.view.layer.shadowOffset = CGSizeMake(-5,0);
    // 半径
    vc.view.layer.shadowRadius = 3;
    // 透明度
    vc.view.layer.shadowOpacity = 0.2;
    
    
    UIView *viewCover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    viewCover.backgroundColor = [UIColor blackColor];
    viewCover.alpha = 0.6;
    [toVC.view addSubview:viewCover];
    
    // 转场动画是两个控制器视图的动画，需要一个containerView作为“舞台”
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];


    
    
    // 获取动画执行时间（实现的协议方法）
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // 动画类型
    switch (_popType) {
        case PopAnimationTypeDefault:
        {
          
            CATransform3D transformSclae = CATransform3DMakeScale(0.97, 0.97, 1.0);

            toVC.view.layer.transform = transformSclae;
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                fromVC.view.transform = CGAffineTransformMakeTranslation(SCREEN_W,0);
                CATransform3D transformSclae = CATransform3DMakeScale(1.0, 1.0, 1.0);
                toVC.view.layer.transform = transformSclae;
                viewCover.alpha = 0;
  
            } completion:^(BOOL finished) {
                fromVC.view.transform = CGAffineTransformIdentity;
                toVC.view.transform = CGAffineTransformIdentity;
                ;
                [viewCover removeFromSuperview];
                // 当动画执行完时，这个方法必须要调用，否则系统会认为你的其余操作都在动画执行过程中
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
            
        }
            break;
        case PopAnimationTypeFollow:
        {
        
            
            toVC.view.transform = CGAffineTransformMakeTranslation(-SCREEN_W, 0);
            
            
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                fromVC.view.transform = CGAffineTransformMakeTranslation(SCREEN_W,0);
                toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                fromVC.view.transform = CGAffineTransformIdentity;
                toVC.view.transform = CGAffineTransformIdentity;
                
                [viewCover removeFromSuperview];
                // 当动画执行完时，这个方法必须要调用，否则系统会认为你的其余操作都在动画执行过程中
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
            
        }
            break;
            
        case PopAnimationTypeSearch:
        {
            
            UIView *viewNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, NAVBAR_IPHONEX_H)];
            viewNav.backgroundColor = COLOR_COMMONRED;
            SearchBarView *search = [[SearchBarView alloc]initWithFrame:CGRectMake(50, STATUSBAR_H+(NAVBAR_H-SearchBar_H)/2, SCREEN_W-100, SearchBar_H)];
    
            UIView *viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, STATUSBAR_H, SCREEN_W, NAVBAR_H)];
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(14, (NAVBAR_H-24)/2, 24, 24)];
            imgV.image = [UIImage imageNamed:@"arrow-left-white-24_24x24_"];
            
            [viewBack addSubview:imgV];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(viewBack.width-30-16,(NAVBAR_H-20)/2 , 34, 20)];
            label.text = @"搜索";
            label.textColor = [UIColor whiteColor];
            label.font = NAV_Btn_Font;
            [viewBack addSubview:label];
            
            
            [viewNav addSubview:viewBack];
            
               [viewNav addSubview:search];
            
            [containerView addSubview:viewNav];
 
            
            toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
            

            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                fromVC.view.transform = CGAffineTransformMakeTranslation(SCREEN_W,0);
                search.frame =  CGRectMake(15, STATUSBAR_H+(NAVBAR_H-SearchBar_H)/2, SCREEN_W-30, SearchBar_H);
                viewCover.alpha = 0;
                viewBack.alpha = 0.2;
                viewBack.transform = CGAffineTransformMakeScale(0.94, 0.94);
    
            } completion:^(BOOL finished) {
                fromVC.view.transform = CGAffineTransformIdentity;
                toVC.view.transform = CGAffineTransformIdentity;
                
                [viewCover removeFromSuperview];
                
                [viewNav removeFromSuperview];
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
