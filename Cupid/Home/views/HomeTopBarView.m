//
//  HomeTopBarView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeTopBarView.h"
#import "ZJCommonMacro.h"
#import <Masonry.h>


@interface HomeTopBarView()

@property(nonatomic,strong) UIImageView *leftIconBtn;
@property(nonatomic,strong) UIView *centerView;
@property(nonatomic,strong) UIImageView *serachImg;
@property(nonatomic,strong) UILabel *searchTipLable;


@property(nonatomic,strong)UISearchBar *searchBar;

@end

@implementation HomeTopBarView

-(instancetype)init
{
    if(self=[super init])
    {
        [self setupSubviews];
    }
    return self;
}


-(void)setupSubviews
{
    self.frame=CGRectMake(0, 0, SCREEN_W, NAVBAR_H);
    
    self.backgroundColor = [UIColor clearColor];
//    self.backgroundColor= [UIColor colorWithRed:0.84 green:0.23 blue:0.22 alpha:1];
    
    
    [self addSubview:self.searchBar];
    
    
 
//    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(20);
//        make.right.equalTo(self).offset(-20);
//        make.top.equalTo(self).offset(5);
//        make.bottom.equalTo(self).offset(-5);
//    }];
    
//    [self addSubview: self.leftIconBtn];
//    [self addSubview: self.centerView];
//    [self.centerView addSubview: self.serachImg];
//    [self.centerView addSubview: self.searchTipLable];
//
//    [self.leftIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(12);
//        make.size.mas_equalTo(CGSizeMake(32, 32));
//        make.bottom.equalTo(self).offset(-8);
//
//    }];
//    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftIconBtn.mas_right).offset(15);
//        make.right.equalTo(self).offset(-15);
//        make.bottom.equalTo(self).offset(-8);
//        make.height.mas_equalTo(30);
//    }];
//    [self.serachImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.centerView).offset(15);
//        make.size.mas_equalTo(CGSizeMake(15, 15));
//        make.centerY.equalTo(self.centerView);
//    }];
//
//    [self.searchTipLable  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.centerView);
//        make.left.equalTo(self.serachImg.mas_right).offset(10);
//    }];
}

/** 取消searchBar背景色 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        
    }
    return  self;
}


-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 0, SCREEN_W-40, 44)];
        _searchBar.placeholder = @"搜索关键字：ABC";
         _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
    }
    return _searchBar;
}


-(UIImageView *)leftIconBtn{
    if(!_leftIconBtn){
        _leftIconBtn=[UIImageView new];
        _leftIconBtn.image=[UIImage imageNamed:@"head-1"];
        _leftIconBtn.layer.cornerRadius=16;
        _leftIconBtn.layer.masksToBounds=YES;
    }
    return _leftIconBtn;
}

-(UIView*)centerView{
    if(!_centerView){
        _centerView=[UIView new];
        _centerView.layer.cornerRadius=4;
        _centerView.backgroundColor=[UIColor whiteColor];
    }
    return _centerView;
}

-(UIImageView*)serachImg{
    if(!_serachImg){
        _serachImg=[UIImageView new];
        _serachImg.image=[UIImage imageNamed:@"search_small"];
        
    }
    return _serachImg;
}

-(UILabel *)searchTipLable{
    if(!_searchTipLable){
        _searchTipLable=[UILabel new];
        _searchTipLable.font=[UIFont systemFontOfSize:13];
        _searchTipLable.text=@"搜索推荐|战狼2|美国";
        _searchTipLable.textColor=[UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1];
    }
    return _searchTipLable;
}

@end
