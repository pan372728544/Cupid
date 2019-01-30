//
//  ChannelTopView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ChannelTopView.h"




@implementation ChannelTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initMainView];
    }
    
    return self;
}


-(void)initMainView
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, (self.height-24)/2, 24, 24)];
    
    
    [btn setBackgroundImage:[UIImage imageNamed:@"close_channel_24x24_@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClose:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    
    UIView *viewLine = [[UIView alloc]init];
    
    /// 获取屏幕的像素密度，如iPhone6Plus，一个点上有3个像素，该值为3
    CGFloat fltScale = [UIScreen mainScreen].scale;
    
    CGFloat lineH = 1/fltScale;
    viewLine.frame = CGRectMake(0, self.height-lineH, SCREEN_W, lineH);
    
    viewLine.backgroundColor =  RGBAllColor(0xE4E4E4);

    [self addSubview:viewLine];
    
    
    
}


-(void)btnClose:(id)sender
{
    
    if (_blockClickClose) {
        _blockClickClose();
    }
}
@end
