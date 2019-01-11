//
//  ZJTabBar.h
//  Cupid
//
//  Created by panzhijun on 2019/1/8.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZJTabBarItem;
@protocol ZJTabBarDelegate;




@interface ZJTabBar : UIView

// tabbar各个Item
@property (nonatomic, strong)NSArray<ZJTabBarItem *> *items;
// 代理
@property (nonatomic, assign)id <ZJTabBarDelegate> delegate;

@end

@protocol ZJTabBarDelegate <NSObject>

// 选中第一个item
- (void)tabBar:(ZJTabBar *)tab didSelectItem:(ZJTabBarItem *)item atIndex:(NSInteger)index ;

@end

// ********************************************************
#pragma mark - ZJTabBarItem

typedef enum : NSUInteger {
    ZJTabBarItemTypeDefault,
    ZJTabBarItemTypeImage,
    ZJTabBarItemTypeText,
} ZJTabBarItemType;

@protocol ZJTabBarItemDelegate;

@interface ZJTabBarItem : UIView

// 图标
@property (nonatomic, copy) NSString *icon;
// 标题
@property (nonatomic, copy) NSString *title;
// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
// item类型
@property (nonatomic, assign) ZJTabBarItemType type;
// item代理
@property (nonatomic, assign) id <ZJTabBarItemDelegate> delegate;


@end

@protocol ZJTabBarItemDelegate <NSObject>




// 选中了哪个item
- (void)tabBarItem:(ZJTabBarItem *)item didSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
