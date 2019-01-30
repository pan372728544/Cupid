//
//  SearchBarView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "SearchBarView.h"

@implementation SearchBarView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initMyView];
    }
    return self;
}


-(void)initMyView
{
    
    UIImage *image = [UIImage imageNamed:@"searchbox_search_press_20x28_"];
    
    // 设置端盖的值
    CGFloat top = image.size.height * 0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height * 0.5;
    CGFloat right = image.size.width * 0.5;
    
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    
    // 拉伸图片
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    
    
    // 背景图
//    self.background =newImage;
    self.backgroundColor = [UIColor whiteColor];
    
//    self.borderStyle = UITextBorderStyleBezel;
    
    self.layer.cornerRadius = 5.0;
    
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIImageView *leftView = [[UIImageView alloc]init];
    leftView.image = [UIImage imageNamed:@"detail_search_icon_16x16_"];
    leftView.width = 28;
    leftView.height = 28;
    self.leftView = leftView;
    leftView.contentMode = UIViewContentModeCenter;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.clearButtonMode = UITextFieldViewModeAlways;
    
    // 光标颜色
    self.tintColor = [UIColor brownColor];
    
    self.returnKeyType = UIReturnKeySearch;
    
   
}


@end
