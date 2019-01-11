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
    
    self.navigationController.delegate = self;
    
    self.view.userInteractionEnabled = YES;
    // 添加手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(customControllerPopHandle:)];
    [self.view addGestureRecognizer:panGesture];
    panGesture.delegate = self;
    
    self.popAnimation = [[ZJBasePopAnimation alloc]init];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

-(void)setIsOpenTransiton:(BOOL)isOpenTransiton
{
    _isOpenTransiton = isOpenTransiton;
    
}

// pan手势
- (void)customControllerPopHandle:(UIPanGestureRecognizer *)recognizer
{
    if(self.navigationController.childViewControllers.count == 1)
    {
        return;
    }
    // _interactiveTransition就是代理方法2返回的交互对象，我们需要更新它的进度来控制POP动画的流程。（以手指在视图中的位置与屏幕宽度的比例作为进度）
    CGFloat process = [recognizer translationInView:self.view].x/self.view.bounds.size.width;
    process = MIN(1.0, MAX(0.0, process));
    
//    NSLog(@"%f===== %f",[recognizer translationInView:self.view].x,self.view.bounds.size.width);
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        // 此时，创建一个UIPercentDrivenInteractiveTransition交互对象，来控制整个过程中动画的状态
        _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        [_interactiveTransition updateInteractiveTransition:process]; // 更新手势完成度
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded ||recognizer.state == UIGestureRecognizerStateCancelled)
    {
        // 手势结束时，若进度大于0.2就完成pop动画，否则取消
        if(process > 0.2)
        {
            [_interactiveTransition finishInteractiveTransition];
        }
        else
        {
            [_interactiveTransition cancelInteractiveTransition];
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
