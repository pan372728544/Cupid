//
//  FeedNormalTableViewCell.m
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "FeedNormalTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>
#import "ZJCommonMacro.h"

@interface FeedNormalTableViewCell()

@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *styleLable;
@property(nonatomic,strong)UILabel *bottomLable;
@property(nonatomic,strong)UIButton *delBtn;
@property(nonatomic,strong) UIView  *imgView;
@property(nonatomic,strong) UIView  *fengView;


@property(nonatomic,strong) FeedNewContentModel *model;
@end

@implementation FeedNormalTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self initSubView];
    }
    return self;
}


// 设置数据
-(void)setModelDataWith:(FeedNewContentModel*)model{
    
    _model = model;
    
    // 发布时间
    long long time=[model.publish_time longLongValue];
    NSDate *timedate=[NSDate dateWithTimeIntervalSince1970:time];
    
    
    NSString *timeStr=[self detailTimeAgoString:timedate];
    // 标题
    self.titleLable.text=model.title;
    // 来源
    self.bottomLable.text=[NSString stringWithFormat:@"%@  %@评论  %@",model.source,model.comment_count,timeStr];
    
    // 设置图片数据
    [self createImgCell:model.image_list];
    
}

-(void)removeOldView{
    for (UIView *view in [self.imgView subviews]) {
        if([view isKindOfClass:[UIImageView class]])
        {
            [ view removeFromSuperview];
            
        }
    }
}


-(NSString*)urldelwebpStr:(NSString*)str
{
    NSRange findRange = [str rangeOfString:@".webp"];
    NSString *newStr=str;
    if(findRange.location!=NSNotFound)
        newStr=[str substringWithRange:NSMakeRange(0, str.length-5)];
    
    return newStr;
}


-(void)createImgCell:(NSArray*)imgArrs
{
    
    [self removeOldView];
    UIImageView *firstCell=nil;
    NSInteger space = 5;//间距
    NSInteger maxCount=imgArrs.count>3 ? 3:imgArrs.count;
    
    for (int i=0;i<maxCount; i++)
    {
        // 图片数组模拟性
        Large_Image_List *model = imgArrs[i];
        UIImageView *imgcell=[UIImageView new];
        imgcell.tag= 1000+i;
        imgcell.userInteractionEnabled=NO;
        
        NSString *newStr = [self urldelwebpStr:model.url];
        
        // 下载图片
        [imgcell sd_setImageWithURL:[NSURL URLWithString:newStr] placeholderImage:[UIImage imageNamed:@"details_slogan01"]];
        
        [self.imgView addSubview:imgcell];
        
        if(i==0)
        {
            firstCell=imgcell;
        }
        
        // 存在一张或者两张照片
        if(imgArrs.count==1||imgArrs.count==2)
        {
            [imgcell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((-35)/2);
                make.height.mas_equalTo(imgcell.mas_width).multipliedBy(0.65);
                NSInteger width= i==1? (SCREEN_W-35)/2+space:0;
                make.left.equalTo(self.contentView).offset(15+width);
                make.top.equalTo(self.titleLable.mas_bottom).offset(8);
            }];
        }
        else
        {
            [imgcell mas_makeConstraints:^(MASConstraintMaker *make) {
                
                // 计算每个cell的上 左间距
                NSInteger imgWidth = (SCREEN_W-35)/3;
                NSInteger xLeft = i;
                NSInteger line = 0;
                make.width.mas_equalTo((SCREEN_W-35)/3);
                make.height.mas_equalTo(imgcell.mas_width).multipliedBy(0.65);
                make.left.equalTo(self.contentView).offset(15+(xLeft*(imgWidth + space)));
                make.top.equalTo(self.titleLable.mas_bottom).offset(8+(line*(imgWidth+space)));
            }];
        }
        
    }
    if(firstCell)
    {
        [self.bottomLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLable);
            make.top.equalTo(firstCell.mas_bottom).offset(10);
            
        }];
        
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(firstCell.mas_bottom);
        }];
        
    }
    else
    {
        [self.bottomLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLable);
            make.top.equalTo(self.titleLable.mas_bottom).offset(10);
            
        }];
        
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@1);
            
        }];
    }
    
}





-(void)initSubView
{
    // 标题
    [self.contentView addSubview:self.titleLable];
    
    // 删除按钮
    [self.contentView addSubview:self.delBtn];
    
    // 置顶
    [self.contentView addSubview:self.styleLable];
    
    // 来源 评论 时间
    [self.contentView addSubview:self.bottomLable];
    
    // 图片列表
    [self.contentView addSubview:self.imgView];
    
    // 分割线
    [self.contentView addSubview:self.fengView];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(15);
    }];

    [self.bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.titleLable.mas_bottom).offset(10);
    }];
    
    [self.fengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLable.mas_bottom).offset(10);
        make.left.equalTo(self.titleLable);
        make.bottom.equalTo(self.contentView).offset(-2).priorityHigh();
        make.right.equalTo(self.contentView);
        make.height.equalTo(@1);
        
    }];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 35));
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@1);
        
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(UIButton *)delBtn
{
    if(!_delBtn){
        _delBtn=[UIButton new];
        [_delBtn setImage:[UIImage imageNamed:@"add_textpage"] forState:UIControlStateNormal];
        
    }
    return _delBtn;
}

-(UILabel*)bottomLable
{
    if(!_bottomLable){
        _bottomLable=[UILabel new];
        _bottomLable.textColor=[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1];
        _bottomLable.font=[UIFont systemFontOfSize:12];
        _bottomLable.text=@"中国网 100评论 一分钟前";
    }
    return _bottomLable;
}

-(UILabel *)titleLable
{
    if(!_titleLable){
        _titleLable=[UILabel new];
        _titleLable.font=[UIFont systemFontOfSize:18];
        _titleLable.textColor=[UIColor blackColor];
        _titleLable.numberOfLines = 2;
        _titleLable.textAlignment=NSTextAlignmentLeft;
        _titleLable.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLable.preferredMaxLayoutWidth = SCREEN_W - 30;
        
        _titleLable.text = @"标题";
    }
    return _titleLable;
}

-(UILabel *)styleLable
{
    if(!_styleLable){
        UIColor *color=[UIColor colorWithRed:0.84 green:0.23 blue:0.22 alpha:1];;
        _styleLable=[UILabel new];
        _styleLable.layer.cornerRadius=3;
        _styleLable.layer.masksToBounds=YES;
        _styleLable.text=@"置顶";
        _styleLable.layer.borderColor=color.CGColor;
        _styleLable.layer.borderWidth=0.5;
        _styleLable.textColor=color;
        _styleLable.font=[UIFont systemFontOfSize:11];
    }
    return _styleLable;
}

-(UIView  *)imgView
{
    if(!_imgView){
        _imgView=[UIView new];
        _imgView.backgroundColor=[UIColor clearColor];
        _imgView.userInteractionEnabled=NO;
    }
    return _imgView;
}

-(UIView *)fengView{
    if(!_fengView){
        _fengView=[UIView new];
        _fengView.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    }
    return _fengView;
}


- (NSString *)detailTimeAgoString:(NSDate *)date
{
    
    long long timeNow = [date timeIntervalSince1970];
    NSCalendar * calendar=[self sharedCalendar];
    NSInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSInteger year=[component year];
    NSInteger month=[component month];
    NSInteger day=[component day];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    NSInteger t_year=[component year];
    
    NSString*string=nil;
    
    long long now = [today timeIntervalSince1970];
    
    long long  distance= now - timeNow;
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%lld分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%lld小时前",distance/60/60];
    else if(distance<60*60*24*7)
        string=[NSString stringWithFormat:@"%lld天前",distance/60/60/24];
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
    else
        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    
    return string;
}


- (NSCalendar *)sharedCalendar
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    [currentCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    [currentCalendar setFirstWeekday:2];
    return currentCalendar;
}

@end
