//
//  ZJNavgationBarView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJNavgationBarView.h"



@implementation ZJNavgationBarView

- (id)initWithTitle:(NSString *)strTitle
{
    
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREEN_W,NAVBAR_IPHONEX_H);
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        /// 标题
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.frame = CGRectMake(80, STATUSBAR_H, SCREEN_W-80*2, NAVBAR_H);
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.text = strTitle;
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelTitle];
        
        
        // 分割线
        
        UIView *viewLine = [[UIView alloc]init];
        
        /// 获取屏幕的像素密度，如iPhone6Plus，一个点上有3个像素，该值为3
        CGFloat fltScale = [UIScreen mainScreen].scale;
        
        
        CGFloat lineH = 1/fltScale;
        
        viewLine.frame = CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, lineH);
        
        viewLine.backgroundColor =  RGBAllColor(0xE4E4E4);
        
        
        [self addSubview:viewLine];
        
  
        
    }
    return self;
}


/// 设置中间标题
- (void)setIdNavTitle:(id)idNavTitle
{
    /// 判断idNavTitle的类型，目前支持String、View
    
    if ([idNavTitle isKindOfClass:[NSString class]]) /// String类型
    {
        _labelTitle.text = idNavTitle;
    }
    else if ([idNavTitle isKindOfClass:[UIView class]]) /// View类型
    {
        /// 删除原来的View
        UIView *viewOldNavTitle = [self viewWithTag:NavBar_ViewTitle_Tag];
        [viewOldNavTitle removeFromSuperview];
        viewOldNavTitle = nil;
        
        /// 添加新的View
        UIView *viewNewNavTitle = idNavTitle;
        viewNewNavTitle.tag = NavBar_ViewTitle_Tag;
        
        /// 视图居中
        viewNewNavTitle.center = CGPointMake(SCREEN_W/2, NAVBAR_H/2+STATUSBAR_H);
    
        [self addSubview:viewNewNavTitle];
    }
}


- (void)createNavLeftBtnWithItem:(id)idItem
{
    
    if (!_btnLeft)
    {
        UIButton *btnLeft = [[UIButton alloc]initWithFrame:CGRectMake(10, STATUSBAR_H, NavBar_Btn_W, NAVBAR_H)];
        _btnLeft = btnLeft;
        _btnLeft.tag = 100;
        _btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btnLeft.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
        _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        _btnLeft.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        /// 高亮时的文字颜色
        [_btnLeft setTitleColor:NavBar_BtnTitle_Color forState:UIControlStateHighlighted];
        /// 不可点击时的文字颜色
        [_btnLeft setTitleColor:NavBar_BtnTitle_Color forState:UIControlStateDisabled];
        
        [self addSubview:_btnLeft];
        
    }
    
    if ([idItem isKindOfClass:[NSString class]]) /// NSString
    {
        if (![idItem isEqualToString:@""]) /// 有标题
        {

            
            [_btnLeft setTitle:idItem forState:UIControlStateNormal];
        }
        else /// 没有标题，直接设置返回按钮图片
        {
            [_btnLeft setImage:[UIImage imageNamed:@"back_24x24_"] forState:UIControlStateNormal];
        }
    }
    else if ([idItem isKindOfClass:[UIImage class]]) /// UIImage类型
    {
        [_btnLeft setImage:idItem forState:UIControlStateNormal];
    }
    
    
}


/// 创建右侧按钮
- (void)createNavRightBtnWithItem:(id)idItem
{
    if (!_btnRight)
    {
        
        UIButton *btnRight = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - GMK_NavBar_Btn_W-5, STATUSBAR_H, NavBar_Btn_W, NAVBAR_H)];
        
        _btnRight = btnRight;
        _btnRight.tag = 200;
        _btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        _btnRight.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        /// 普通状态时的文字颜色
        [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        /// 高亮时的文字颜色
        [_btnRight setTitleColor:NavBar_BtnTitle_Color forState:UIControlStateHighlighted];
        /// 不可点击时的文字颜色
        [_btnRight setTitleColor:NavBar_BtnTitle_Color forState:UIControlStateDisabled];
        
        _btnRight.titleLabel.font = NAV_Btn_Font;
        [self addSubview:_btnRight];
        
    }
    
    if ([idItem isKindOfClass:[NSString class]]) /// String类型
    {
        /// 设置title
        [_btnRight setTitle:idItem forState:UIControlStateNormal];
    }
    else if ([idItem isKindOfClass:[UIImage class]]) /// UIImage类型
    {
        /// 设置image
        [_btnRight setImage:idItem forState:UIControlStateNormal];
    }
}


@end
