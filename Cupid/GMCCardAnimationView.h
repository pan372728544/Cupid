//
//  GMCCardAnimationView.h
//  Cupid
//
//  Created by panzhijun on 2019/4/2.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



/**
 卡片数据源协议
 */
@protocol GMDCardViewDataSource <NSObject>


@required
/**
 获取卡片的数量
 
 @return 返回卡片数量
 */
-(NSInteger)numberOfCountInCardView;

@optional
/**
 设置卡片视图的数据内容
 
 @param index 索引位置的数据
 @return 返回数据内容
 */
-(id)cardViewDisplayDataForCardViewAtIndex:(NSInteger)index;

@end


/**
 卡片视图代理协议
 */
@protocol GMDCardViewDelegate <NSObject>


@optional

/**
 卡片视图点击的代理
 
 @param index 点击的索引
 */
-(void)cardViewClickCardAtIndex:(NSInteger)index;


/**
 卡片滑动的代理
 
 @param index 滑动之后的索引
 */
-(void)cardViewScrollViewCardAtIndex:(NSInteger)index;


@end


@interface GMCCardAnimationView : UIView


/**
 卡片数据
 */
@property (nonatomic, strong)NSArray<id> *cardDataAry;


/**
 卡片数据源
 */
@property (nonatomic, weak)id<GMDCardViewDataSource>dataSource;

/**
 卡片代理
 */
@property (nonatomic, weak)id<GMDCardViewDelegate>delegate;



/**
 初始化卡片
 
 @param frame 设置frame
 @param maxCount 最大显示的卡片数量
 @return 卡片
 */
-(id)initWithFrame:(CGRect)frame maxCount:(NSInteger)maxCount;

/**
 刷新数据
 */
-(void)reloadDataWithOffsetIndex:(NSInteger)index;



@end

NS_ASSUME_NONNULL_END
