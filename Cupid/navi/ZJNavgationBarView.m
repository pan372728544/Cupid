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
//        self.backgroundColor = [UIColor blackColor];
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
        
//        if (viewNewNavTitle.frame.size.width > (SCREEN_W - GMK_NavBar_Btn_W*2)) /// 如果中间视图超出最大宽度，重新设定
//        {
//            viewNewNavTitle.frame = CGRectMake(viewNewNavTitle.frame.origin.x,
//                                               viewNewNavTitle.frame.origin.y,
//                                               SCREEN_W - GMK_NavBar_Btn_W*2,
//                                               viewNewNavTitle.frame.size.height);
//        }

        /// 视图居中
        viewNewNavTitle.center = CGPointMake(SCREEN_W/2, (NAVBAR_IPHONEX_H-STATUSBAR_H)/2+STATUSBAR_H);
        [self addSubview:viewNewNavTitle];
    }
}


- (void)createNavLeftBtnWithItem:(id)idItem
{
    
    UIButton *btnLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, STATUSBAR_H, 80, NAVBAR_H)];
    btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnLeft.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnLeft.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [btnLeft setTitle:idItem forState:UIControlStateNormal];
    self.btnLeft = btnLeft;
    [self addSubview:btnLeft];
}

@end
