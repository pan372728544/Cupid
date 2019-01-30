//
//  ArtileInfomationModel.h
//  Cupid
//
//  Created by panzhijun on 2019/1/18.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtileInfomationModel : NSObject

@property(nonatomic,copy)NSString  *source; // 来源

@property(nonatomic,copy)NSString  *url; // 地址


@end



@interface ArtileInfomationCommentListModel : NSObject

//@property(nonatomic,copy)NSString  *id;//":1623189803956398,
@property(nonatomic,copy)NSString  *text;//":"现在才明白特朗普为什么要把美国政府搞的停摆？真是费尽心思啊，如果政府不停摆，孟晚舟事件他不知道如何下台，引渡不行，不引渡面子上下不去，所以借着“修墙”之名来掩盖啊！这样到了最后引渡期限，也有一个好的说辞：政府停摆！",
//@property(nonatomic,copy)NSString  *content_rich_span;//":"{"links":[]}",
//@property(nonatomic,copy)NSString  *reply_count;//":137,
//
//@property(nonatomic,copy)NSString  *digg_count;//":1161,
//@property(nonatomic,copy)NSString  *bury_count;//":0,
//@property(nonatomic,copy)NSString  *forward_count;//":8,
//@property(nonatomic,copy)NSString  *create_time;//":1547994426,
//@property(nonatomic,copy)NSString  *score;//":0.92825190235562,
//@property(nonatomic,copy)NSString  *user_id;//":7495422986,
@property(nonatomic,copy)NSString  *user_name;//":"Jason0912",
//@property(nonatomic,copy)NSString  *remark_name;//":"",
@property(nonatomic,copy)NSString  *user_profile_image_url;//":"http://p1.pstatp.com/thumb/150e0006da00f37062a6",
//@property(nonatomic,copy)NSString  *user_verified;//":false,
//@property(nonatomic,copy)NSString  *interact_style;//":0,
//@property(nonatomic,copy)NSString  *is_following;//":0,
//@property(nonatomic,copy)NSString  *is_followed;//":0,
//@property(nonatomic,copy)NSString  *is_blocking;//":0,
//@property(nonatomic,copy)NSString  *is_blocked;//":0,
//@property(nonatomic,copy)NSString  *is_pgc_author;//":0,
//@property(nonatomic,copy)NSString  *author_badge;//":[





@end

@interface ArtileInfomationCommentModel : NSObject


@property(nonatomic,strong)ArtileInfomationCommentListModel  *comment; // 来源
@property(nonatomic,copy)NSString  *ad;//:null,
@property(nonatomic,copy)NSString  *embedded_data;//:null,
//@property(nonatomic,copy)NSString  *id;//:1623189803956398,
@property(nonatomic,copy)NSString  *cell_type;//:1


@end



@interface ArtileInfomationCommentDataModel : NSObject


@property(nonatomic,strong)NSArray  *data;//:null,
@property(nonatomic,strong)NSNumber  *total_number;//:null,
//@property(nonatomic,copy)NSString  *id;//:1623189803956398,
@property(nonatomic,assign)BOOL  has_more;//:1


@end


@class ArtileInfomationHtmlH5ExtraModel;
@class ArtileInfomationHtmlTitleImageModel;
@interface ArtileInfomationHtmlModel : NSObject


@property(nonatomic,copy)NSString  *content;//:null,

@property(nonatomic,strong)NSArray  *image_detail;//:null,

//
@property(nonatomic,strong)ArtileInfomationHtmlH5ExtraModel  *h5_extra;


@property(nonatomic,strong)ArtileInfomationHtmlTitleImageModel  *title_image;

@end

@interface ArtileInfomationHtmlImglistModel : NSObject


@property(nonatomic,copy)NSString  *url;


@end

@class ArtileInfomationHtmlH5ExtraMediaModel;
@interface ArtileInfomationHtmlH5ExtraModel : NSObject


// s发布时间
@property(nonatomic,copy)NSString  *publish_time;
@property(nonatomic,strong)ArtileInfomationHtmlH5ExtraMediaModel  *media;

@end


@interface ArtileInfomationHtmlH5ExtraMediaModel : NSObject


/// 名字
@property(nonatomic,copy)NSString  *name;
// 头像
@property(nonatomic,copy)NSString  *avatar_url;
// 信息
@property(nonatomic,copy)NSString  *auth_info;

@end



@interface ArtileInfomationHtmlTitleImageModel : NSObject


/// 标题图片
@property(nonatomic,copy)NSString  *title_image_url;


@end
NS_ASSUME_NONNULL_END
