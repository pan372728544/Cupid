//
//  RequestConst.h
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestConst : NSObject

//************************** 接口URL ******************************//
extern NSString * URLHostURL;                   // 主地址
extern NSString *const URLVersion_Code;              // 接口版本
extern NSString *const URLVid;
extern NSString *const URLDriveID;
extern NSString *const URLOpenudid;
extern NSString *const URLIdfv;
extern NSString *const URLIid;


extern NSString *const URLCategoryTitlesURL;              // 获取导航分类
extern NSString *const URLCategoryExtra;                 //获取导航标题 扩展
extern NSString *const URLCategoryRecommend;             //获得推荐的关注列表
extern NSString *const URLSearchSuggest;                 //搜索建议
extern NSString *const URLFocusonUser;                   //关注某人
extern NSString *const URLUnFocusonUser;                 //取消关注某人
extern NSString *const URLGetFeedNews;                   //取feed数据
extern NSString *const URLZangWeibo;                     //点赞某条微博
extern NSString *const URLGetWeiboContent;               //获取微博内容的正文数据

extern NSString *const URLCategoryTitleModelMe;
extern NSString *const URLCategoryTitleModelOther;


@end

NS_ASSUME_NONNULL_END
