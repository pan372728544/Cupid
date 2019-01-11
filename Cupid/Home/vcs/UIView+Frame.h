//
//  UIView+Frame.h
//  Cupid
//
//  Created by panzhijun on 2019/1/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
