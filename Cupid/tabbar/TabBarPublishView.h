//
//  TabBarPublishView.h
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^closeViewBlock)(void);

typedef void(^pubClickBlock)(NSInteger num);

NS_ASSUME_NONNULL_BEGIN

@interface TabBarPublishView : UIView


@property(nonatomic,copy) closeViewBlock myBlock ;


@property(nonatomic,copy) pubClickBlock pubBlock ;

@end

NS_ASSUME_NONNULL_END
