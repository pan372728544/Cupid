//
//  ZJBaseViewController.h
//  Cupid
//
//  Created by panzhijun on 2019/1/3.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNavgationBarView.h"
//#import "ZJBaseViewController+NavBar.h"
#import "CommonHeader.h"


@protocol BaseViewControllerPangestureDelegate <NSObject>

- (void) panGesture:(UIPanGestureRecognizer *)pan;

@end


NS_ASSUME_NONNULL_BEGIN

@interface ZJBaseViewController : UIViewController

/// 自定义NavBar
@property (nonatomic, strong) ZJNavgationBarView *superNavBarView;


// 设置动画类型
@property(nonatomic,assign) BOOL isOpenTransiton;


@property(nonatomic,assign) PopAnimationType typeAnimation;


@property(nonatomic,weak)id<BaseViewControllerPangestureDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
