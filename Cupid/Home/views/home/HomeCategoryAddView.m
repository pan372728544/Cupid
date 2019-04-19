//
//  HomeCategoryAddView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeCategoryAddView.h"
#import <Masonry/Masonry.h>


@interface HomeCategoryAddView ()
@property(nonatomic,strong) UIImageView *addImg;
@end



@implementation HomeCategoryAddView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self initSubView];
    }
    return  self;
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    
    
}
-(void)initSubView{
    
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    UIView *whiteView=[UIView new];
    whiteView.backgroundColor=[UIColor whiteColor];
    [self addSubview:whiteView];
    [whiteView addSubview:self.addImg];
    
    
    UIImageView *leftShadowView=[UIImageView new];
    leftShadowView.image=[UIImage imageNamed:@"shadow"];
    [self addSubview:leftShadowView];
    
    
    [leftShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(5, 25));
        
    }];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(@30);
    }];
    
    [self.addImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(23, 23));
        make.centerY.equalTo(whiteView);
        make.left.equalTo(whiteView).offset(0);
    }];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipAction)];
    [self addGestureRecognizer:tapGesture];
    
    
}
-(void)tipAction{
    
    if([self.delegate respondsToSelector:@selector(clickAddCategory)])
    {
        [self.delegate clickAddCategory];
    }
}

-(UIImageView *)addImg
{
    if(!_addImg){
        _addImg=[UIImageView new];
        _addImg.image=[UIImage imageNamed:@"add_channel_titlbar_thin_new_night_24x24_"];
    }
    return _addImg;
}

@end
