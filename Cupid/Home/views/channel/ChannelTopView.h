//
//  ChannelTopView.h
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelTopView : UIView

@property(nonatomic,copy) void(^blockClickClose)(void);

@end

NS_ASSUME_NONNULL_END
