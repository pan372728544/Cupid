//
//  LoginViewController.h
//  Cupid
//
//  Created by panzhijun on 2019/3/7.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBasePresentViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^enterBlock)(NSString *nickName,NSString *type);
@interface LoginViewController : ZJBasePresentViewController
@property(nonatomic,copy)enterBlock block;
@end

NS_ASSUME_NONNULL_END
