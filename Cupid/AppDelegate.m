//
//  AppDelegate.m
//  Cupid
//
//  Created by panzhijun on 2019/1/3.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Internal.h"
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h> // Only if you have Flutter Plugins
#import "Cupid-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [self initViews];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [GeneratedPluginRegistrant registerWithRegistry:self];
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 配置数据库
    [RealmTool configRealm];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


-(void)initTabBarView
{
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[SocketManager sharedInstance] close];
    NSLog(@"进入后台");
 
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [[SocketManager sharedInstance] connect];
    [[SocketManager sharedInstance] connectWithCompletionHandler:^(BOOL isSuccess) {
        
    }];
        NSLog(@"进入前台");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
