//
//  HomeRequest.h
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeRequest : NSObject


+(NSString *)getHomeCategoryTitleUrl;


+(NSString *)getHomeFeedNewsUrl;


// 详情页请求
+(NSString *)getHomeArticleInformationUrl;

+(NSDictionary *)getCommonParamDic;
@end

NS_ASSUME_NONNULL_END
