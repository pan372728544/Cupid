//
//  HomeCategoryAddView.h
//  Cupid
//
//  Created by panzhijun on 2019/1/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CategoryAddViewDelegate <NSObject>

-(void)clickAddCategory;

@end

@interface HomeCategoryAddView : UIView
@property(nonatomic,weak)id<CategoryAddViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
