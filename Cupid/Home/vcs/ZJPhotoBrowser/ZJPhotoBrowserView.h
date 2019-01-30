//
//  ZJPhotoBrowserView.h
//  Cupid
//
//  Created by panzhijun on 2019/1/25.
//  Copyright © 2019 panzhijun. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ZJPhotoBrowserView : UIView

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL beginLoadingImage;

//单击回调
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
