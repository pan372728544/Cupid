//
//  ZJBaseViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/3.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBaseViewController.h"
#import "ZJBasePopAnimation.h"
#import "ZJBasePushAnimation.h"


@interface ZJBaseViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

// 百分比交互
@property(nonatomic,strong)UIPercentDrivenInteractiveTransition *interactiveTransition;

// pop动画
@property(nonatomic,strong) ZJBasePopAnimation *popAnimation;


@property(nonatomic,strong) ZJBasePushAnimation *pushAnimation;


@end

@implementation ZJBaseViewController


-(id)init
{
    if (self = [super init]) {
        _isOpenTransiton = YES;
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.delegate = self;
    
    self.view.userInteractionEnabled = YES;
    // 添加手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(customControllerPopHandle:)];
    [self.view addGestureRecognizer:panGesture];
    panGesture.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = false;

    self.popAnimation = [[ZJBasePopAnimation alloc]init];

    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}


// 表示的意思是:当挡墙控制器是根控制器了,那么就不接收触摸事件,只有当不是根控制器时才需要接收事件.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.navigationController.childViewControllers.count > 1;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

-(void)setIsOpenTransiton:(BOOL)isOpenTransiton
{
    _isOpenTransiton = isOpenTransiton;
    
}

-(void)setTypeAnimation:(PopAnimationType)typeAnimation
{
    _typeAnimation = typeAnimation;
    
    self.popAnimation.popType = _typeAnimation;
    
}


// pan手势
- (void)customControllerPopHandle:(UIPanGestureRecognizer *)recognizer
{
    if(self.navigationController.childViewControllers.count == 1)
    {
        return;
    }
    
    // 执行delegate
//    if (self.delegate && [self.delegate respondsToSelector:@selector(panGesture:)]) {
//        [self.delegate panGesture:recognizer];
//    }
    // _interactiveTransition就是代理方法2返回的交互对象，我们需要更新它的进度来控制POP动画的流程。（以手指在视图中的位置与屏幕宽度的比例作为进度）
    CGFloat process =fabs( [recognizer translationInView:self.navigationController.view].x/self.view.bounds.size.width);
//    NSLog(@"%f===== %f",[recognizer translationInView:self.view].x,process);
     if ([recognizer translationInView:self.navigationController.view].x <=0) {
         process = 0;
     }

    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        // 此时，创建一个UIPercentDrivenInteractiveTransition交互对象，来控制整个过程中动画的状态
        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        // 滑动方向向右的时候才会更新百分比
//        if ([recognizer translationInView:self.navigationController.view].x >=0) {
            [_interactiveTransition updateInteractiveTransition:process]; // 更新手势完成度
//        }

    }
    else if(recognizer.state == UIGestureRecognizerStateEnded ||recognizer.state == UIGestureRecognizerStateCancelled)
    {
            // 手势结束时，若进度大于0.2就完成pop动画，否则取消
            if(process > 0.2)
            {
                [_interactiveTransition finishInteractiveTransition];
//                MYLog(@"11111111");
            }
            else
            {
                [_interactiveTransition cancelInteractiveTransition];
//                     MYLog(@"22222");
            }
        
        _interactiveTransition = nil;
    }
}

#pragma 代理方法 UINavigationControllerDelegate

// 代理方法1：
// 返回一个实现了UIViewControllerAnimatedTransitioning协议的对象  ，即完成转场动画的对象
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if(operation == UINavigationControllerOperationPop) // 若operation是pop，就返回我们自定义的转场动画对象
    {
        return self.popAnimation;
    }

    
    return nil;
}


// 代理方法2
// 返回一个实现了UIViewControllerInteractiveTransitioning协议的对象，即完成动画交互（动画进度）的对象
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if([animationController isKindOfClass:[ZJBasePopAnimation class]])
    {
        return _interactiveTransition;
    }
    return nil;
}



@end
