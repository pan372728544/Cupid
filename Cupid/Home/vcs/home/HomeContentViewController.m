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
#import "ZJNetworking.h"
#import "UIImageView+WebCache.h"
#import "HomeRequest.h"
#import "FeedNewContentModel.h"
#import "FeedNewsModel.h"
#import "FeedFocusonTableViewCell.h"
#import <MJExtension/MJExtension.h>
#import "FeedNormalTableViewCell.h"
#import "HomeDetailViewController.h"
#import "FeedFocusonTableViewCell.h"
#import "RequestConst.h"
#import <MJRefresh/MJRefresh.h>
#import "MJDrawAnimationHeader.h"
#import "MJLoadMoreFooter.h"
#import "HomeOtherDetailViewController.h"

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
    [self loadMainRequest];
    [self.view addSubview:self.mainTableView];
    
    [self initRefreshView];
    
    
}

-(void)initRefreshView
{
    
    self.mainTableView.mj_header= [MJDrawAnimationHeader headerWithRefreshingBlock:^{
        [self loadMainRequest];
        
    }];
    
    self.mainTableView.mj_footer = [MJLoadMoreFooter footerWithRefreshingBlock:^{
        
        [self loadMainRequest];
        
    }];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    
    
}



-(void)loadMainRequest
{
    NSString *category = self.category;
    NSLog(@"选中的分类是：==========%@",category);
    NSDictionary *dirParams = @{@"category":category};
    
        NSDictionary *rootPram=@{@"version_code":@"7.0.5",@"app_name":@"news_article",@"vid":@"3678164C-BC97-4BDE-90C3-3796BF8C39DA",@"device_id":@"3002398707",@"channel":@"pp",@"openudid":@"5f892e162435cdbae5dc2856c69bb9ecbc678040",@"idfv":@"3678164C-BC97-4BDE-90C3-3796BF8C39DA",@"iid":@"12374638189",@"category":category};
    
    [ZJNetworking getWithUrl:[HomeRequest getHomeFeedNewsUrl] refreshRequest:NO cache:NO params:rootPram progressBlock:nil successBlock:^(id response) {
        [self requestSuccess:response];
        
    } failBlock:^(NSError *error) {
        
    }];
    
}

-(void)requestSuccess:(id)response
{
    
    NSArray *arrayFeedNew = [FeedNewsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
[self.mainDaraArrs removeAllObjects];
    [arrayFeedNew enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FeedNewsModel *modelNews = obj;
        
        FeedNewContentModel *modelContent = [FeedNewContentModel mj_objectWithKeyValues:modelNews.content];
     
        [self.mainDaraArrs addObject:modelContent];
    }];
    
    [self.mainTableView.mj_header endRefreshing];
    
    [self.mainTableView.mj_footer endRefreshing];
    
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
    
    if(model.cell_type == FeedNormalCell)
    {

        FeedNormalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:layoutgrouppiccell];

        [cell setModelDataWith:model];

        return cell;
        
    }
//    else if(model.cell_type == FeedWeiBoCell)
//    {
//        TTWeiboTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellweiboidentify];
//        [cell setModelDataWith:model];
//        cell.delegate=self;
//        return  cell;
//    }
    
//    else if(model.cell_type == FeedNormalCell){
//        TTLayOutGroupPicCell *cell=[tableView dequeueReusableCellWithIdentifier:layoutgrouppiccell];
//        cell.delegate=self;
//        [cell setModelDataWith:model];
//
//        return  cell;
//    }
    else
    {
        
        UITableViewCell *otherCell=[tableView dequeueReusableCellWithIdentifier:defaultcell];
        otherCell.textLabel.text = [NSString stringWithFormat:@"类型为：%@ 数据",@(model.cell_type)];
        return otherCell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedNewContentModel*model=_mainDaraArrs[indexPath.row];
    HomeDetailViewController *vc =   [HomeDetailViewController new];
    vc.group_id = model.group_id;
    vc.item_id = model.item_id;
    vc.category = self.category;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableView *)mainTableView
{
    if(!_mainTableView){
        _mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H-TABBAR_IPHONEX_H-44) style:UITableViewStylePlain];
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
