//
//  ZJBasePresentViewController.h
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJBasePresentViewController : UIViewController



// 是否支持向右滑动返回（默认不支持，默认为NO）
@property(nonatomic,assign)BOOL isSupportRightSlide;


@property(nonatomic,assign)BOOL isUp;

@property(nonatomic,assign)BOOL isRight;


// 距离顶部的高度 默认状态栏高度
@property(nonatomic,assign)CGFloat heightTop;

@end

NS_ASSUME_NONNULL_END
