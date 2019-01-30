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
                             @"version_code":@"7.0.6",
                             @"app_name":@"news_article",
                             @"vid":@"B7UDD620A-8UHJ-0987-JI90-CPID1FD7DA3F",
                             @"device_id":@"19028678356",
                             @"channel":@"App Store",
                             @"resolution":@"1125*2436",
                             @"aid":@"13",
                             @"ab_feature":@"201617,z1",
                             @"ab_version":@"690189,699470,677774,700437,341311,486953,698709,662176,684444,681604,684577,571131,665175,674051,594581,612194,691934,170988,643891,374117,585071,598325,688265,655402,702076,674789,668155,550042,690817,659314,698261,654106,700775,690973,649426,614099,677128,685525,522766,701304,416055,684977,689886,693249,558140,696291,471407,603443,700489,596392,660508,598626,701730,700540,686885,701724,603381,603400,603403,603405,638926,699225,696109,703265,661901,662644,703737,668775,673945,692063,691477,693468,629152,607361,609338,666964,698916,635530,689186,662099,696793,701081,660836,671244,702746,684651,703077,697041,685885,677227,703339,704524,684052,697022,681791,668774,683803,698097,674226,554836,694757,549647,699616,698347,572465,482358,644058,615292,606549,681185,704707,673168,685932,642579,546701,693714,281294,679601,325618,678477,665473,690848,664733,669035,700459,625065,662507,691553,696990,698915,700040,680282,638335,467513,697044,687415,679101,692448,702996,699109,702878,704145,595556,702757,670151,661453,654130,698629,660830,688727,687870,586956,633486,662684,661781,457481,649402,690898",
                             @"openudid":@"5326e05065bd38989u9u4h48kf83ac49b30463c6368",
                             @"update_version_code":@"70614",
                             @"idfv":@"B7UDD620A-8UHJ-0987-JI90-CPID1FD7DA3F",
                             @"ac":@"WIFI",
                             @"os_version":@"12.0",
                             @"ssmix":@"a",
                             @"device_platform":@"android",
                             @"iid":@"58023232156",
                             @"ab_client":@"a1,f2,f7,e1",
                             @"device_type":@"HuaWei P20",
                             @"idfa":@"00000000-0000-0000-0000-000000000000",
                             @"article_page":@"0",
//                             @"group_id":@"6646282913023263246",
                             @"device_id":@"59003627722",
                             @"aggr_type":@"1",
//                             @"item_id":@"6646282913023263246",
//                             @"from_category":@"__all__",
                             @"mas":@"003c018d83083b2801fceb1855611c30fedd7394974cc1a5501062",
                             @"as":@"a2a5b394caa63cc4f16877",
                             @"ts":time,
 
                             };
    
    
    
    return dic;
    
    
}




@end
