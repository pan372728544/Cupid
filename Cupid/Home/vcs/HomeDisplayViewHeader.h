//
//  HomeDisplayViewHeader.h
//  Cupid
//
//  Created by panzhijun on 2019/1/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#ifndef HomeDisplayViewHeader_h
#define HomeDisplayViewHeader_h



// 导航条高度
static CGFloat const NavBarH = 64;

// 标题滚动视图的高度
static CGFloat const TitleScrollViewH = 44;

// 标题缩放比例
static CGFloat const TitleTransformScale = 1.3;

// 下划线默认高度
static CGFloat const UnderLineH = 2;


// 默认标题字体
#define TitleFont [UIFont systemFontOfSize:16]

// 默认标题间距
static CGFloat const margin = 15;

// 标题被点击或者内容滚动完成，会发出这个通知，监听这个通知，可以做自己想要做的事情，比如加载数据
static NSString * const DisplayViewClickOrScrollDidFinshNote = @"DisplayViewClickOrScrollDidFinshNote";

// 重复点击通知
static NSString * const DisplayViewRepeatClickTitleNote = @"DisplayViewRepeatClickTitleNote";


#endif /* HomeDisplayVIewHeader_h */
