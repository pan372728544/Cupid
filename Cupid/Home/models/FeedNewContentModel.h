//
//  FeedNewContentModel.h
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FocusonMainModel;
@class WbUser;
@class Forward_Info;
@class Filter_Words;
@class Thumb_Image_List,Url_List;
@class Large_Image_List;


@interface FeedNewContentModel : NSObject


@property(nonatomic,copy)NSString  *abstract;

@property(nonatomic,strong)NSNumber  *aggr_type;
@property(nonatomic,assign)BOOL  allow_download;
@property(nonatomic,strong)NSNumber  *article_type;
@property(nonatomic,strong)NSNumber  *article_version;
@property(nonatomic,strong)NSNumber  *ban_comment;
@property(nonatomic,strong)NSNumber  *behot_time;
@property(nonatomic,strong)NSNumber  *bury_count;
@property(nonatomic,strong)NSNumber  *cell_flag;
@property(nonatomic,strong)NSNumber  *cell_layout_style;

@property(nonatomic,strong)NSNumber  *cursor;

@property(nonatomic,strong)NSNumber  *gallary_image_count;
@property(nonatomic,strong)NSNumber  *group_flags;
@property(nonatomic,strong)NSNumber  *group_id;
@property(nonatomic,strong)NSNumber  *has_mp4_video;
@property(nonatomic,strong)NSNumber  *ignore_web_transform;
@property(nonatomic,strong)NSNumber  *hot;
@property(nonatomic,strong)NSNumber  *item_id;
@property(nonatomic,strong)NSNumber  *item_version;
@property(nonatomic,strong)NSNumber  *level;



@property(nonatomic,copy)NSString  *article_url;
@property(nonatomic,copy)NSString  *content_decoration;
@property(nonatomic,copy)NSString  *display_url;
@property(nonatomic,copy)NSString  *info_desc;
@property(nonatomic,copy)NSString  *interaction_data;
@property(nonatomic,copy)NSString  *keywords;




@property(nonatomic,assign)BOOL  has_image;
@property(nonatomic,assign)BOOL  has_m3u8_video;
@property(nonatomic,assign)BOOL  is_subject;

/**
 *  不看的理由
 */
@property (nonatomic, strong) NSArray<Filter_Words *> *filter_words;

/**
 *  评论次数
 */
@property(nonatomic,strong) NSNumber *comment_count;









@property (nonatomic, assign) NSInteger cell_type;

@property(nonatomic,strong) FocusonMainModel *raw_data;  // 推荐关注的人数据


// weibo cell
/**
 *  正文内容
 */
@property(nonatomic,strong)NSString  *content;

/**
 *  创建时间
 */
@property(nonatomic,strong)NSNumber  *create_time;

/**
 *  推送时间
 */
@property(nonatomic,strong)NSNumber  *publish_time;


/**
 *  阅读量
 */
@property(nonatomic,strong) NSNumber *read_count;

/**
 *  赞次数
 */
@property(nonatomic,strong) NSNumber *digg_count;




/**
 *  用户信息
 */
@property (nonatomic, strong) WbUser *user_info;


/**
 *  转发次数
 */
@property (nonatomic, strong) Forward_Info *forward_info;





/**
 *  小图片列表
 */
@property (nonatomic, strong) NSArray<Thumb_Image_List *> *thumb_image_list;


/**
 *  图片列表
 */
@property (nonatomic, strong) NSArray<Large_Image_List *> *image_list;

@property (nonatomic, strong) NSArray<Large_Image_List *> *middle_image;

/**
 *  高清图列表
 */
@property (nonatomic, strong) NSArray<Large_Image_List *> *large_image_list;


/**
 *  标题
 */
@property(nonatomic,strong) NSString *title;

/**
 *  来源
 */
@property(nonatomic,strong) NSString *source;

/**
 *  置顶类型
 */
@property(nonatomic,strong) NSNumber *label_style;

/**
 *  显示
 */
@property(nonatomic,strong) NSString *label;

/**
 *  用户是否点赞
 */
@property(nonatomic,strong) NSNumber *user_digg;

/**
 *
 cell。id 标示
 */

@property(nonatomic,strong) NSNumber *thread_id;


/**
 *  跳转要取点参数
 */

@property(nonatomic,strong) NSString *schema;

@end



@interface WbUser : NSObject

@property (nonatomic, copy) NSString *avatar_url;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger follower_count;

@property (nonatomic, assign) NSInteger live_info_type;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *schema;
@property (nonatomic, copy) NSString *verified_content;


@end

@interface Forward_Info : NSObject

@property (nonatomic, strong) NSNumber *forward_count;

@end

@interface Filter_Words : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) BOOL is_selected;

@property (nonatomic, copy) NSString *name;

@end

@interface Thumb_Image_List : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, strong) NSArray<Url_List *> *url_list;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *uri;

@end

@interface Url_List : NSObject

@property (nonatomic, copy) NSString *url;

@end

@interface Large_Image_List : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, strong) NSArray<Url_List *> *url_list;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *uri;

@end


NS_ASSUME_NONNULL_END
