//
//  ZJNavgationBarView.h
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCommonMacro.h"

#define NavBar_ViewTitle_Tag   (1412181046)   /// idNavTitle的Tag
#define GMK_NavBar_Btn_W (80)       /// 左右各有一个Button的宽度
#define GMK_TabBar_H    (49)


NS_ASSUME_NONNULL_BEGIN

@interface ZJNavgationBarView : UIView


@property (nonatomic, strong) id            idNavTitle;

/// 标题
@property (nonatomic, strong) UILabel      *labelTitle;

- (id)initWithTitle:(NSString *)strTitle;

- (void)createNavLeftBtnWithItem:(id)idItem;

@property (nonatomic, weak)   UIButton    *btnLeft;
@end

NS_ASSUME_NONNULL_END
