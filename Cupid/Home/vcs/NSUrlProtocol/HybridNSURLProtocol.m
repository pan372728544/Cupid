//
//  HybridNSURLProtocol.h
//  Cupid
//
//  Created by panzhijun on 2019/1/25.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "HybridNSURLProtocol.h"
#import <UIKit/UIKit.h>
#import "NSData+ImageContentType.h"
#import "UIImage+MultiFormat.h"
#import <SDImageCache.h>


// 获取请求中包含large的请求地址
static NSString*const sourUrl  = @"/large/";


static NSString* const KHybridNSURLProtocolHKey = @"KHybridNSURLProtocol";
@interface HybridNSURLProtocol ()<NSURLSessionDelegate>
@property (nonnull,strong) NSURLSessionDataTask *task;

@property(nonatomic,strong)NSMutableData *mutableData;

@end


@implementation HybridNSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"]  == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ))
    {
        //看看是否已经处理过了，防止无限循环
        if (![NSURLProtocol propertyForKey:KHybridNSURLProtocolHKey inRequest:request] && [request.URL.absoluteString containsString:sourUrl])
        {
            // 返回YES才会走下面的代码，否则不执行后面的代码
            return YES;
        }
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    
    // 修改请求地址
    if ([request.URL.absoluteString containsString:sourUrl])
    {
        NSURL* url1 = [NSURL URLWithString:request.URL.absoluteString];
        mutableReqeust = [NSMutableURLRequest requestWithURL:url1];
    }
    
    return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];

    // 设置该请求已经请求过标记
    [NSURLProtocol setProperty:@YES forKey:KHybridNSURLProtocolHKey inRequest:mutableReqeust];
    
    
    //查看本地是否已经缓存了图片
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:self.request.URL];
    
    // 根据key获取对应的image图片
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    // 图片存在就去直接从缓存中获取图片分配给respponse
    if (image) {
        
        MYLog(@"url ==== %@   使用的是缓存图片SDWEbImage*************",mutableReqeust.URL.absoluteString);
        NSData *data = UIImagePNGRepresentation(image);
        
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
                                                            MIMEType:[NSData sd_contentTypeForImageData:data]
                                               expectedContentLength:data.length
                                                    textEncodingName:nil];
        [self.client URLProtocol:self
              didReceiveResponse:response
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    }
    else
    {
        // 没有缓存图片就去下载图片
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        self.task = [session dataTaskWithRequest:self.request];
        [self.task resume];
    }
        
  
}
- (void)stopLoading
{
    if (self.task != nil)
    {
        [self.task  cancel];
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    self.mutableData = [NSMutableData data];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [self.mutableData appendData:data];
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    
    // 下载的图片内容放进缓存中
    if ([self.request.URL.absoluteString containsString:sourUrl]) {
        UIImage *cacheImage = [UIImage sd_imageWithData:self.mutableData];
        //利用SDWebImage提供的缓存进行保存图片
        [[SDImageCache sharedImageCache] storeImage:cacheImage
                               recalculateFromImage:NO
                                          imageData:self.mutableData
                                             forKey:[[SDWebImageManager sharedManager] cacheKeyForURL:self.request.URL]
                                             toDisk:YES];
    }
    [self.client URLProtocolDidFinishLoading:self];
}

@end
