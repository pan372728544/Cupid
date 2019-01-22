//
//  FeedWeiboTableViewCell.h
//  Cupid
//
//  Created by panzhijun on 2019/1/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedNewContentModel.h"

@class  FeedNewContentModel;

@protocol WeiboTableViewCellDelegate <NSObject>

-(void)clickImgShow:(NSInteger)tag imgS:(NSArray *)imgs;

-(void)zangClick:(id)sender;

-(void)clickDetail:(id)sender;
@optional
-(void)clickImg;


@end

NS_ASSUME_NONNULL_BEGIN

@interface FeedWeiboTableViewCell : UITableViewCell

-(void)setModelDataWith:(FeedNewContentModel*)model;
@property(nonatomic,weak)id<WeiboTableViewCellDelegate>delegate;
+(NSString*)shortShow:(NSNumber*)count;

@end

NS_ASSUME_NONNULL_END
