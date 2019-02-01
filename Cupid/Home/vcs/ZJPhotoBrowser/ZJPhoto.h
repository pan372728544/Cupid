//
//  ZJPhoto.h
//  Cupid
//
//  Created by panzhijun on 2019/1/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZJPhotoBrowserConfigure.h"

@interface ZJPhoto : NSObject

/** 图片地址 */
@property (nonatomic, strong) NSURL *url;

/** 来源imageView */
@property (nonatomic, strong) UIImageView *sourceImageView;

/** 来源frame */
@property (nonatomic, assign) CGRect sourceFrame;

/** 图片(静态) */
@property (nonatomic, strong) UIImage       *image;

/** gif图片 */
@property (nonatomic, strong) UIImage       *gifImage;
@property (nonatomic, strong) NSData        *gifData;
@property (nonatomic, assign) BOOL          isGif;

// imageView对象
@property (nonatomic, strong) UIImageView   *imageView;

/** 占位图 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 图片是否加载完成 */
@property (nonatomic, assign) BOOL finished;
/** 图片是否加载失败 */
@property (nonatomic, assign) BOOL failed;

/** 记录photoView是否缩放 */
@property (nonatomic, assign) BOOL isZooming;

/** 记录photoView缩放时的rect */
@property (nonatomic, assign) CGRect zoomRect;

/** 记录每个ZJPhotoView的滑动位置 */
@property (nonatomic, assign) CGPoint   offset;


@end

