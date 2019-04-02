//
//  GMCCardAnimationView.m
//  Cupid
//
//  Created by panzhijun on 2019/4/2.
//  Copyright © 2019 panzhijun. All rights reserved.
//


#import "GMCCardAnimationView.h"
#import "GMCDefaultCardView.h"


@interface GMCCardAnimationView ()

/// 当前第一个view
@property (nonatomic, strong) UIView *frontView;

///队列中的view
@property (nonatomic, strong) UIView *queryView;

/// 所有在视图中的view
@property (nonatomic, strong) NSMutableArray *showViewsMulAry;

/// 当被推出的视图数量
@property (nonatomic, assign) NSInteger currentCount;

/// 视图中显示的视图数量
@property (nonatomic, assign) NSInteger showCount;

/// 视图中显示的最大视图数量
@property (nonatomic, assign) NSInteger maxCount;


/// 后面应添加的卡片的索引
@property (nonatomic, assign) NSInteger presentCount;

/// 当前第一个view的center
@property (nonatomic, assign) CGPoint tagetCenter;

/// 本视图的中心点
@property (nonatomic, assign) CGPoint preferCenter;

/// 队列中view的center
@property (nonatomic, assign) CGPoint queryViewCenter;

/// 当前第一个view是否可以被拖动
@property (nonatomic, assign,getter=isCanMoveView) BOOL canMoveView;

/// 是否忽视本次手势
@property (nonatomic, assign,getter=isIgnoreGes) BOOL ignoreGes;


@end

/// 卡片间隔
static CGFloat gGlobalviewGaps = 15.0;

/// 卡片缩放比例
static CGFloat gGlobalviewScale = 0.04;


@implementation GMCCardAnimationView


#pragma mark -------------------Public-------------------
-(id)initWithFrame:(CGRect)frame maxCount:(NSInteger)maxCount {
    
    if (self = [super initWithFrame:frame])
    {
        // 中心点
        self.preferCenter = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
        
        // 划出去的卡片数量
        self.currentCount = 0;
        
        // 显示的默认卡片数量
        self.showCount = 1;
        
        // 最大显示数量
        self.maxCount = maxCount;
        
        // 默认添加三个卡片
        [self addDefaultCardViewInViewWithDefault:YES count:self.showCount];
        
    }
    return self;
}


#pragma mark -------------------Private-------------------
- (void)panned:(UIPanGestureRecognizer *)sender {
    
    CGPoint transition = [sender translationInView:self.frontView];
    
    CGPoint velocity = [sender velocityInView:self.frontView];
    
    // 最后一页 不可以左划
    if (self.currentCount+1 == self.showCount  &&  (velocity.x <0 || transition.y<0 ||(velocity.x>=0&&transition.y>0)) && self.isCanMoveView )
    {
        return;
    }
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            // 向左滑动
            if ( velocity.x<0 || transition.y < 0){
                self.canMoveView = YES;
            }else if(velocity.x>0){ // 向右滑动
                self.canMoveView = NO;
                if (self.currentCount){
                    
                    // 获取队列中的卡片更新数据
                    [self addSubview:self.queryView];
                    GMCDefaultCardView *defaultView = self.queryView.subviews[0];
                    if ([self.dataSource respondsToSelector:@selector(cardViewDisplayDataForCardViewAtIndex:)]){
                        [defaultView setDisplayData:[self.dataSource cardViewDisplayDataForCardViewAtIndex:(self.currentCount-1)]];
                    }
                    // 设置不在显示范围内的起始位置
                    self.queryViewCenter = CGPointMake(_preferCenter.x-CGRectGetWidth(self.frame)/2-CGRectGetWidth(_queryView.frame)/2-self.frame.origin.x, _preferCenter.y);
                    _queryView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    self.queryView.center = self.queryViewCenter;
                }
            }else{
                self.canMoveView = NO;
                self.ignoreGes = YES;
                return;
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            
            if (self.isIgnoreGes){
                return;
            }
            
            // 计算偏移系数
            if (self.isCanMoveView){
                // 更新当前的中心点
                CGPoint center = self.frontView.center;
                center.x = self.tagetCenter.x + transition.x;
                center.y = self.tagetCenter.y + transition.y;
                self.frontView.center = center;
                
                CGFloat offPercent = (self.frontView.center.x - self.preferCenter.x)/(self.preferCenter.x);
                CGFloat rotation = M_PI_2/10.0*offPercent;
                
                self.frontView.transform = CGAffineTransformMakeRotation(-rotation);
                [self animationBlowViewWithLeftOffPercent:fabs(offPercent)];
            }else{
                if (self.currentCount){ // 向右滑动滑动中
                    
                    // 更新位置
                    CGPoint center = self.queryView.center;
                    center.x = self.queryViewCenter.x + transition.x;
                    center.y = self.queryViewCenter.y + transition.y;
                    self.queryView.center = center;
                    CGFloat total =  self.preferCenter.x-self.queryViewCenter.x;
                    
                    CGFloat offPercent = (self.queryView.center.x-self.queryViewCenter.x - total)/total;
                    CGFloat rotation = M_PI_2/5.0*offPercent;
                    // 设置旋转角度
                    self.queryView.transform = CGAffineTransformMakeRotation(rotation);
                    // 给其余底部视图添加缩放动画
                    [self animationBlowViewRightWithOffPercent:fabs(offPercent)];
                }
            }
        }
            
            break;
            
        case UIGestureRecognizerStateEnded: {
            
            if (self.isIgnoreGes){
                self.ignoreGes = NO;
                return;
            }
            if (self.isCanMoveView){ // 向左滑动
                // 记录当前中心点
                self.tagetCenter = self.frontView.center;
                // 滑动的距离大于100
                if (self.tagetCenter.x<self.preferCenter.x-100.0  || self.tagetCenter.y<self.preferCenter.y-100.0){
                    CGPoint center = self.frontView.center;
                    
                    if (self.tagetCenter.y<self.preferCenter.y-100.0) {
                        center.y = -CGRectGetHeight(self.frontView.frame)/2-CGRectGetHeight(self.frame)/2;
                    }
                    else{
                        // 水平移除屏幕
                        center.x = -CGRectGetWidth(self.frontView.frame)/2-CGRectGetWidth(self.frame)/2;
                    }
                    [UIView animateWithDuration:0.3 animations:^{
                        self.frontView.center = center;
                        // 其余卡片缩放处理
                        for (NSInteger i = 1; i<self.showViewsMulAry.count; i++)
                        {
                            UIView*view = self.showViewsMulAry[i];
                            if (view != self.frontView)
                            {
                                view.center = CGPointMake(_preferCenter.x+ (i-1)*gGlobalviewGaps, _preferCenter.y );
                                view.transform = CGAffineTransformMakeScale(1.0-(i-1)*gGlobalviewScale,1.0-(i-1)*gGlobalviewScale);
                            }
                        }
                    }completion:^(BOOL finished) {
                        
                        // 移除卡片
                        [self.frontView removeFromSuperview];
                        // 数组中移除第一个元素
                        [self.showViewsMulAry removeObjectAtIndex:0];
                        self.queryView.alpha = 0;
                        // 数组添加新元素
                        [self.showViewsMulAry addObject:[self queryView]];
                        [UIView animateWithDuration:0.3 animations:^{
                            self.queryView.alpha = 1;
                        }];
                        
                        // 更换队列中的卡片视图
                        if (self.currentCount + 1 + self.maxCount <= self.showCount) {
                            
                            // 添加新卡片在最后
                            [self addSubview:[self queryView]];
                            [self sendSubviewToBack:[self queryView]];
                            
                            // 更新数据
                            GMCDefaultCardView *defaultView = self.queryView.subviews[0];
                            if ([self.dataSource respondsToSelector:@selector(cardViewDisplayDataForCardViewAtIndex:)]){
                                [defaultView setDisplayData:[self.dataSource cardViewDisplayDataForCardViewAtIndex:(self.currentCount  + self.maxCount )]];
                            }
                        }
                        // 记录队列中的卡片
                        self.queryView = self.frontView;
                        // 重新设置为一个卡片
                        self.frontView = self.showViewsMulAry[0];
                        self.tagetCenter = self.frontView.center;
                        self.currentCount ++;
                        
                        // 调取代理
                        [self cardViewScrollFinish];
                    }];
                }else{
                    
                    // 滑动取消
                    self.frontView.transform = CGAffineTransformMakeRotation(0);
                    CGPoint center = self.frontView.center;
                    center.x = self.preferCenter.x;
                    center.y = self.preferCenter.y;
                    [UIView animateWithDuration:0.3 animations:^{
                        self.frontView.center = center;
                        
                        for (NSInteger i = 1; i<self.showViewsMulAry.count; i++)
                        {
                            UIView*view = self.showViewsMulAry[i];
                            if (view != self.frontView)
                            {
                                view.center = CGPointMake(_preferCenter.x+ i*gGlobalviewGaps, _preferCenter.y );
                                view.transform = CGAffineTransformMakeScale(1.0-i*gGlobalviewScale,1.0-i*gGlobalviewScale);
                            }
                        }
                        
                    } completion:^(BOOL finished) {
                        self.tagetCenter = self.frontView.center;
                    }];
                }
                
            }else{
                // 不可滑动的时候
                if (self.currentCount){
                    if (self.queryView.center.x>=self.preferCenter.x-CGRectGetWidth(self.queryView.frame)*3/4)
                    {
                        [UIView animateWithDuration:0.3 animations:^{
                            // 设置滑动回来的卡片中心点
                            self.queryView.center = self.preferCenter;
                            // 旋转角度清空
                            self.queryView.transform = CGAffineTransformMakeRotation(0);
                            // 设置其他的偏移量
                            [self animationBlowViewRightWithOffPercent:0];
                        } completion:^(BOOL finished) {
                            // 数组添加滑动的卡片
                            [self.showViewsMulAry insertObject:self.queryView atIndex:0];
                            self.frontView = self.queryView;
                            self.queryView = [self.showViewsMulAry lastObject];
                            [self.showViewsMulAry removeObject:self.queryView];
                            [self.queryView removeFromSuperview];
                            self.queryView.alpha = 1;
                            self.currentCount --;
                            
                            // 调用代理
                            [self cardViewScrollFinish];
                        }];
                    }else
                    {
                        // 队列中的还原之前的位置
                        [UIView animateWithDuration:0.1 animations:^{
                            self.queryView.center = CGPointMake(_preferCenter.x-CGRectGetWidth(self.frame)/2-CGRectGetWidth(_queryView.frame)/2, _preferCenter.y);
                        } completion:^(BOOL finished) {
                            [self.queryView removeFromSuperview];
                        }];
                        
                        // 其余的卡片视图
                        for (NSInteger i = 0; i<self.showViewsMulAry.count; i++) {
                            UIView* view = self.showViewsMulAry[i];
                            
                            [UIView animateWithDuration:0.3 animations:^{
                                view.center = CGPointMake(_preferCenter.x+ i*gGlobalviewGaps, _preferCenter.y );
                                view.transform = CGAffineTransformMakeScale(1.0-i*gGlobalviewScale,1.0-i*gGlobalviewScale);
                                if (i == self.showViewsMulAry.count-1) {
                                    view.alpha = 1;
                                }
                            }];
                        }
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
}

// 卡片滑动代理
-(void)cardViewScrollFinish
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(cardViewScrollViewCardAtIndex:)]) {
            [self.delegate cardViewScrollViewCardAtIndex:self.currentCount%self.showCount];
        }
    }
    
}

// 点击卡片
-(void)cardViewTapped:(UITapGestureRecognizer*)sender
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(cardViewClickCardAtIndex:)]) {
            [self.delegate cardViewClickCardAtIndex:self.currentCount%self.showCount];
        }
    }
}

// 获取卡片视图
-(GMCDefaultCardView*)defaultCardViewSubViews
{
    GMCDefaultCardView*defaultView = [[GMCDefaultCardView alloc]init];
    defaultView.frame = CGRectMake(0, 0, self.preferCenter.x*2, self.preferCenter.y*2);
    return defaultView;
}


// 获取卡片视图
-(UIView*)queryView
{
    if (_queryView) {
        if (self.isCanMoveView) {
            
            _queryView.center = CGPointMake(_preferCenter.x+ (self.presentCount-1)*gGlobalviewGaps, _preferCenter.y );
            _queryView.transform = CGAffineTransformMakeScale(1-(self.presentCount-1)*gGlobalviewScale, 1-(self.presentCount-1)*gGlobalviewScale);
            
        }else{
            _queryView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    }
    return _queryView;
}


-(void)addDefaultCardViewInViewWithDefault:(BOOL)isDefault  count:(NSInteger)count
{
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.showViewsMulAry removeAllObjects];
    self.queryView = nil;
    
    // 多添加一个放进队列中
    for (int i = 0; i<count + 1; i++){
        
        UIView *cardBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _preferCenter.x*2, _preferCenter.y*2)];
        cardBackView.center = CGPointMake(_preferCenter.x+ i*gGlobalviewGaps, _preferCenter.y );
        cardBackView.transform = CGAffineTransformMakeScale(1-i*gGlobalviewScale, 1-i*gGlobalviewScale);
        cardBackView.layer.masksToBounds = YES;
        cardBackView.layer.cornerRadius = 20.0;
        
        // 添加滑动手势
        UIPanGestureRecognizer*panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panned:)];
        
        // 添加点击手势
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardViewTapped:)];
        
        if (!isDefault) {
            [cardBackView addGestureRecognizer:tapGesture];
            [cardBackView addGestureRecognizer:panGesture];
        }
        if (i< count) {
            
            GMCDefaultCardView*defaultView = [self defaultCardViewSubViews];
            
            [cardBackView addSubview:defaultView];
            
            // 添加到显示的数组中
            [self.showViewsMulAry addObject:cardBackView];
            [self addSubview:cardBackView];
            [self sendSubviewToBack:cardBackView];
        } else{
            
            GMCDefaultCardView*defaultView = [self defaultCardViewSubViews];
            [cardBackView addSubview:defaultView];
            // 队列中的视图
            self.queryView = cardBackView;
        }
    }
    
    // 设置第一个显示的view
    self.frontView = self.showViewsMulAry[0];
    // 设置第一个center
    self.tagetCenter = self.frontView.center;
}

#pragma mark -------------------初始化-------------------
-(NSMutableArray*)showViewsMulAry
{
    if (!_showViewsMulAry) {
        _showViewsMulAry = [NSMutableArray new];
    }
    return _showViewsMulAry;
}

-(void)reloadCardViewData
{
    
    if ([self.dataSource respondsToSelector:@selector(numberOfCountInCardView)]) {
        // 获取卡片数量
        self.showCount = [self.dataSource numberOfCountInCardView];
    }
    
    // 当前
    self.presentCount  = self.showCount>self.maxCount? self.maxCount:self.showCount;
    
    // 显示的卡片数量 大于最大的6个
    [self addDefaultCardViewInViewWithDefault:NO count:self.presentCount];
    
    // 获取卡片数据
    if ([self.dataSource respondsToSelector:@selector(cardViewDisplayDataForCardViewAtIndex:)]) {
        
        for ( int i=0;i<self.showViewsMulAry.count;i++) {
            
            UIView *view = self.showViewsMulAry[i];
            GMCDefaultCardView *defaultView = view.subviews[0];
            [defaultView setDisplayData:[self.dataSource cardViewDisplayDataForCardViewAtIndex:i]];
            
        }
    }
    
    [self cardViewScrollFinish];
}


//  向右滑动
- (void)animationBlowViewRightWithOffPercent:(CGFloat)offPercent  {
    
    for (NSInteger i = 0; i < self.showViewsMulAry.count; i++) {
        
        // 所有的卡片缩放位置偏移
        GMCDefaultCardView * otherView = self.showViewsMulAry[i];
        
        CGPoint point = CGPointMake((self.preferCenter.x+ i*gGlobalviewGaps)+(1-offPercent)*gGlobalviewGaps,self.preferCenter.y);
        otherView.center = point;
        // 缩放大小
        CGFloat scale = 1 - gGlobalviewScale *(i+1) +offPercent * gGlobalviewScale;
        otherView.transform = CGAffineTransformMakeScale(scale,scale);
    }
}


// 向左滑动
- (void)animationBlowViewWithLeftOffPercent:(CGFloat)offPercent {
    
    for (NSInteger i = 1; i < self.showViewsMulAry.count; i++) {
        
        // 从第二个开始偏移
        GMCDefaultCardView * otherView = self.showViewsMulAry[i];
        CGPoint point = CGPointMake((self.preferCenter.x + gGlobalviewGaps*i)-offPercent * gGlobalviewGaps,self.preferCenter.y);
        // 修改中心点
        otherView.center = point;
        // 缩放大小
        CGFloat scale = 1 - gGlobalviewScale *i+offPercent * gGlobalviewScale;
        
        otherView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

@end
