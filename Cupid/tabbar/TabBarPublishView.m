//
//  TabBarPublishView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "TabBarPublishView.h"
#import "ZJCommonMacro.h"
#import "UIView+Frame.h"

@interface TabBarPublishView()

@property(nonatomic,strong)CAGradientLayer *gradientLayer;
@end

@implementation TabBarPublishView


-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor clearColor];
        [self initMainView];
        
    }
    
    return self;
}

-(void)initMainView
{
    
    //为透明度设置渐变效果
    UIColor *colorOne = [UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:0.1];
    UIColor *colorTwo = [UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:1.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, SCREEN_W , self.height-TABBAR_IPHONEX_H);
    [self.layer insertSublayer:gradient atIndex:0];

    
    
    UIView *viewCorver = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-TABBAR_IPHONEX_H, SCREEN_W, TABBAR_IPHONEX_H)];
    viewCorver.backgroundColor = [UIColor whiteColor];

    [self addSubview:viewCorver];

    
    UIView *viewContent = [[UIView alloc]initWithFrame:CGRectMake(20, 30, SCREEN_W-40, 80)];
    viewContent.layer.cornerRadius = 25;

    viewContent.backgroundColor = [UIColor whiteColor];
    
    [self addShadowToView:viewContent withColor:[UIColor blackColor]];
    
    [self addSubview:viewContent];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_W-56)*0.5,CGRectGetMaxY(viewContent.frame), 56, 56)];
    
    [btn setImage:[UIImage imageNamed:@"tabbar_closebtn_56x56_"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
    
    
    for(int i = 0;i<4;i++)
    {
        CGFloat w = (SCREEN_W-40)/4;
        CGFloat y = 20;
        CGFloat h = 40;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*w,y,w,h)];
        [btn addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [viewContent addSubview:btn];
        
        switch (i) {
            case 0:
                [btn setImage:[UIImage imageNamed:@"tabbar_publish_article_34x34_"] forState:UIControlStateNormal];
                break;
            case 1:
                [btn setImage:[UIImage imageNamed:@"tabbar_publish_shortvideo_34x34_"] forState:UIControlStateNormal];
                break;
            case 2:
                [btn setImage:[UIImage imageNamed:@"tabbar_publish_uploadvideo_34x34_"] forState:UIControlStateNormal];
                break;
            case 3:
                [btn setImage:[UIImage imageNamed:@"tabbar_publish_question_34x34_"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
 
        
 
        
    }
}

-(void)clickImage:(id)sender
{
    UIButton *btn = sender;
    if (_pubBlock) {
        _pubBlock(btn.tag);
    }
}

- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,5);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 10;
}

-(void)closeView
{
 
    if (_myBlock) {
        _myBlock();
    }
}

@end
