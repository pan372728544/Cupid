//
//  ZJPhotoBrowserConfigure.h
//  Cupid
//
//  Created by panzhijun on 2019/1/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#ifndef ZJPhotoBrowserConfigure_h
#define ZJPhotoBrowserConfigure_h

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>

#define GKScreenW [UIScreen mainScreen].bounds.size.width
#define GKScreenH [UIScreen mainScreen].bounds.size.height

#define kMaxZoomScale               2.0f

#define kPhotoViewPadding           10

#define kAnimationDuration          0.25f

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);



// 图片浏览器的显示方式
typedef NS_ENUM(NSUInteger, ZJPhotoBrowserShowStyle) {
    ZJPhotoBrowserShowStyleNone,       // 直接显示，默认方式
    ZJPhotoBrowserShowStyleZoom,       // 缩放显示，动画效果
    ZJPhotoBrowserShowStylePush        // push方式展示
};

// 图片浏览器的隐藏方式
typedef NS_ENUM(NSUInteger, ZJPhotoBrowserHideStyle) {
    ZJPhotoBrowserHideStyleZoom,           // 点击缩放消失
    ZJPhotoBrowserHideStyleZoomScale,      // 点击缩放消失、滑动缩小后消失
    ZJPhotoBrowserHideStyleZoomSlide       // 点击缩放消失、滑动平移后消失
};

// 图片浏览器的加载方式
typedef NS_ENUM(NSUInteger, ZJPhotoBrowserLoadStyle) {
    ZJPhotoBrowserLoadStyleIndeterminate,        // 不明确的加载方式
    ZJPhotoBrowserLoadStyleIndeterminateMask,    // 不明确的加载方式带阴影
    ZJPhotoBrowserLoadStyleDeterminate           // 明确的加载方式带进度条
};

#endif /* ZJPhotoBrowserConfigure_h */
