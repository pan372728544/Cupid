//
//  MJDrawAnimationHeader.m
//  Cupid
//
//  Created by panzhijun on 2019/1/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "MJDrawAnimationHeader.h"
#import "ZJCommonMacro.h"


@interface MJDrawAnimationHeader ()

@property(nonatomic,strong) UILabel *lableShow;
@property(nonatomic,strong) UIView *drawView;
@property(nonatomic,strong) UIView *smallRectView;
@property(nonatomic,strong) UIView *shortLineView;
@property(nonatomic,strong) UIView *longLineView;

@property(nonatomic,strong) CAShapeLayer *shapeBoardLayer;
@property(nonatomic,strong) CAShapeLayer *shapeSmallLayer;
@property(nonatomic,strong) CAShapeLayer *shapeLongLayer;


@end

@implementation MJDrawAnimationHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 50;
    
    // 显示的lable
    [self addSubview:self.lableShow];
    
    // 动画的View
    [self addSubview:self.drawView];
    
    // 左侧小方块
    [self.drawView addSubview:self.smallRectView];
    
    // 右侧短线
    [self.drawView addSubview:self.shortLineView];
    
    // 下方长线
    [self.drawView addSubview:self.longLineView];
    
    self.drawView.frame=CGRectMake((SCREEN_W-25)/2, 3, 25, 25);
    
    self.smallRectView.frame=CGRectMake(3, 3, 8, 8);
    
    self.shortLineView.frame=CGRectMake(12, 3, 8, 8);
    
    self.longLineView.frame=CGRectMake(3, 12, 20, 12);
    

    [self initAllView];
    
    
}

-(void)initAllView{
    
    
    // 矩形视图
    CAShapeLayer *layerA=[CAShapeLayer layer];
    layerA.borderWidth = 1; // 线宽
    layerA.strokeColor = [UIColor lightGrayColor].CGColor;
    layerA.fillColor = [UIColor clearColor].CGColor;
    layerA.strokeStart = 0; // 起始位置
    layerA.strokeEnd = 0;
    self.shapeBoardLayer=layerA;
    // 路径 矩形
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.drawView.bounds cornerRadius:4];
    layerA.path = path.CGPath;
    [self.drawView.layer addSublayer:layerA];
    
    // 里面的小方块
    UIBezierPath *smallpath = [UIBezierPath bezierPathWithRoundedRect:self.smallRectView.bounds cornerRadius:1];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.borderWidth = 0.5; // 线宽
    layer.strokeColor = RGBAllColor(0x708090).CGColor; // 线的颜色
    layer.fillColor = [UIColor lightGrayColor].CGColor;
    layer.strokeStart = 0;
    layer.strokeEnd = 0;
    self.shapeSmallLayer=layer;
    layer.path = smallpath.CGPath;
    [self.smallRectView.layer addSublayer:layer];
    
    
    // 三条短线 没有动画的
    UIBezierPath *shortpath = [UIBezierPath bezierPath];
    [shortpath moveToPoint:CGPointMake(2, 1)];
    [shortpath addLineToPoint:CGPointMake(10, 1)];
    
    [shortpath moveToPoint:CGPointMake(2, 4)];
    [shortpath addLineToPoint:CGPointMake(10, 4)];
    
    [shortpath moveToPoint:CGPointMake(2, 7)];
    [shortpath addLineToPoint:CGPointMake(10, 7)];

    CAShapeLayer *shortLineLayer = [CAShapeLayer layer];
    shortLineLayer.borderWidth=0.5;
    shortLineLayer.strokeColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor;
    shortLineLayer.path=shortpath.CGPath;
    
    [self.shortLineView.layer addSublayer:shortLineLayer];
    
    // 三条长线
    UIBezierPath *longpath = [UIBezierPath bezierPath];
    [longpath moveToPoint:CGPointMake(0, 3)];
    [longpath addLineToPoint:CGPointMake(19, 3)];
    
    [longpath moveToPoint:CGPointMake(0, 6)];
    [longpath addLineToPoint:CGPointMake(19, 6)];
    
    [longpath moveToPoint:CGPointMake(0, 9)];
    [longpath addLineToPoint:CGPointMake(19, 9)];
    
    CAShapeLayer *longLineLayer = [CAShapeLayer layer];
    longLineLayer.strokeStart = 0;
    longLineLayer.strokeEnd = 0;
    longLineLayer.borderWidth= 0.5;
    longLineLayer.strokeColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor;
    longLineLayer.path=longpath.CGPath;
    self.shapeLongLayer=longLineLayer;
    [self.longLineView.layer addSublayer:longLineLayer];
    
    
    
}

// 推荐中的动画
-(void)loadAnimation{
    
    [self stopAnimation];
    
    CAKeyframeAnimation *smallanimation = [CAKeyframeAnimation animation];
    smallanimation.keyPath = @"position";
    // 创建path路径
    UIBezierPath *smallrectpath = [UIBezierPath bezierPath];
    [smallrectpath moveToPoint:CGPointMake(3+4, 3+4)];
    [smallrectpath addLineToPoint:CGPointMake(13+4, 3+4)];
    [smallrectpath addLineToPoint:CGPointMake(13+4, 13+4)];
    [smallrectpath addLineToPoint:CGPointMake(3+4, 13+4)];
    [smallrectpath addLineToPoint:CGPointMake(3+4, 3+4)];
    
    smallanimation.path=smallrectpath.CGPath;
    smallanimation.repeatCount = MAXFLOAT;
    smallanimation.calculationMode=kCAAnimationDiscrete;
    smallanimation.fillMode = kCAFillModeForwards;
    smallanimation.duration = 2.0f;
    [self.smallRectView.layer addAnimation:smallanimation forKey:@"rectrun"];
    
    
    
    CAKeyframeAnimation *shortanimation = [CAKeyframeAnimation animation];
    shortanimation.keyPath = @"position";
    // 创建path路径
    UIBezierPath *shortpath = [UIBezierPath bezierPath];
    [shortpath moveToPoint:CGPointMake(12+4, 3+4)];
    [shortpath addLineToPoint:CGPointMake(1+4, 3+4)];
    [shortpath addLineToPoint:CGPointMake(1+4, 13+4)];
    [shortpath addLineToPoint:CGPointMake(13+4, 13+4)];
    [shortpath addLineToPoint:CGPointMake(12+4, 3+4)];
    
    shortanimation.path=shortpath.CGPath;
    
    shortanimation.repeatCount = MAXFLOAT;
    
    shortanimation.calculationMode=kCAAnimationDiscrete;
    
    
    shortanimation.fillMode = kCAFillModeForwards;
    
    shortanimation.duration = 2.0f;
    
    
    [self.shortLineView.layer addAnimation:shortanimation forKey:@"rectrun"];
    
    
    
    CAKeyframeAnimation *longanimation = [CAKeyframeAnimation animation];
    longanimation.keyPath = @"position";
    // 创建path路径
    UIBezierPath *longpath = [UIBezierPath bezierPath];
    [longpath moveToPoint:CGPointMake(3+10, 12+6)];
    [longpath addLineToPoint:CGPointMake(3+10, 6)];
    [longpath addLineToPoint:CGPointMake(3+10, 12+6)];
    
    
    longanimation.path=longpath.CGPath;
    
    longanimation.repeatCount = MAXFLOAT;
    
    longanimation.calculationMode=kCAAnimationDiscrete;
    longanimation.fillMode = kCAFillModeForwards;
    
    longanimation.duration = 2.0f;
    
    [self.longLineView.layer addAnimation:longanimation forKey:@"rectrun"];
    
}

-(void)stopAnimation{
    [self.smallRectView.layer removeAllAnimations];
    [self.shortLineView.layer removeAllAnimations];
    [self.longLineView.layer removeAllAnimations];
    
}



#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.lableShow.frame=CGRectMake((SCREEN_W-60)/2, 25, 60, 25);
}

-(UILabel *)lableShow{
    if(!_lableShow){
        _lableShow=[UILabel new];
        _lableShow.font=[UIFont systemFontOfSize:10];
        _lableShow.text=@"下拉推荐";
        _lableShow.backgroundColor = [UIColor clearColor];
        _lableShow.textColor=[UIColor colorWithRed:0.49 green:0.49 blue:0.5 alpha:1];
        _lableShow.textAlignment=NSTextAlignmentCenter;
    }
    return _lableShow;
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self stopAnimation];
            self.lableShow.text=@"下拉推荐";
            break;
        case MJRefreshStatePulling:
            self.lableShow.text=@"松开推荐";
            [self stopAnimation];
            break;
        case MJRefreshStateRefreshing:
            [self loadAnimation];
            self.lableShow.text=@"推荐中";
            
            break;
        default:
            break;
    }
}
#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    
    
    CGPoint newPoint;
    id newValue = [ change valueForKey:NSKeyValueChangeNewKey ];
    [(NSValue*)newValue getValue:&newPoint ];
    
    double point=fabs(newPoint.y);

    // 更新动画
    self.shapeBoardLayer.strokeEnd = point/50;
    self.shapeSmallLayer.strokeEnd = point/50;
    self.shapeLongLayer.strokeEnd  = point/50;
    
    
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{

    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}


-(UIView *)drawView
{
    if(!_drawView){
        _drawView=[UIView new];
        _drawView.backgroundColor=[UIColor clearColor];
    }
    return _drawView;
}

-(UIView *)smallRectView{
    if(!_smallRectView){
        _smallRectView=[UIView new];
        _smallRectView.backgroundColor=[UIColor clearColor];
        
    }
    return _smallRectView;
}

-(UIView *)shortLineView{
    if(!_shortLineView){
        _shortLineView=[UIView new];
        // _shortLineView.hidden=YES;
        
        _shortLineView.backgroundColor=[UIColor clearColor];
        
    }
    return _shortLineView;
}

-(UIView *)longLineView{
    if(!_longLineView){
        _longLineView=[UIView new];
        //_longLineView.hidden=YES;
        _longLineView.backgroundColor=[UIColor clearColor];
        
    }
    return _longLineView;
}


@end
