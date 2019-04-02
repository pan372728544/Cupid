//
//  GMCDefaultCardView.m
//  Cupid
//
//  Created by panzhijun on 2019/4/2.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "GMCDefaultCardView.h"


@interface GMCDefaultCardView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;


@property(nonatomic,copy)NSString *contentStr;

@end

@implementation GMCDefaultCardView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self MainView];
        self.backgroundColor = [UIColor colorWithRed:(arc4random()%256/255.0) green:(arc4random()%256/255.0) blue:(arc4random()%256/255.0) alpha:1];
    }
    
    return self;
}


-(void)MainView
{

    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 100, 300-40, 500-100-20) style:UITableViewStyleGrouped];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self addSubview:self.tableView];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ddd = @"dddd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ddd];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ddd];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.contentStr;
    return cell;
}


-(void)setDisplayData:(id)data
{
    NSString *aa = (NSString *)data;
    self.contentStr= aa;
    [self.tableView reloadData];
    //这里写设置的代码
    
}

@end
