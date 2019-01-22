//
//  HomeDetailViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "ZJBaseViewController+NavBar.h"
#import <WebKit/WebKit.h>
#import "ZJNetworking.h"
#import "HomeRequest.h"
#import "ArtileInfomationModel.h"
#import <MJExtension/MJExtension.h>
#import "LoadingDefaultView.h"
#import "HomeCommentTableViewCell.h"

#define viewH SCREEN_H-NAVBAR_IPHONEX_H

@interface HomeDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,
WKNavigationDelegate>
{
    CGFloat _lastWebViewContentHeight;
    CGFloat _lastTableViewContentHeight;
}

@property (nonatomic, strong) WKWebView     *webView;

@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, strong) UIScrollView  *containerScrollView;

@property (nonatomic, strong) UIView        *contentView;


@property (nonatomic, strong)ArtileInfomationModel *model;

@property (nonatomic, strong)ArtileInfomationCommentDataModel *modelData;


@property(nonatomic,strong)LoadingDefaultView *defautView;

// 标题数组
@property(nonatomic,strong)NSMutableArray *maryCommon;


@property(nonatomic,assign)int offset;

@end

@implementation HomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.maryCommon = [NSMutableArray array];
    [self initValue];
    [self initView];
    
    // 添加监听事件
    [self addObservers];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSString *path = @"http://toutiao.com/group/6647008405284192771/";
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
//    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
//    [self.webView loadRequest:request];
//
    
   [self initNavView];
}

-(void)initNavView
{
    [self createNavBarViewWithTitle:@""];
    [self createNavLeftBtnWithItem:@"" target:self action:@selector(backClick:)];
    
}



-(void)backClick:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)dealloc{
    [self removeObservers];
}



- (void)initValue{
    _lastWebViewContentHeight = 0;
    _lastTableViewContentHeight = 0;
}

- (void)initView{
    

    // 添加scrollview
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView addSubview:self.contentView];
    
    
    // 添加webview tableview
    [self.contentView addSubview:self.webView];
    [self.contentView addSubview:self.tableView];

    // webviewe在最上面
    self.webView.top = 0;
    
    self.webView.height = viewH;
    // 设置tableview 在webview下面
    self.tableView.top = self.webView.bottom;
    
    self.defautView = [[LoadingDefaultView alloc]initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H)];
    
//    [self.view addSubview:self.defautView];
    // 加载webView
    [self loadMainRequest];
}

-(void)initRefreshView
{
    self.containerScrollView.mj_footer = [MJLoadMoreFooter footerWithRefreshingBlock:^{
        
        self.offset += 20;
        [self loadCommentRequest:self.offset];
        
    }];
}


-(void)loadMainRequest
{
    // 公共参数
    NSDictionary *dirParams = [HomeRequest getCommonParamDic];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [dirParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mdic setObject:obj forKey:key];
    }];
    [mdic setValue:[NSString stringWithFormat:@"%@",self.group_id] forKey:@"group_id" ];
    [mdic setValue:[NSString stringWithFormat:@"%@",self.item_id] forKey:@"item_id"];
    [mdic setValue:self.category forKey:@"from_category"];
    WEAKSELF
    [ZJNetworking getWithUrl:[HomeRequest getHomeArticleInformationUrl] refreshRequest:NO cache:NO params:mdic progressBlock:nil successBlock:^(id response) {
        
        // 处理请求成功数据
        [weakSelf requessWithResponse:response];
        
        
    } failBlock:^(NSError *error) {
        
    }];
    
    
    [self loadCommentRequest:0];
    
}

-(void)loadCommentRequest:(int)offset
{
    // 公共参数
    NSDictionary *dirParams = [HomeRequest getCommonParamDic];

    NSMutableDictionary *mdic2 = [NSMutableDictionary dictionary];
    [dirParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mdic2 setObject:obj forKey:key];
    }];
    [mdic2 setValue:[NSString stringWithFormat:@"%@",self.group_id] forKey:@"group_id" ];
    [mdic2 setValue:@"20" forKey:@"count"];
    [mdic2 setValue:@"1" forKey:@"aggr_type"];
    NSString *off = [NSString stringWithFormat:@"%d",offset];
    
    [mdic2 setObject:off forKey:@"offset"];
    WEAKSELF;
    
    [ZJNetworking getWithUrl:@"http://lg.snssdk.com/article/v4/tab_comments/" refreshRequest:NO cache:NO params:mdic2 progressBlock:nil successBlock:^(id response) {
        
        // 处理请求成功数据
        [weakSelf requessWithResponse2:response];
        
        
    } failBlock:^(NSError *error) {
        
    }];
}


-(void)requessWithResponse2:(id)response
{
    ArtileInfomationCommentDataModel *modelData = [[ArtileInfomationCommentDataModel alloc]init];
   modelData =   [ArtileInfomationCommentDataModel mj_objectWithKeyValues:response ];
    self.modelData = modelData;
    
    if (self.modelData.has_more) {
        [self initRefreshView];
    }
    else
    {
        self.tableView.mj_footer = nil;
    }
    
    [self.maryCommon addObjectsFromArray:self.modelData.data];
    
    [self.tableView reloadData];
}

-(void)requessWithResponse:(id)response
{
    self.model =   [ArtileInfomationModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
    
    NSURL *url = [NSURL URLWithString:[self.model.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    MYLog(@"请求地址====%@======",url);
    
    // 设置请求userAgent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16A366 NewsArticle/7.0.6.14 JsSdk/2.0 NetType/WIFI (News 7.0.6 12.000000)", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.tableView reloadData];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self.defautView removeFromSuperview];
}
#pragma mark - Observers
- (void)addObservers{
    
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers{
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

// 监听contentSize变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == _webView) {
        if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
            [self updateContainerScrollViewContentSize];
        }
    }else if(object == _tableView) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            [self updateContainerScrollViewContentSize];
        }
    }
}

- (void)updateContainerScrollViewContentSize{
    
    // 更新后的webview height
    CGFloat webViewContentHeight = self.webView.scrollView.contentSize.height;
    // tablview size
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    
    // 为0返回
    if (webViewContentHeight == _lastWebViewContentHeight && tableViewContentHeight == _lastTableViewContentHeight) {
        return;
    }
    
    // 更新高度
    _lastWebViewContentHeight = webViewContentHeight;
    _lastTableViewContentHeight = tableViewContentHeight;
    
    // 设置scrollview滚动范围
    self.containerScrollView.contentSize = CGSizeMake(SCREEN_W, webViewContentHeight + tableViewContentHeight);
    
    CGFloat webViewHeight = (webViewContentHeight < viewH) ? webViewContentHeight : viewH;
    
    CGFloat tableViewHeight = tableViewContentHeight < viewH ?tableViewContentHeight :viewH;
    
    self.webView.height = webViewHeight <= 0.1 ? 0.1 :webViewHeight;
    
    self.contentView.height = webViewHeight + tableViewHeight;
    
    self.tableView.height = tableViewHeight;
    self.tableView.top = self.webView.bottom;
    
    //Fix:contentSize变化时需要更新各个控件的位置
    [self scrollViewDidScroll:self.containerScrollView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_containerScrollView != scrollView) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat webViewHeight = self.webView.height;
    CGFloat tableViewHeight = self.tableView.height;
    
    CGFloat webViewContentHeight = self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    
    if (offsetY <= 0) {
        self.contentView.top = 0;
        self.webView.scrollView.contentOffset = CGPointZero;
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < webViewContentHeight - webViewHeight){
        self.contentView.top = offsetY;
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetY);
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < webViewContentHeight){
        self.contentView.top = webViewContentHeight - webViewHeight;
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        self.tableView.contentOffset = CGPointZero;
    }else if(offsetY < webViewContentHeight + tableViewContentHeight - tableViewHeight){
        self.contentView.top = offsetY - webViewHeight;
        self.tableView.contentOffset = CGPointMake(0, offsetY - webViewContentHeight);
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
    }else if(offsetY <= webViewContentHeight + tableViewContentHeight ){
        self.contentView.top = self.containerScrollView.contentSize.height - self.contentView.height;
        self.webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        self.tableView.contentOffset = CGPointMake(0, tableViewContentHeight - tableViewHeight);
    }else {
        //do nothing
        NSLog(@"do nothing");
    }
    NSLog(@"%f===================",offsetY);
}

#pragma mark - UITableViewDataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.maryCommon.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HomeCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    }
    
    ArtileInfomationCommentModel *modelComment = [self.maryCommon objectAtIndex:indexPath.row];
    ArtileInfomationCommentListModel *modelList = modelComment.comment;
    
    
    cell.model = modelList;
    
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:modelList.user_profile_image_url]];
//    cell.textLabel.text = modelList.text;
    return cell;
}












#pragma mark - private
- (WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences.minimumFontSize = 9.0;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H) configuration:configuration];
        _webView.scrollView.scrollEnabled = NO;
        _webView.navigationDelegate = self;
    }
    
    return _webView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}

- (UIScrollView *)containerScrollView {
    if (_containerScrollView == nil) {
        _containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H)];
        _containerScrollView.delegate = self;
        _containerScrollView.alwaysBounceVertical = YES;
    }
    
    return _containerScrollView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, (SCREEN_H-NAVBAR_IPHONEX_H)*2)];
    }
    
    return _contentView;
}


@end

