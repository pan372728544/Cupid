//
//  HomeOtherDetailViewController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/17.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HomeOtherDetailViewController.h"
#import <WebKit/WebKit.h>
#import "ZJNetworking.h"
#import "HomeRequest.h"
#import "ArtileInfomationModel.h"
#import <MJExtension/MJExtension.h>
#import "LoadingDefaultView.h"

@interface HomeOtherDetailViewController ()<UITableViewDelegate, UITableViewDataSource, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) CGFloat webViewHeight;

@property (nonatomic, strong)ArtileInfomationModel *model;


@property(nonatomic,strong)LoadingDefaultView *defautView;

@end

@implementation HomeOtherDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建导航条
    [self initNavView];
 
        [self.view addSubview:self.webView];
    self.defautView = [[LoadingDefaultView alloc]initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, SCREEN_H-NAVBAR_IPHONEX_H)];
    
    [self.view addSubview:self.defautView];
    // 加载webView
    [self loadMainRequest];
    
//    // webView初始高度
//    self.webViewHeight = 0.0;
//
//    [self createWebView];
//
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.showsHorizontalScrollIndicator = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WebViewCell"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
//    [self.view addSubview:self.tableView];
  
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
    
}


- (WKWebView *)webView {
    if (_webView == nil) {
        // js配置
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        
        // 显示WKWebView
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H,SCREEN_W , SCREEN_H-NAVBAR_IPHONEX_H) configuration:configuration];
        _webView.UIDelegate = self; // 设置WKUIDelegate代理
        _webView.navigationDelegate = self; // 设置WKNavigationDelegate代理
        [self.view addSubview:_webView];
    }
    return _webView;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self.defautView removeFromSuperview];
}

-(void)requessWithResponse:(id)response
{
    self.model =   [ArtileInfomationModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
    
    NSURL *url = [NSURL URLWithString:self.model.url];
    MYLog(@"请求地址====%@======",url);
    
    // 设置请求userAgent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16A366 NewsArticle/7.0.6.14 JsSdk/2.0 NetType/WIFI (News 7.0.6 12.000000)", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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

- (void)dealloc
{
//    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)createWebView
{
    
    
    // 设置wkwebView UserAgent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16A366 NewsArticle/7.0.6.14 JsSdk/2.0 NetType/WIFI (News 7.0.6 12.000000)", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    // 创建webview
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H,SCREEN_W , 1) configuration:wkWebConfig];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.userInteractionEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView sizeToFit];
    
    // 监听webView contentSize 变化
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    
    
    // 创建scrview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_IPHONEX_H, SCREEN_W, 1)];
    [self.scrollView addSubview:self.webView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        // 方法一
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        self.webViewHeight = height;
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, height);
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        
        /*
         // 方法二
         [_webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
         CGFloat height = [result doubleValue] + 20;
         self.webViewHeight = height;
         self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
         self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
         self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, height);
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
         }];
         */
    }
}

#pragma mark tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return _webViewHeight;
            break;
        default:
            return 50;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:@"WebViewCell" forIndexPath:indexPath];
            [webCell.contentView addSubview:self.scrollView];
            return webCell;
        }
            break;
        default:
        {
            UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
            defaultCell.textLabel.text = [NSString stringWithFormat:@"普通的cell，编号：%ld", indexPath.row];
            return defaultCell;
        }
            break;
    }
}


@end
