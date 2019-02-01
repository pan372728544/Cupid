//
//  FeedFocusonTableViewCell.h
//  Cupid
//
//  Created by panzhijun on 2019/1/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedNewContentModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface FeedFocusonTableViewCell : UITableViewCell

//-(void)setDataWithModel:(FeedNewContentModel*)model;

@property(nonatomic,strong) FeedNewContentModel *model;

@end

NS_ASSUME_NONNULL_END
