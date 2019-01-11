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

@end
