//
//  HomeRequest.m
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeRequest.h"
#import "RequestConst.h"
#import <UIKit/UIKit.h>

@implementation HomeRequest



+(NSString *)getHomeCategoryTitleUrl
{
    
    return [NSString stringWithFormat:@"%@%@",URLHostURL,URLCategoryTitlesURL];
}


+(NSString *)getHomeFeedNewsUrl
{
    return [NSString stringWithFormat:@"%@%@",URLHostURL,URLGetFeedNews];
    
}


+(NSString *)getHomeArticleInformationUrl
{
    return [NSString stringWithFormat:@"%@%@",URLHostURL,URLGetAritcleInformation];
    
}

#pragma mark --- 获取当前时间戳---10位
+ (NSString *)getNowTime{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", time];
    return timeSp;
}



+(NSDictionary *)getCommonParamDic
{

    NSString *time = [self getNowTime];
    
       NSDictionary *dic =@{
                             
                             @"fp":@"F2TqPzKtP2wbFlDqLlU1FYweLlqM",
                             @"version_code":@"7.0.9",
                             @"tma_jssdk_version":@"1.10.6.2",
                             @"app_name":@"news_article",
                             @"vid":@"B3DD620A-6EFA-4961-A418-B3DD620A",
                             @"device_id":@"52323627854",
                             @"channel":@"App Store",
                             @"resolution":@"1125*2436",
                             @"aid":@"13",
                             @"ab_feature":@"201617,z1",
                             @"ab_version":@"722943,725633,554836,726625,713351,549647,31644,644057,615291,606548,681182,718211,725844,724439,546703,693713,281300,678045,677809,325612,665474,696624,625066,662509,691551,696990,698915,719924,724220,638335,467516,721537,679101,714968,720588,725676,595556,670151,661452,725839,698629,660830,688723,726472,720615,726422,714231,486950,705041,662176,448104,684437,680424,674052,612191,691934,170988,643890,715017,710426,374117,598327,718154,655402,721749,674789,613175,550042,717798,687744,721670,649429,716846,614100,677128,685525,522765,701304,704639,416055,716149,710077,684976,707372,693247,709811,558139,711975,471406,603441,709681,721265,710110,603384,603397,603404,603406,722583,722312,719101,661899,706064,668775,721029,688066,693467,726062,701982,709786,706369,607361,708215,666967,698916,635529,711149,662099,631167,710032,725695,703077,723420,709416,724952,706624,717949,722116,668774,709516,717721,718826,726434,722669,586956,633486,661781,457481,649402,690898",
                             
                             @"ab_group":@"z2",
                             @"openudid":@"5326e05065bd38f79fc442f83ac49b30463c8906",
                             @"update_version_code":@"70901",
                             @"idfv":@"B3DD620A-6EFA-4961-A418-B3DD620A",
                             @"ac":@"WIFI",
                             @"os_version":@"12.0",
                             @"ssmix":@"a",
                             @"device_platform":@"iphone",
                             @"iid":@"533333232156",
                             @"ab_client":@"a1,f2,f7,e1",
                             @"device_type":@"iPhone 8",
                             @"idfa":@"00000000-0000-0000-0000-000000000000",
                             @"article_page":@"0",
                             @"device_id":@"52323627854",
                             @"aggr_type":@"1",
                             @"mas":@"003c018d83083b2801fceb1855611c30fedd7394974cc1a5501062",
                             @"as":@"a2a5b394caa63cc4f16877",
                             @"ts":time,
 
                             };
    
    
    
    return dic;
    
    
}




@end
