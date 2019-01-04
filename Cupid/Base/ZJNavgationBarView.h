//
//  ZJNavgationBarView.h
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCommonMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJNavgationBarView : UIView
- (id)initWithTitle:(NSString *)strTitle;

- (void)createNavLeftBtnWithItem:(id)idItem;

@property (nonatomic, weak)   UIButton    *btnLeft;
@end

NS_ASSUME_NONNULL_END
