//
//  HomeCommentTableViewCell.m
//  Cupid
//
//  Created by panzhijun on 2019/1/18.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeCommentTableViewCell.h"
#import "ArtileInfomationModel.h"

@interface HomeCommentTableViewCell()


@property(nonatomic,strong)UIImageView *imagView;

@property(nonatomic,strong)UILabel *nickNameLable;

@property(nonatomic,strong)UILabel *contentLablel;


@property(nonatomic,strong)UILabel *labTime;

@property(nonatomic,strong)UIImageView *imagLike;

@property(nonatomic,strong)UILabel *labCount;

@end


@implementation HomeCommentTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self initMainView];
    }
    
    return self;
}

-(void)initMainView
{
    
    self.imagView = [[UIImageView alloc]init];
    self.imagView.layer.cornerRadius = 15;
    self.imagView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imagView];
    
    self.nickNameLable = [[UILabel alloc]init];

    self.nickNameLable.textColor =RGBAllColor(0x5CACEE);
    self.nickNameLable.numberOfLines = 1;
    self.nickNameLable.font= [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.nickNameLable];
    
    
    self.contentLablel = [[UILabel alloc]init];
    self.contentLablel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLablel];
    
    
    
    self.labTime = [[UILabel alloc]init];
    self.labTime.font= [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.labTime];
    
    
    self.imagLike = [[UIImageView alloc]init];

    [self.contentView addSubview:self.imagLike];
    
    self.labCount = [[UILabel alloc]init];
    self.labCount.textColor = [UIColor lightGrayColor];
    self.labCount.font= [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.labCount];
    
    
    
    
    [self.imagView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        
    }];
    
    [self.nickNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.imagView.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    
    [self.labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.imagLike mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(self.labCount.mas_left).offset(-3);
        
    }];
    
    [self.contentLablel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imagView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.imagView.mas_right).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLablel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.imagView.mas_right).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
}


-(void)setModel:(ArtileInfomationCommentListModel *)model
{
    _model= model;
    

    [self.imagView sd_setImageWithURL:[NSURL URLWithString:model.user_profile_image_url]];
    
    self.nickNameLable.text = model.user_name;
    
    self.contentLablel.text = model.text;
    
    
    NSString *timeStampString  = model.create_time;
    NSTimeInterval interval    =[timeStampString doubleValue] ;
    NSDate *date    = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    self.labTime.text = [NSString stringWithFormat:@"%@·回复",dateString];
    
    
    self.labCount.text = [model.digg_count isEqualToString:@"0"]?@"赞":model.digg_count;
    self.imagLike.image = [UIImage imageNamed:@"c_comment_like_icon_18x18_"];
    
}

@end

