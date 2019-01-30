//
//  FeedFocusonTableViewCell.m
//  Cupid
//
//  Created by panzhijun on 2019/1/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "FeedFocusonTableViewCell.h"
#import "FeedNewContentModel.h"
#import "ZJCommonMacro.h"

@interface FeedFocusonTableViewCell()

@property(nonatomic,strong)UILabel *labTitle;

@property(nonatomic,strong)UIView *viewsImags;

@end

@implementation FeedFocusonTableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        [self initMainView];
    }
    
    return self;
}

-(void)initMainView
{
    _labTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    
    [self.contentView addSubview:_labTitle];
    
    
    
    _viewsImags = [[UIView alloc]init];
    
    [self.contentView addSubview:_viewsImags];
    
    
}

-(void)setModel:(FeedNewContentModel *)model
{
    _model = model;
    

    

    // 来源
    self.labTitle.text= model.title;
    
    self.labTitle.frame = CGRectMake(15,15,SCREEN_W,100);
    

    self.viewsImags.frame = CGRectMake(15, 115, SCREEN_W, 100);
    self.viewsImags.backgroundColor = [UIColor redColor];
    
    
    
}
@end
