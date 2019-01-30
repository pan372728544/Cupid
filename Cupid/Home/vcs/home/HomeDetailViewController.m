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
#import "ZJPhotoBrowser.h"
#import "NSURLProtocol+WKWebVIew.h"
#import "HybridNSURLProtocol.h"

#define viewH SCREEN_H-NAVBAR_IPHONEX_H

@interface HomeDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,
WKNavigationDelegate,ZJPhotoBrowserDelegate>
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
@property (nonatomic, strong)ArtileInfomationHtmlModel *modelHtml;


@property(nonatomic,strong)LoadingDefaultView *defautView;

// 标题数组
@property(nonatomic,strong)NSMutableArray *maryCommon;


@property(nonatomic, strong)NSMutableArray *imageArray;//HTML中的图片个数


@property(nonatomic,assign)int offset;

@end

@implementation HomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [NSURLProtocol registerClass:[HybridNSURLProtocol class]];
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
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
    
    
//    UIImageView *img = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    
//    NSString *urlStr = @"http%3A%2F%2Fp9-tt.bytecdn.cn%2Flarge%2Fpgc-image%2F14d157c5e6074118a4d8854994df7d65";
//    
//    urlStr = [urlStr stringByRemovingPercentEncoding];
//    //    str = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
//    //    NSLog(@"百分比编码：%@",urlStr);
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
//    img.image = [UIImage imageWithData:data];
//    [self.view addSubview:img];
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
    
    [self.view addSubview:self.defautView];
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
    
    
    // 请求评论
    [self loadCommentRequest:0];
    
    // 请求头像html数据
    [self loadHtmlContent];
    
}

// 加载html内容
-(void)loadHtmlContent
{
    
    NSString *requestUrl = [NSString stringWithFormat:@"https://a3.pstatp.com/article/content/22/2/%@/%@/1/0/0/",self.group_id,self.group_id];
    
    // 公共参数
    NSDictionary *dirParams = [HomeRequest getCommonParamDic];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [dirParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mdic setObject:obj forKey:key];
    }];
    WEAKSELF
    [ZJNetworking getWithUrl:requestUrl refreshRequest:NO cache:NO params:mdic progressBlock:nil successBlock:^(id response) {
        
        // 处理请求成功数据
        [weakSelf requessWithResponseHtmlContent:response];
        
        
    } failBlock:^(NSError *eror) {
        
    }];
    
    
}

-(void)requessWithResponseHtmlContent:(id)response
{
    // 清除wkwebview缓存
    [self clearCache];
   ArtileInfomationHtmlModel *modelHtml=   [ArtileInfomationHtmlModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
    
    self.modelHtml = modelHtml;
    
    
    // 标题图片
    ArtileInfomationHtmlTitleImageModel *modetitle = modelHtml.title_image;
    if (modetitle.title_image_url) {
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:modetitle.title_image_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self createNavBarViewWithTitle:imgV];
        }];
        
  
    }
    
    NSString *strContent = modelHtml.content;
    
    ArtileInfomationHtmlH5ExtraModel *modelH5 = modelHtml.h5_extra;
    
    // 添加媒体头部信息
    NSString *div = [NSString stringWithFormat:@"</header> <div class=\"divs\"> <div class=\"imgstouxiang\"><img  class=\"img-touxiang\" src=\"%@\" ></div><div class=\"info1\">%@</div><div class=\"info2\">%@</div><div class=\"info3\"><div class=\"p-guanzhu\"><a class=\"guanzhu\" href=\"guanzhu://aaa\">&nbsp;关注&nbsp;</a></div></div></div>",modelH5.media.avatar_url,modelH5.media.name,modelH5.media.auth_info];
    
     strContent= [strContent stringByReplacingOccurrencesOfString:@"</header>" withString:div];
    
    // 替换a标签
    strContent= [strContent stringByReplacingOccurrencesOfString:@"<a class=\"image\"" withString:@"<img class=\"image\""];
    strContent=  [strContent stringByReplacingOccurrencesOfString:@" ></a>" withString:@"/>"];

    for (int i=0;i<modelHtml.image_detail.count;i++) {

        ArtileInfomationHtmlImglistModel *imgModel = modelHtml.image_detail[i];
        NSString *strUrl = imgModel.url;

        NSString *stringf = [NSString stringWithFormat:@"index=%d\"  src=\"%@\"",i,strUrl];
        NSString *str1 = [NSString stringWithFormat:@"index=%d\"",i];
        strContent = [strContent stringByReplacingOccurrencesOfString:str1 withString:stringf];

    }
    
    // 添加meta
    strContent = [strContent stringByAppendingString:@"<meta name=\"viewport\" content=\"width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no\" />"];
    
    // 添加样式
    
    strContent= [strContent stringByAppendingString:@"<style>"
 ".tt-title"
        "{font-size:20px;font-weight:bold;font-family:\"Arial\",\"Microsoft Yahei\",\"Simsun\"; margin:10px }"
 "p"
    "{font-size:16px; color:#333; margin:10px} .pgc-img{ margin:10px 10px; } "
 "img"
    "{width:100%; height:auto;}.ql-align-justify{font-size: 20px;margin: 10px ;}"
 ".divs"
    "{height: 30px;width: auto;}"
 ".imgstouxiang"
    "{display: inline-block;vertical-align: middle;width: 30px;height: 30px;}"
 ".info1"
    "{display: inline-block;width: 150px;height: 15px;vertical-align: top;font-size: 13px;font-weight: bold;margin-left: 10px;}"
 ".info2"
    "{display: inline-block;width: auto;height: 15px;vertical-align: bottom;font-size: 10px;margin-left:-150px;color: #333; margin-top:17px}"
 ".info3"
    "{display: inline-block;width:100%;height: 30px;vertical-align: middle;color: #333;border-radius: 2px;margin-top: -40px; }"
 ".img-touxiang"
    "{width: 30px;height: 30px;border-radius: 15px;}"
 ".guanzhu"
     "{text-decoration:none ;color:white;background-color: red;border-radius: 4px; font-size:14px; }"
 ".p-guanzhu"
    "{vertical-align: middle;text-align: right;margin-right: 10px;margin-top: 5px;}"
 "</style>"
];
    

    [self.webView loadHTMLString:strContent baseURL:nil];
    
    [self.tableView reloadData];
    
}


// 清除缓存
-(void)clearCache
{
    
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 9.0)
    {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }
    else
    {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        
    }
    
}

// 评论请求
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
    if ([self.model.url containsString:@"http://toutiao.com"] || [self.model.url containsString:@"www.wukong.com"]) {
        return;
    }
    
    // 设置请求userAgent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16A366 NewsArticle/7.0.6.14 JsSdk/2.0 NetType/WIFI (News 7.0.6 12.000000)", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.tableView reloadData];
}

#pragma mark - WKWebView NavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"是否允许这个导航");
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {

    NSLog(@"知道返回内容之后，是否允许加载，允许加载");
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");
    
    [self.defautView removeFromSuperview];
    // 处理点击关注按钮
    if ([webView.URL.absoluteString containsString:@"guanzhu://aaa"]) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"确定要关注该账号吗？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  //响应事件
                                                                  NSLog(@"action = %@", action);
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 NSLog(@"action = %@", action);
                                                             }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    // 处理图片点击事件
    if ([webView.URL.absoluteString containsString:@"image-preview"])
    {
        
        NSString *url = [webView.URL.absoluteString substringFromIndex:14];
        
        MYLog(@"图片地址：%@",url);
        //启动图片浏览器， 跳转到图片浏览页面
        if (_imageArray.count != 0) {

            ZJPhotoBrowser *browserVc = [[ZJPhotoBrowser alloc] init];
            browserVc.imageCount = self.imageArray.count; // 图片总数
            browserVc.currentImageIndex = [_imageArray indexOfObject:url];//当前点击的图片
            browserVc.delegate = self;
            [browserVc show];

        }
        
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"跳转到其他的服务器");
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"网页由于某些原因加载失败");

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页开始接收网页内容");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页导航加载完毕");

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.title = webView.title;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable ss, NSError * _Nullable error) {
        NSLog(@"----document.title:%@---webView title:%@",ss,webView.title);
    }];
    
    
    //    插入js代码，对图片进行点击操作
    [webView evaluateJavaScript:@"function imageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0; i < length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}" completionHandler:^(id object, NSError *error) {
        
    }];
    [webView evaluateJavaScript:@"imageClickAction();" completionHandler:^(id object, NSError *error) {
        
    }];

    [self getImgesCount];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败,失败原因:%@",[error description]);

}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"网页加载内容进程终止");
}
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
//    NSLog(@"receive");
//}



#pragma mark -- 获取文章中的图片个数
- (NSArray *)getImgesCount
{
    
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    NSInteger numberImage = [self nodeCountOfTag:@"img"];

   if(numberImage > 1)
    {
        for (int i=1; i < numberImage ; i++) {
            NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
            
            
            __block BOOL isExecuted = NO;
            [self.webView evaluateJavaScript:jsString completionHandler:^(NSString *str, NSError *error) {
                
                if (error ==nil) {
                    [arrImgURL addObject:str];
                    isExecuted = YES;
                }

            }];
            while (isExecuted == NO) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
        }
    }
    
    
  
    _imageArray = [NSMutableArray arrayWithArray:arrImgURL];
    
    
    return arrImgURL;
}

// 获取某个标签的结点个数
- (NSInteger)nodeCountOfTag:(NSString *)tag
{
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    
    __block NSString* result = nil;
    __block BOOL isExecuted = NO;
    [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        result = obj;
        isExecuted = YES;
    }];
    
    while (isExecuted == NO) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    NSInteger tempInter = [result integerValue];
    
    
    return tempInter;
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(ZJPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //图片浏览时，未加载出图片的占位图
    return [UIImage imageNamed:@"gg_pic@2x"];
    
}

- (NSURL *)photoBrowser:(ZJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.imageArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
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
//    NSLog(@"%f===================",offsetY);
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
        
        
//        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
//        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//        configuration.userContentController = wkUController;
//        configuration.preferences.minimumFontSize = 9.0;
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

