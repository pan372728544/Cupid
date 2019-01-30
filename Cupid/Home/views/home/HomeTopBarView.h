//
//  HomeTopBarView.h
//  Cupid
//
//  Created by panzhijun on 2019/1/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^closeSearchViewList)();

@interface HomeTopBarView : UIView


@property(nonatomic,strong) ZJBaseViewController *superVC;



@property(nonatomic,copy)closeSearchViewList closeView;


@end

NS_ASSUME_NONNULL_END
