//
//  HomeContentViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeContentViewController.h"
#import "ZJCommonMacro.h"
#import "SecondViewController.h"
#import "YQNetworking.h"
#import "UIImageView+WebCache.h"
#import "HomeRequest.h"
#import "FeedNewContentModel.h"
#import "FeedNewsModel.h"
#import "FeedFocusonTableViewCell.h"
#import <MJExtension/MJExtension.h>
#import "FeedNormalTableViewCell.h"


static NSString *const cellfocuson=@"cellfocuson";
static NSString *const cellIdentf=@"showCellTop";
static NSString *const headeridentify=@"headeridentify";
static NSString *const defaultcell=@"defaultcell";
static NSString *const cellweiboidentify=@"TTWeiboTableViewCell";
static NSString *const layoutgrouppiccell=@"TTLayOutGroupPicCell";

@interface HomeContentViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) NSMutableArray *mainDaraArrs;
@end

@implementation HomeContentViewController

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainDaraArrs=[NSMutableArray array];
   
    [self.view addSubview:self.mainTableView];
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
     [self loadMainRequest];
}



-(void)loadMainRequest
{
    NSString *category = self.category;
    NSDictionary *dirParams = @{@"category":category};
    [YQNetworking getWithUrl:[HomeRequest getHomeFeedNewsUrl] refreshRequest:NO cache:NO params:dirParams progressBlock:nil successBlock:^(id response) {
        [self requestSuccess:response];
        
    } failBlock:^(NSError *error) {
        
    }];
    
}

-(void)requestSuccess:(id)response
{
    
    NSArray *arrayFeedNew = [FeedNewsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
    
    [arrayFeedNew enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FeedNewsModel *modelNews = obj;
        
        FeedNewContentModel *modelContent = [FeedNewContentModel mj_objectWithKeyValues:modelNews.content];
        [self.mainDaraArrs addObject:modelContent];
    }];
    

    [self.mainTableView reloadData];
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mainDaraArrs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    FeedNewContentModel*model=_mainDaraArrs[indexPath.row];
    
    if(model.cell_type == 0)
    {
        
        FeedNormalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:layoutgrouppiccell];
        
        [cell setModelDataWith:model];
        
        return cell;
    }
//    else if(model.cell_type==FeedWeiBoCell)
//    {
//        TTWeiboTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellweiboidentify];
//        [cell setModelDataWith:model];
//        cell.delegate=self;
//        return  cell;
//    }else if(model.cell_type==FeedNormalCell){
//        TTLayOutGroupPicCell *cell=[tableView dequeueReusableCellWithIdentifier:layoutgrouppiccell];
//        cell.delegate=self;
//        [cell setModelDataWith:model];
//
//        return  cell;
//    }
    else{
        UITableViewCell *otherCell=[tableView dequeueReusableCellWithIdentifier:defaultcell];
        return otherCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.navigationController pushViewController:[SecondViewController new] animated:YES];
}
-(UITableView *)mainTableView
{
    if(!_mainTableView){
        _mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H-44) style:UITableViewStylePlain];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        _mainTableView.tableFooterView=[UIView new];
        _mainTableView.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        _mainTableView.separatorStyle=NO;
        [_mainTableView registerClass:[FeedFocusonTableViewCell class] forCellReuseIdentifier:cellfocuson];
//        [_mainTableView registerClass:[TTWeiboTableViewCell class] forCellReuseIdentifier:cellweiboidentify];
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultcell];
        [_mainTableView registerClass:[FeedNormalTableViewCell class] forCellReuseIdentifier:layoutgrouppiccell];
        
    }
    return _mainTableView;
}

@end
