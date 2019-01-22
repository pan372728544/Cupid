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

@end


@implementation HomeCommentTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.backgroundColor = [UIColor lightGrayColor];
        
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
    //    self.nickNameLable.backgroundColor = [UIColor orangeColor];
    self.nickNameLable.numberOfLines = 1;
    self.nickNameLable.font= [UIFont systemFontOfSize:12];
    
    
    [self.contentView addSubview:self.nickNameLable];
    self.contentLablel = [[UILabel alloc]init];
    self.contentLablel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLablel];
    
}

-(void)layoutSubviews
{
    
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
    
    [self.contentLablel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imagView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.imagView.mas_right).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    
}

-(void)setModel:(ArtileInfomationCommentListModel *)model
{
    _model= model;
    

    [self.imagView sd_setImageWithURL:[NSURL URLWithString:model.user_profile_image_url]];
    
    self.nickNameLable.text = model.user_name;
    
    self.contentLablel.text = model.text;
}

@end

