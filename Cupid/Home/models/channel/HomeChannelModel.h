//
//  HomeChannelModel.h
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 cell类型
 
 - MyChannel: 我的频道样式 不带“+”的
 - RecommandChannel: 推荐频道样式 带“+”的
 */
typedef NS_ENUM(NSUInteger, ChannelType) {
    MyChannel,
    RecommandChannel,
};

@interface HomeChannelModel : NSObject


@property (nonatomic, assign) BOOL resident ;
@property (nonatomic, assign) BOOL editable ;

@property (nonatomic, strong) NSString *title ;

@property (nonatomic, assign) BOOL selected ;

@property (nonatomic, assign) ChannelType tagType ;

@end

NS_ASSUME_NONNULL_END
