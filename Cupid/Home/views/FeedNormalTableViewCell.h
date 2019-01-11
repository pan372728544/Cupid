//
//  FeedNormalTableViewCell.h
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedNewContentModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface FeedNormalTableViewCell : UITableViewCell

-(void)setModelDataWith:(FeedNewContentModel*)model;

@end

NS_ASSUME_NONNULL_END
