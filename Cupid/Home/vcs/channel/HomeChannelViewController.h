//
//  HomeChannelViewController.h
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBasePresentViewController.h"
@class HomeChannelModel;

NS_ASSUME_NONNULL_BEGIN
/**
 选择出来的tags们
 
 @param tags 数组里都是对象
 */
typedef void(^ChoosedTags)(NSArray *chooseTags,NSArray *recommandTags);


/**
 单独选择的tag
 
 @param channel channel对象
 */
typedef void(^SelectedTag)(HomeChannelModel *channel);


@interface HomeChannelViewController : ZJBasePresentViewController
@property (nonatomic, copy) ChoosedTags choosedTags ;

@property (nonatomic, copy) SelectedTag selectedTag ;
@end

NS_ASSUME_NONNULL_END
