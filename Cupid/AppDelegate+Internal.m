//
//  AppDelegate+Internal.m
//  Cupid
//
//  Created by panzhijun on 2019/1/8.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "AppDelegate+Internal.h"
#import "ZJBaseNavigationController.h"
#import "HomeViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "LoginViewController.h"

#import "ZJTabBarManager.h"

#import "ZJBaseTabBarController.h"
#import "Cupid-Swift.h"


@implementation AppDelegate (Internal)


-(void)initViews
{
    // 创建出示window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    
    [self initTabBarView];
}



// 初始化tabbarview
-(void)initTabBarView
{
    
    ZJBaseTabBarController *tabBarViewController = [ZJBaseTabBarController createTabBarController:^ZJTabBarConfig *(ZJTabBarConfig * _Nonnull config) {
        
        // 首页
        HomeViewController * homeVC = [HomeViewController new];
        
        // IM
        TabChatViewController * secondVC = [TabChatViewController new];
        
        // 小视频
        VideoViewController * thirdVC = [VideoViewController new];
        
        // 我的
        FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
        [flutterViewController setInitialRoute:@"myApp"];
        
        // 要与main.dart中一致
        NSString *channelName = @"com.pages.your/native_get";
        
        FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:flutterViewController];
        
        [messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            // call.method 获取 flutter 给回到的方法名，要匹配到 channelName 对应的多个 发送方法名，一般需要判断区分
            // call.arguments 获取到 flutter 给到的参数，（比如跳转到另一个页面所需要参数）
            // result 是给flutter的回调， 该回调只能使用一次
            NSLog(@"method=%@ \narguments = %@", call.method, call.arguments);
            
            // method和WKWebView里面JS交互很像
            // flutter点击事件执行后在iOS跳转TargetViewController
            if ([call.method isEqualToString:@"iOSFlutter"]) {
                LoginViewController *vc = [[LoginViewController alloc] init];
                
                UIWindow *windowW = [UIApplication sharedApplication].keyWindow;
                UIViewController *rootViewController1 = windowW.rootViewController;
                
                [rootViewController1 presentViewController:vc animated:YES completion:nil];
            }
            // flutter传参给iOS
            if ([call.method isEqualToString:@"iOSFlutter1"]) {
                NSDictionary *dic = call.arguments;
                NSLog(@"arguments = %@", dic);
                NSString *code = dic[@"code"];
                NSArray *data = dic[@"data"];
                NSLog(@"code = %@", code);
                NSLog(@"data = %@",data);
                NSLog(@"data 第一个元素%@",data[0]);
                NSLog(@"data 第一个元素类型%@",[data[0] class]);
            }
            // iOS给iOS返回值
            if ([call.method isEqualToString:@"iOSFlutter2"]) {
                if (result) {
                    result(@"返回给flutter的内容");
                }
            }
        }];
        

        config.viewControllers = @[homeVC, secondVC, thirdVC,flutterViewController];
        
        config.normalImages = @[@"home_tabbar_night_32x32_",@"video_tabbar_night_32x32_",@"huoshan_tabbar_night_32x32_",@"no_login_tabbar_night_33x32_"];
        config.selectedImages = @[@"home_tabbar_press_32x32_", @"video_tabbar_press_32x32_", @"huoshan_tabbar_press_32x32_",@"no_login_tabbar_press_33x32_"];
        config.titles = @[@"首页",@"聊天",@"小视频",@"未登录"];
        
        config.isNavigation = NO;
        return config;
    }];
    
    ZJBaseNavigationController *navRoot = [[ZJBaseNavigationController alloc]initWithRootViewController:tabBarViewController];
    navRoot.hidesBottomBarWhenPushed = YES;
    navRoot.tabBarController.tabBar.hidden = YES;
    self.window.rootViewController = navRoot;
    [self.window makeKeyAndVisible];
}


@end
