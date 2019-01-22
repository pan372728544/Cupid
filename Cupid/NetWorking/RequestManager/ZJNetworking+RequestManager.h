//
//  ZJNetworking+RequestManager.h
//  ZJNetworking
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJNetworking.h"

@interface ZJNetworking (RequestManager)
/**
 *  判断网络请求池中是否有相同的请求
 *
 *  @param task 网络请求任务
 *
 *  @return bool
 */
+ (BOOL)haveSameRequestInTasksPool:(ZJURLSessionTask *)task;

/**
 *  如果有旧请求则取消旧请求
 *
 *  @param task 新请求
 *
 *  @return 旧请求
 */
+ (ZJURLSessionTask *)cancleSameRequestInTasksPool:(ZJURLSessionTask *)task;

@end
