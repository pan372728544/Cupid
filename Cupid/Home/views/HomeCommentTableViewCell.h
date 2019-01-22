//
//  HomeCommentTableViewCell.h
//  Cupid
//
//  Created by panzhijun on 2019/1/18.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtileInfomationCommentListModel;

NS_ASSUME_NONNULL_BEGIN

@interface HomeCommentTableViewCell : UITableViewCell
@property(nonatomic,copy)NSString *strUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;


@property(nonatomic,strong) ArtileInfomationCommentListModel *model;

@end

NS_ASSUME_NONNULL_END
