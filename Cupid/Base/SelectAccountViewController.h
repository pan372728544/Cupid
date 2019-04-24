//
//  SelectAccountViewController.h
//  Cupid
//
//  Created by panzhijun on 2019/4/24.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBasePresentViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CompletedBlock)(void);
@interface SelectAccountViewController : ZJBasePresentViewController
@property(nonatomic,copy)CompletedBlock completedBlock;
@end

NS_ASSUME_NONNULL_END
