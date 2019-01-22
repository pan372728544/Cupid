//
//  ResultTopView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/16.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ResultTopView.h"
#import "SearchBarView.h"


@interface ResultTopView()

@property(nonatomic,strong) SearchBarView *searchBarView;

@end


@implementation ResultTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        [self setupSubviews];
    }
    return self;
}


-(void)setupSubviews
{
    self.frame=CGRectMake(50, STATUSBAR_H, SCREEN_W-100, NAVBAR_H);
    self.searchBarView = [[SearchBarView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W-100, SearchBar_H)];
    [self addSubview:self.searchBarView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.searchBarView addGestureRecognizer:tap];
    
}

@end
