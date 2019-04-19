//
//  ZJPhotoView.m
//  Cupid
//
//  Created by panzhijun on 2019/1/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJPhotoView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/NSData+ImageContentType.h>
#import <SDWebImage/SDImageCache.h>

@interface ZJPhotoView()

@property (nonatomic, strong, readwrite) UIScrollView   *scrollView;

@property (nonatomic, strong, readwrite) UIImageView    *imageView;


@property (nonatomic, strong, readwrite) ZJPhoto        *photo;


@property (nonatomic, strong) id operation;

@end

@implementation ZJPhotoView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
        _scrollView.multipleTouchEnabled = YES; // 多点触摸开启
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;

    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}


- (void)setupPhoto:(ZJPhoto *)photo {
    _photo = photo;
    
    // 加载图片
    [self loadImageWithPhoto:photo];
}

#pragma mark - 加载图片
- (void)loadImageWithPhoto:(ZJPhoto *)photo {

    if (photo) {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        [self.scrollView addSubview:self.imageView];
        
        // 每次设置数据时，恢复缩放
        [self.scrollView setZoomScale:1.0 animated:NO];
        
        [self.imageView sd_setImageWithURL:photo.url];
        // 获取缓存图片
        UIImage *imageCache = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photo.url.absoluteString];
        if (!imageCache) {
         
        }
        else
        {
            self.imageView.image = imageCache;
        }
        self.imageView.contentMode   = photo.sourceImageView.contentMode;


        
        if (self.imageView.image) {
            [self adjustFrame];
        }else if (!CGRectEqualToRect(photo.sourceFrame, CGRectZero)) {
            [self adjustFrame];
        }
        photo.image = imageCache;
        if (photo.image.images.count > 1) {
            photo.finished = YES;
            return;
        }

    }
    else {
        self.imageView.image = nil;
        
        [self adjustFrame];
    }
}



- (void)resetFrame {
    self.scrollView.frame  = self.bounds;
    if (self.photo) {
        [self adjustFrame];
    }
}



#pragma mark - 调整frame
- (void)adjustFrame {
    CGRect frame = self.scrollView.frame;
    
    if (self.imageView.image) {
        CGSize imageSize = self.imageView.image.size;
        CGRect imageF = (CGRect){{0, 0}, imageSize};
        
        // 图片的宽度 = 屏幕的宽度
        CGFloat ratio = frame.size.width / imageF.size.width;
        imageF.size.width  = frame.size.width;
        imageF.size.height = ratio * imageF.size.height;
        
        // 默认情况下，显示出的图片的宽度 = 屏幕的宽度
        // 如果kIsFullWidthForLandSpace = NO，需要把图片全部显示在屏幕上
        // 此时由于图片的宽度已经等于屏幕的宽度，所以只需判断图片显示的高度>屏幕高度时，将图片的高度缩小到屏幕的高度即可
        
        if (!self.isFullWidthForLandSpace) {
            // 图片的高度 > 屏幕的高度
            if (imageF.size.height > frame.size.height) {
                CGFloat scale = imageF.size.width / imageF.size.height;
                imageF.size.height = frame.size.height;
                imageF.size.width  = imageF.size.height * scale;
            }
        }
        
        // 设置图片的frame
        self.imageView.frame = imageF;
        
        self.scrollView.contentSize = self.imageView.frame.size;
        
        if (imageF.size.height <= self.scrollView.bounds.size.height) {
            self.imageView.center = CGPointMake(self.scrollView.bounds.size.width * 0.5, self.scrollView.bounds.size.height * 0.5);
        }else {
            self.imageView.center = CGPointMake(self.scrollView.bounds.size.width * 0.5, imageF.size.height * 0.5);
        }
        
        // 根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height / imageF.size.height;
        
        maxScale = frame.size.width / imageF.size.width > maxScale ? frame.size.width / imageF.size.width : maxScale;
        // 超过了设置的最大的才算数
        maxScale = maxScale > kMaxZoomScale ? maxScale : kMaxZoomScale;
        // 初始化
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = maxScale;
    }else if (!CGRectEqualToRect(self.photo.sourceFrame, CGRectZero)) {
        CGFloat width = frame.size.width;
        CGFloat height = width * self.photo.sourceFrame.size.height / self.photo.sourceFrame.size.height;
        _imageView.bounds = CGRectMake(0, 0, width, height);
        _imageView.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        self.scrollView.contentSize = self.imageView.frame.size;
        
//        self.loadingView.bounds = self.scrollView.frame;
//        self.loadingView.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
//        [self.loadingView removeAnimation];
    }else {
        frame.origin        = CGPointZero;
        CGFloat width       = frame.size.width;
        CGFloat height      = width;
        _imageView.bounds   = CGRectMake(0, 0, width, height);
        _imageView.center   = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        // 重置内容大小
        self.scrollView.contentSize = self.imageView.frame.size;
        
//        self.loadingView.bounds = self.scrollView.frame;
//        self.loadingView.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
//        [self.loadingView removeAnimation];
    }
    self.scrollView.contentOffset = CGPointZero;
    
    // frame调整完毕，重新设置缩放
    if (self.photo.isZooming) {
        [self zoomToRect:self.photo.zoomRect animated:NO];
    }
    
    // 重置offset
    self.scrollView.contentOffset = self.photo.offset;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated {
    [self.scrollView zoomToRect:rect animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.photo.offset = scrollView.contentOffset;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    !self.zoomEnded ? : self.zoomEnded(scrollView.zoomScale);
}

- (void)cancelCurrentImageLoad {
    [self.imageView sd_cancelCurrentImageLoad];
}

- (void)dealloc {
    [self cancelCurrentImageLoad];
}

@end
