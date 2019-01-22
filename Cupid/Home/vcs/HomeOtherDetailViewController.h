//
//  HomeOtherDetailViewController.h
//  Cupid
//
//  Created by panzhijun on 2019/1/17.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeOtherDetailViewController : ZJBaseViewController

@property(nonatomic,strong)NSNumber *group_id;
@property(nonatomic,strong)NSNumber *item_id;
@property(nonatomic,copy)NSString *category;
@end

NS_ASSUME_NONNULL_END
