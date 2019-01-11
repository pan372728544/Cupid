//
//  FeedNewContentModel.m
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "FeedNewContentModel.h"
#import <MJExtension/MJExtension.h>

@implementation FeedNewContentModel


+(NSDictionary *)mj_objectClassInArray
{
    
    return @{@"filter_words" : @"Filter_Words",
             @"thumb_image_list" : @"Thumb_Image_List",
             @"large_image_list" : @"Large_Image_List",
             @"image_list" : @"Large_Image_List"
             
             };
}

@end

@implementation WbUser

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    
    return @{@"desc":@"description"};
}

@end


@implementation Forward_Info

@end


@implementation Filter_Words

@end


@implementation Thumb_Image_List

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"url_list" : @"Url_List"};
}

@end


@implementation Url_List

@end


@implementation Large_Image_List

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"url_list" : @"Url_List class"};
}


@end
