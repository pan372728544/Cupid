//
//  TabBarPublishView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "TabBarPublishView.h"
#import "ZJCommonMacro.h"

@implementation TabBarPublishView


-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor lightGrayColor];
        [self initMainView];
    }
    
    return self;
}

-(void)initMainView
{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_W-40)*0.5,30, 40, 40)];
    
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    
    [btn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    
}

-(void)closeView
{
    [self removeFromSuperview];
    
}

@end
