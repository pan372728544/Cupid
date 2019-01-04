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
        UILabel *labelTitle = [[UILabel alloc] init];
        labelTitle.frame = CGRectMake(80, STATUSBAR_H, SCREEN_W-80*2, NAVBAR_H);
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.text = strTitle;
        labelTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelTitle];
        
        
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
