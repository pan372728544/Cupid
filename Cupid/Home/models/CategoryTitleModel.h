//
//  CategoryTitleModel.h
//  Cupid
//
//  Created by panzhijun on 2019/1/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// 标题model
@interface CategoryTitleModel : NSObject

@property (nonatomic, assign) NSInteger default_add;
@property (nonatomic, copy) NSString *web_url;

@property (nonatomic, assign) NSInteger stick;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon_url;

@property (nonatomic, copy) NSString *concern_id;

@property (nonatomic, copy) NSString *image_url;

@property (nonatomic, assign) NSInteger tip_new;

@property (nonatomic, assign) NSInteger flags;

@property (nonatomic, assign) NSInteger type;



@end

NS_ASSUME_NONNULL_END
