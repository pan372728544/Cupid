//
//  ZJBasePresentViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBasePresentViewController.h"
#import "ZJPresentAnimation.h"
#import "ZJPresentationController.h"

@interface ZJBasePresentViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition*
interactiveTransition;

@property (nonatomic, strong)ZJPresentationController *presentVC;

@end

@implementation ZJBasePresentViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        // 设置代理和present样式
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    //添加手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] init];
    pan.delegate = self;
    [pan addTarget:self action:@selector(panGestureRecognizerAction:)];
    self.view.tag = 10001;
    [self.view addGestureRecognizer:pan];
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan
{
    //产生百分比
    CGFloat process = ([pan translationInView:self.view].y) / ([UIScreen mainScreen].bounds.size.height);
//    NSLog(@"%f  = %f",[pan translationInView:self.view].y,[pan translationInView:self.view].x);
    process = MIN(1.0,(MAX(0.0, process)));
    
    
//    self.presentVC.presentedView.backgroundColor = [UIColor clearColor];
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
        //触发dismiss转场动画
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        [self.interactiveTransition updateInteractiveTransition:process];
    }
    else if (pan.state == UIGestureRecognizerStateEnded
             || pan.state == UIGestureRecognizerStateCancelled)
    {
        if (process >= 0.3)
        {
            [ self.interactiveTransition finishInteractiveTransition];
        }
        else
        {
            [ self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;
    }
}


#pragma mark - UIViewControllerTransitioningDelegate
//设置继承自UIPresentationController 的自定义类的属性
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    
    ZJPresentationController *presentVC = [[ZJPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    // 设置距离顶部的高度
    presentVC.height = STATUSBAR_H;
//    presentVC.colorBack = [UIColor blackColor];
    self.presentVC = presentVC;
    
    return presentVC;
}

//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //创建实现UIViewControllerAnimatedTransitioning协议的类（命名为AnimatedTransitioning）
    ZJPresentAnimation *animation = [[ZJPresentAnimation alloc] init];

    //将其状态改为出现
    animation.presented = YES;
    return animation;
}

//控制器销毁执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{

    ////创建实现UIViewControllerAnimatedTransitioning协议的类（命名为AnimatedTransitioning）
    ZJPresentAnimation *animation = [[ZJPresentAnimation alloc] init];

    //将其状态改为出现
    animation.presented = NO;
    return animation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.interactiveTransition;
}

@end
