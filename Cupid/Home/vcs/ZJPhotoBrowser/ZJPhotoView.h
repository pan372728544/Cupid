//
//  ZJPhotoView.h
//  Cupid
//
//  Created by panzhijun on 2019/1/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJPhoto.h"


NS_ASSUME_NONNULL_BEGIN

@class ZJPhotoView;

@interface ZJPhotoView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong, readonly) UIImageView  *imageView;


@property (nonatomic, strong, readonly) ZJPhoto *photo;

@property (nonatomic, copy) void(^zoomEnded)(NSInteger scale);

/** 横屏时是否充满屏幕宽度，默认YES，为NO时图片自动填充屏幕 */
@property (nonatomic, assign) BOOL isFullWidthForLandSpace;

/**
 开启这个选项后 在加载gif的时候 会大大的降低内存.与YYImage对gif的内存优化思路一样 default is NO
 */
@property (nonatomic, assign) BOOL isLowGifMemory;

/** 是否重新布局 */
@property (nonatomic, assign) BOOL isLayoutSubViews;

@property (nonatomic, assign) ZJPhotoBrowserLoadStyle loadStyle;


// 设置数据
- (void)setupPhoto:(ZJPhoto *)photo;

- (void)adjustFrame;

// 缩放
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

// 重新布局
- (void)resetFrame;


@end

NS_ASSUME_NONNULL_END
