//
//  LoadingDefaultView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/18.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "LoadingDefaultView.h"



@interface LoadingDefaultView()

@property(nonatomic,strong)UIImageView *viewImage;

@end

@implementation LoadingDefaultView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGBAllColor(0xF5F5F5);
        [self initImage];
    }
    
    return self;
}

-(void)initImage
{
    
    self.viewImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title_72x20_"]];
    self.viewImage.frame = CGRectMake(50, (self.height-60)/2-50, SCREEN_W-100, 60);
    
    self.viewImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.viewImage.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewImage];
    
    
    UIView *cover = [[UIView alloc]initWithFrame:CGRectMake(0, (self.height-SCREEN_W)/2, SCREEN_W, SCREEN_W)];
    cover.backgroundColor = [UIColor clearColor];
    [self addSubview:cover];
    
    
    // 添加动画
    
    // 里面的小方块
//    UIBezierPath *path1 = [UIBezierPath  bezierPathWithRect:CGRectMake(0, 0, 100, SCREEN_W)];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.borderWidth = 0.5; // 线宽
//    layer.strokeColor = RGBAllColor(0x708090).CGColor; // 线的颜色
//    layer.fillColor = RGBAAllColor(0xF5F5F5, 1).CGColor;
//    layer.strokeStart = 0;
//    layer.strokeEnd = 0;
//    layer.path = path1.CGPath;
//    [cover.layer addSublayer:layer];

    
    /* 移动 */
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//
//    // 动画选项的设定
//    animation.duration = 0.9; // 持续时间
//    animation.repeatCount = MAXFLOAT; // 重复次数
//
//    // 起始帧和终了帧的设定
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_W)]; // 起始帧
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_W-100, SCREEN_W)]; // 终了帧
//
//    // 添加动画
//    [cover.layer addAnimation:animation forKey:@"move-layer"];
    
}


@end
