//
//  ZJPhotoBrowser.h
//  Cupid
//
//  Created by panzhijun on 2019/1/25.
//  Copyright © 2019 panzhijun. All rights reserved.
//


#import "ZJPhotoBrowser.h"
#import "ZJPhotoBrowserConfig.h"
 
@interface ZJPhotoBrowser() <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL hasShowedPhotoBrowser;
@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UILabel *backButton;

@end

@implementation ZJPhotoBrowser

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasShowedPhotoBrowser = NO;
    // 背景颜色黑色
    self.view.backgroundColor = kPhotoBrowserBackgrounColor;
    // 添加scrollview
    [self addScrollView];
    // 添加序号和保存图片按钮
    [self addToolbars];
    // 设置frame
    [self setUpFrames];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_hasShowedPhotoBrowser) {
        [self showPhotoBrowser];
    }
}

#pragma mark 重置各控件frame（处理屏幕旋转）
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self setUpFrames];
}

#pragma mark 设置各控件frame
- (void)setUpFrames
{
    CGRect rect = self.view.bounds;
    rect.size.width += kPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
    _scrollView.center = CGPointMake(SCREEN_W *0.5, SCREEN_H *0.5);
    
    CGFloat y = 0;
    __block CGFloat w = SCREEN_W;
    CGFloat h = SCREEN_H;
    
    //设置所有ZJPhotoBrowserView的frame
    [_scrollView.subviews enumerateObjectsUsingBlock:^(ZJPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = kPhotoBrowserImageViewMargin + idx * (kPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
   
  
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, SCREEN_H);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
}

#pragma mark 显示图片浏览器
- (void)showPhotoBrowser
{
    _hasShowedPhotoBrowser = YES;
    
    _scrollView.hidden = NO;
    _indexLabel.hidden = NO;
    _saveButton.hidden = NO;
}

#pragma mark 添加scrollview
- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.hidden = YES;
    [self.view addSubview:_scrollView];
    
    // 添加图片view
    for (int i = 0; i < self.imageCount; i++) {
        ZJPhotoBrowserView *view = [[ZJPhotoBrowserView alloc] init];
        view.imageview.tag = i;
        //处理单击
        __weak __typeof(self)weakSelf = self;
        view.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            // 点击隐藏图片浏览器
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf hidePhotoBrowser:recognizer];
        };
        
        [_scrollView addSubview:view];
    }
    // 加载图片
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

#pragma mark 添加操作按钮
- (void)addToolbars
{
    //序标
    self.indexLabel = [[UILabel alloc] init];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.font = [UIFont systemFontOfSize:14];
    self.indexLabel.frame = CGRectMake(20 , self.view.height - TABBAE_BOTTOM-30 , 60 , 30 );

    if (self.imageCount >= 1) {
        self.indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
        [self.view addSubview:self.indexLabel];
    }
    
    // 2.保存按钮
    self.saveButton = [[UIButton alloc] init];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.saveButton.frame = CGRectMake(SCREEN_W-60 ,self.view.height - TABBAE_BOTTOM-30 , 60 , 30 );
    [self.saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.saveButton];
}

#pragma mark 保存图像
- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    ZJPhotoBrowserView *currentView = _scrollView.subviews[index];
    UIImageWriteToSavedPhotosAlbum(currentView.imageview.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (!error) {
        [MBProgressHUD showSuccess:@"保存成功"];
    }
    else
    {
        [MBProgressHUD showError:@"保存失败"];
    }
}

- (void)show
{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:nil];
}

#pragma mark 单击退出图片浏览器
- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark 网络加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    ZJPhotoBrowserView *view = _scrollView.subviews[index];
    if (view.beginLoadingImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}

#pragma mark 获取控制器的view
- (UIView *)getParsentView:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

#pragma mark 获取低分辨率（占位）图片
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

#pragma mark 获取高分辨率图片url
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}


#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    long left = index - 2;
    long right = index + 2;
    left = left>0?left : 0;
    right = right>self.imageCount?self.imageCount:right;
    //预加载三张图片
    for (long i = left; i < right; i++) {
        [self setupImageOfImageViewForIndex:i];
    }
    
    MYLog(@"上下:%f",scrollView.contentOffset.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (ZJPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
            view.scrollview.zoomScale = 1.0;
        }
    }
}


// 隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
