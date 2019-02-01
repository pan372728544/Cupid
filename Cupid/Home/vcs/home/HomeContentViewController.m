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
#import "FeedFocusonTableViewCell.h"

static NSString *const cellfocuson=@"cellfocuson";
static NSString *const cellIdentf=@"showCellTop";
static NSString *const headeridentify=@"headeridentify";
static NSString *const defaultcell=@"defaultcell";
static NSString *const cellweiboidentify=@"TTWeiboTableViewCell";
static NSString *const layoutgrouppiccell=@"TTLayOutGroupPicCell";


static NSString *const load_more=@"load_more";
static NSString *const pull=@"pull";
static NSString *const enter_auto=@"enter_auto";


@interface HomeContentViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) NSMutableArray *mainDaraArrs;

@property(nonatomic,copy)NSString *behottime;
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
    
    [self initRefreshView];
    
    
}

-(void)initRefreshView
{
    
    self.mainTableView.mj_header= [MJDrawAnimationHeader headerWithRefreshingBlock:^{
        [self loadMainRequest:pull];
        
    }];
    
    self.mainTableView.mj_footer = [MJLoadMoreFooter footerWithRefreshingBlock:^{
        
        [self loadMainRequest:load_more];
        
    }];
    
    [self.mainTableView.mj_header beginRefreshing];
    
    
    [self loadMainRequest:enter_auto];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    
    
}



-(void)loadMainRequest:(NSString *)pullType
{
    NSString *category = self.category;

    
    // 公共参数
    NSDictionary *dirParams = [HomeRequest getCommonParamDic];
    
    NSMutableDictionary *mdic2 = [NSMutableDictionary dictionary];
    [dirParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mdic2 setObject:obj forKey:key];
    }];
    [mdic2 setValue:pullType forKey:@"tt_from"];
    [mdic2 setValue:category forKey:@"category"];
    [mdic2 setValue:@"1" forKey:@"refresh_reason"];
    if(self.behottime)
    {
        [mdic2 setValue: self.behottime forKey:@"min_behot_time"];
        
    }
    
    [ZJNetworking getWithUrl:[HomeRequest getHomeFeedNewsUrl] refreshRequest:NO cache:NO params:mdic2 progressBlock:nil successBlock:^(id response) {
        [self requestSuccess:response withType:pullType];
        
    } failBlock:^(NSError *error) {
        
    }];
    
}

-(void)requestSuccess:(id)response withType:(NSString *)type
{
    
    NSArray *arrayFeedNew = [FeedNewsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];

    [arrayFeedNew enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FeedNewsModel *modelNews = obj;
        
        FeedNewContentModel *modelContent = [FeedNewContentModel mj_objectWithKeyValues:modelNews.content];
        
        self.behottime = [NSString stringWithFormat:@"%@",modelContent.behot_time];
        if ([type isEqualToString:pull] ) {
            [self.mainDaraArrs insertObject:modelContent atIndex:0];
            
        }
        else if([type isEqualToString:load_more])
        {
            [self.mainDaraArrs addObject:modelContent];
        }
        else if([type isEqualToString:enter_auto])
        {
            [self.mainDaraArrs removeAllObjects];
             [self.mainDaraArrs addObject:modelContent];
        }
        
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
        [_mainTableView registerClass:[FeedFocusonTableViewCell class] forCellReuseIdentifier:cellweiboidentify];
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultcell];
        [_mainTableView registerClass:[FeedNormalTableViewCell class] forCellReuseIdentifier:layoutgrouppiccell];
        
    }
    return _mainTableView;
}

@end
