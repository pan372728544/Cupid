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
#import "NSURLProtocol+WKWebVIew.h"
#import "HybridNSURLProtocol.h"
#import "ZJPhotoBrowser.h"


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


@property (nonatomic, strong) NSMutableArray *imgUrls;

@property (nonatomic, strong) NSMutableArray *imgFrames;

@property (nonatomic, strong) UIView *whiteView;


@property(nonatomic,assign)int offset;

@end

@implementation HomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _imgUrls = [NSMutableArray array];
    _imgFrames = [NSMutableArray array];
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
    
    self.webView.height = 10;
    self.tableView.height = 10;
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
    // 请求html数据
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
    
    
    {
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
        
        
    }
    
    
    
            NSMutableString *html = [NSMutableString string];
    {

        [html appendString:@"<html>"];
        [html appendString:@"<head>"];
        [html appendString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />"];
        [html appendString:@"<meta content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\" name=\"viewport\" />"];
        [html appendFormat:@"<style>"];
        [html appendFormat:@"body{\
         font-size:18px;\
         color: black;\
         padding: 8px;\
         /* 文字两端对齐 */\
         text-align: justify;\
         text-justify: inter-ideograph;\
         }\
         img{\
         width: 100%%;\
         height: auto;\
         }\
        .tt-title{font-size:28px;font-weight:bold;font-family:\"Arial\",\"Microsoft Yahei\",\"Simsun\"; margin:0px }\
         .divs{height: 30px;width: auto; margin:10px 10px}\
         .imgstouxiang{display: inline-block;vertical-align: middle;width: 30px;height: 30px;}\
         .info1{display: inline-block;width: 150px;height: 15px;vertical-align: top;font-size: 13px;font-weight: bold;margin-left: 10px;}\
         .info2{display: inline-block;width: auto;height: 15px;vertical-align: bottom;font-size: 10px;margin-left:-150px;color: #333; margin-top:17px}\
        .info3{display: inline-block;width:100%%;height: 30px;vertical-align: middle;color: #333;border-radius: 2px;margin-top: -40px; }\
         .img-touxiang{width: 30px;height: 30px;border-radius: 15px;}\
         .guanzhu{text-decoration:none ;color:white;background-color:#EB4B46 ;border-radius: 4px; font-size:16px; }\
         .p-guanzhu{vertical-align: middle;text-align: right;margin-right: 10px;margin-top: 5px;}"];
        [html appendFormat:@"</style>"];
        [html appendFormat:@"</head>"];
        [html appendFormat:@"<body>"];
        [html appendFormat:@"%@", strContent];
        [html appendString:[self getImgClickJSString]];
        [html appendString:@"</script>"];
        [html appendString:@"</body>"];
        [html appendString:@"</html>"];
        
        
    }


    [self.webView loadHTMLString:html baseURL:nil];
    
}




- (NSString *)getImgClickJSString {
    
    NSMutableString *jsString = [NSMutableString new];
    
    // 给所有图片加入点击事件
    [jsString appendString:@"<script>"];
    [jsString appendString:@"function addImgClick() {\
     var imgs = document.getElementsByTagName('img');\
     for (var i = 0; i < imgs.length; i++) {\
     var img = imgs[i];\
     img.onclick = function() {\
     window.location.href = 'imgurl:' + this.src;\
     }\
     }\
     }"];
    [jsString appendString:@"addImgClick();"];  // 调用js
    
    return jsString;
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
 [ self.containerScrollView.mj_footer endRefreshing];
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

        self.containerScrollView.mj_footer = nil;
    }
    
    [self.maryCommon addObjectsFromArray:self.modelData.data];
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
    [self.tableView reloadData];
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
    
    // 点击图片
    NSString *url = webView.URL.absoluteString;
    
    if ([url hasPrefix:@"imgurl:"]) {
        
        NSString *imgUrl = [url substringFromIndex:7];
        
        NSLog(@"%@", imgUrl);
    
        NSInteger index = [self.imgUrls indexOfObject:imgUrl];
        
        if (index >=0 && index < self.imgUrls.count) {
            [self showImageWithArray:self.imgUrls index:index];
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
    // 请求评论
    [self loadCommentRequest:0];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页导航加载完毕");

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.tableView reloadData];
    [self getImgsJSToWebView:webView];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败,失败原因:%@",[error description]);

}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"网页加载内容进程终止");
}



- (void)showImageWithArray:(NSArray *)imageUrls index:(NSInteger)index {
    NSMutableArray *photos = [NSMutableArray new];
    
    [imageUrls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZJPhoto *photo = [ZJPhoto new];
        photo.url = [NSURL URLWithString:obj];
        
        if (index == idx) {
            CGRect rect = CGRectFromString(self.imgFrames[idx]);
            
            rect.origin.y += NAVBAR_IPHONEX_H;
            
            CGFloat offsetY = self.webView.scrollView.contentOffset.y;
            
            rect.origin.y -= offsetY;
            
            photo.sourceFrame = rect;
        }
        
        // 获取缓存？
        NSURLCache *cache = [NSURLCache sharedURLCache];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:obj]];
        
        NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
        
        UIImage *image = [UIImage imageWithData:response.data];
        
        photo.placeholderImage = image;
        
        [photos addObject:photo];
    }];
    
    
    ZJPhotoBrowser *browser = [ZJPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    browser.showStyle = ZJPhotoBrowserShowStyleZoom;
    browser.hideStyle = ZJPhotoBrowserHideStyleZoomScale;
    
    browser.delegate  = self;
    
    [browser showFromVC:self];
}

#pragma mark - ZJPhotoBrowserDelegate
- (void)photoBrowser:(ZJPhotoBrowser *)browser panBeginWithIndex:(NSInteger)index {
    // 执行js，隐藏对应的图片
    [self addViewToImageWithIndex:index hidden:NO];
}

- (void)photoBrowser:(ZJPhotoBrowser *)browser panEndedWithIndex:(NSInteger)index willDisappear:(BOOL)disappear {
    // 执行js，显示对应的图片
    [self addViewToImageWithIndex:index hidden:YES];
}

- (void)addViewToImageWithIndex:(NSInteger)index hidden:(BOOL)hidden {
    if (hidden) {
        [self.whiteView removeFromSuperview];
        self.whiteView = nil;
    }else {
        CGRect frame = CGRectFromString(self.imgFrames[index]);
        
        CGFloat offsetY = self.webView.scrollView.contentOffset.y;
        
        frame.origin.y -= offsetY;
        
        self.whiteView = [[UIView alloc] initWithFrame:frame];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        [self.webView addSubview:self.whiteView];
    }
}


- (void)getImgsJSToWebView:(WKWebView *)webView {
    // 获取图片地址
    NSString *getImgUrlsJS = @"\
    function getImgUrls() {\
    var imgs = document.getElementsByTagName('img');\
    var urls = [];\
    for (var i = 0; i < imgs.length; i++) {\
    var img = imgs[i];\
    urls[i] = img.src;\
    }\
    return urls;\
    }";
    
    [webView evaluateJavaScript:getImgUrlsJS completionHandler:nil];
    
    [webView evaluateJavaScript:@"getImgUrls()" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {

        // 移除第一个头像
        NSMutableArray *mary = (NSMutableArray *)obj;
        if (mary.count >=1) {
            [mary removeObjectAtIndex:0];
        }
        self.imgUrls = mary;
    }];
    
    // 获取图片frame
    NSString *getImgFramesJS = @"\
    function getImgFrames() {\
    var imgs = document.getElementsByTagName('img');\
    var frames = [];\
    for (var i = 0; i < imgs.length; i++) {\
    var img = imgs[i];\
    var imgX = img.offsetLeft;\
    var imgY = img.offsetTop;\
    var imgW = img.offsetWidth;\
    var imgH = img.offsetHeight;\
    frames[i] = {'x': imgX, 'y': imgY, 'w': imgW, 'h': imgH};\
    }\
    return frames;\
    }";
    
    [webView evaluateJavaScript:getImgFramesJS completionHandler:nil];
    
    [webView evaluateJavaScript:@"getImgFrames()" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSMutableArray *frames = (NSMutableArray *)obj;
        // 移除第一个头像
        if (frames.count>=1) {
            [frames removeObjectAtIndex:0];
        }
        
        NSMutableArray *imgFrames = [NSMutableArray new];
        
        for (NSDictionary *dic in frames) {
            CGRect rect = CGRectMake([dic[@"x"] floatValue],
                                     [dic[@"y"] floatValue],
                                     [dic[@"w"] floatValue],
                                     [dic[@"h"] floatValue]);
            
            [imgFrames addObject:NSStringFromCGRect(rect)];
        }
        self.imgFrames = imgFrames;
    }];
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
        
        NSLog(@"===============tableview=======contentSize===change");
        
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
    
        NSLog(@" load More %f==",self.containerScrollView.contentOffset.y);
    
//    NSLog(@"scrllview  %f == %d",scrollView.contentOffset.y,scrollView.tag);
    if (_containerScrollView != scrollView ) {
        return;
    }
//    if (scrollView.tag == 0) {
//        return;
//    }

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

//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArtileInfomationCommentModel *modelComment = [self.maryCommon objectAtIndex:indexPath.row];
    ArtileInfomationCommentListModel *modelList = modelComment.comment;
    
    NSString *text =modelList.text;
    UIFont *font = [UIFont systemFontOfSize:17];

    CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_W-60, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil].size;
    
   
    return size.height+80;
}



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
        _tableView.estimatedRowHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
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

