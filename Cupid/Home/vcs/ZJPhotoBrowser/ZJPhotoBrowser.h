//
//  ZJPhotoBrowser.h
//  Cupid
//
//  Created by panzhijun on 2019/1/25.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJPhotoBrowserView.h"
#import "ZJBasePresentViewController.h"

@class ZJPhotoBrowser;

@protocol ZJPhotoBrowserDelegate <NSObject>

- (UIImage *)photoBrowser:(ZJPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
- (NSURL *)photoBrowser:(ZJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;


@end


// 图片浏览器
@interface ZJPhotoBrowser : UIViewController

@property (nonatomic, weak) UIView *sourceImagesContainerView;
// 当前页
@property (nonatomic, assign) NSInteger currentImageIndex;

//图片总数
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<ZJPhotoBrowserDelegate> delegate;

- (void)show;

@end
