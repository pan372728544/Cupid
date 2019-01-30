//
//  HomeChannelCollectionViewCell.h
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeChannelModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ChannelCellDeleteDelegate

- (void)deleteCell:(UIButton *)sender;

@end

@interface HomeChannelCollectionViewCell : UICollectionViewCell

/**
 样式
 */
@property (nonatomic, assign) ChannelType style ;

/**
 标题
 */
@property (nonatomic, strong) UILabel *title ;
/** 右上角的删除按钮 */
@property (nonatomic, strong) UIButton * delBtn ;


@property (nonatomic, assign) id <ChannelCellDeleteDelegate> delegate ;

@property (nonatomic, strong) HomeChannelModel *model ;

@end

NS_ASSUME_NONNULL_END
