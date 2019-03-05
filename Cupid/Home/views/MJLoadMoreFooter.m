//
//  MJLoadMoreFooter.m
//  Cupid
//
//  Created by panzhijun on 2019/1/17.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "MJLoadMoreFooter.h"

@interface MJLoadMoreFooter()
@property(nonatomic,strong) UILabel *lableShow;
@property(nonatomic,strong) UIView *drawView;
@property(nonatomic,strong) UIView *viewOne;
@property(nonatomic,strong) UIView *viewTwo;
@property(nonatomic,strong) UIView *viewThree;

@property(nonatomic,strong) CAShapeLayer *shapeLayerOne;
@property(nonatomic,strong) CAShapeLayer *shapeLayerTwo;
@property(nonatomic,strong) CAShapeLayer *shapeLayerThree;

@property(nonatomic,strong) UIView *myView;
@end

@implementation MJLoadMoreFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 50;
    

    // 动画的View
    [self addSubview:self.drawView];
    self.drawView.backgroundColor = [UIColor clearColor];
    
    // 小圆点
    [self.drawView addSubview:self.viewOne];

    [self.drawView addSubview:self.viewTwo];
    [self.drawView addSubview:self.viewThree];
    
    self.drawView.frame=CGRectMake(0, 0, SCREEN_W, 50);
    
    self.viewOne.frame=CGRectMake((SCREEN_W-10)/2-25, 20, 10, 10);
    
    self.viewTwo.frame=CGRectMake((SCREEN_W-10)/2 ,20, 10, 10);
    
    self.viewThree.frame=CGRectMake((SCREEN_W-10)/2+25,20,10,10);
    
    
    
    _myView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_W-50)/2, 0, 50, 50)];
    _myView.backgroundColor = RGBAllColor(0xDCDCDC);
    
    [self.myView addSubview:self.lableShow];
    _myView.layer.cornerRadius = 25;
    
    self.drawView.layer.masksToBounds = YES;
    
 
    
    [self initAllView];
    
    
}

-(void)initAllView{
    

    // 里面的小方块
    UIBezierPath *path1 = [UIBezierPath  bezierPathWithOvalInRect:CGRectMake(0, 0, 10, 10)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.borderWidth = 0.5; // 线宽
    layer.strokeColor = RGBAllColor(0x708090).CGColor; // 线的颜色
    layer.fillColor = [UIColor lightGrayColor].CGColor;
    layer.strokeStart = 0;
    layer.strokeEnd = 0;
    self.shapeLayerOne=layer;
    layer.path = path1.CGPath;
    [self.viewOne.layer addSublayer:layer];
    
    // 里面的小方块
    UIBezierPath *path2 = [UIBezierPath  bezierPathWithOvalInRect:CGRectMake(0, 0, 10, 10)];
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.borderWidth = 0.5; // 线宽
    layer2.strokeColor = RGBAllColor(0x708090).CGColor; // 线的颜色
    layer2.fillColor = [UIColor lightGrayColor].CGColor;
    layer2.strokeStart = 0;
    layer2.strokeEnd = 0;
    self.shapeLayerTwo=layer2;
    layer2.path = path2.CGPath;
    [self.viewTwo.layer addSublayer:layer2];
    
    // 里面的小方块
    UIBezierPath *path3 = [UIBezierPath  bezierPathWithOvalInRect:CGRectMake(0, 0, 10, 10)];
    CAShapeLayer *layer3 = [CAShapeLayer layer];
    layer3.borderWidth = 0.5; // 线宽
    layer3.strokeColor = RGBAllColor(0x708090).CGColor; // 线的颜色
    layer3.fillColor = [UIColor lightGrayColor].CGColor;
    layer3.strokeStart = 0;
    layer3.strokeEnd = 0;
    self.shapeLayerThree=layer3;
    layer3.path = path3.CGPath;
    [self.viewThree.layer addSublayer:layer3];
    
    

    
    
}

// 推荐中的动画
-(void)loadAnimation{
    
    [self stopAnimation];
    

    [self.drawView addSubview:_myView];
    [self.drawView addSubview:self.lableShow];
    CABasicAnimation *animation=[CABasicAnimation animation];
    animation.fromValue=[NSNumber numberWithFloat:0.1];
    animation.toValue=[NSNumber numberWithFloat:20.0];
    animation.duration=2;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [self.myView.layer addAnimation:animation forKey:@"transform.scale"];
    
    
    
//
//    CABasicAnimation *animation1=[CABasicAnimation animation];
//    animation1.fromValue=[NSNumber numberWithFloat:1];
//    animation1.toValue=[NSNumber numberWithFloat:2.0];
//    animation1.duration=0.3;
//    animation1.repeatCount = 1;
//    animation1.removedOnCompletion=NO;
//    animation1.fillMode=kCAFillModeForwards;
//    [self.viewTwo.layer addAnimation:animation1 forKey:@"transform.scale"];
    
    
}

-(void)stopAnimation{


    
    self.shapeLayerOne.position = CGPointMake( 0, 0);
    self.shapeLayerThree.position = CGPointMake(0, 0);
    
//    [self.shapeLayerOne removeFromSuperlayer];
//    [self.shapeLayerThree removeFromSuperlayer];
    
    [self.myView.layer removeAllAnimations];
    [self.myView removeFromSuperview];
    [self.lableShow removeFromSuperview];
    
}



#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.lableShow.frame=CGRectMake((SCREEN_W-100)/2, 25/2, 100, 25);
}

-(UILabel *)lableShow{
    if(!_lableShow){
        _lableShow=[UILabel new];
        _lableShow.font=[UIFont systemFontOfSize:14];
        _lableShow.backgroundColor = [UIColor clearColor];
        _lableShow.textColor=[UIColor whiteColor];
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
            break;
        case MJRefreshStatePulling:
            [self feedback];
            [self stopAnimation];
            break;
        case MJRefreshStateRefreshing:
            [self loadAnimation];
            self.lableShow.text=@"正在加载中...";
            
            break;
        default:
            break;
    }
}

-(void)feedback
{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 10.0) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }
    
}
#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
   CGFloat mm= self.scrollView.contentSize.height - h;
    CGPoint newPoint;
    id newValue = [ change valueForKey:NSKeyValueChangeNewKey ];
    [(NSValue*)newValue getValue:&newPoint ];
    
    
    double point=fabs(newPoint.y);

//        MYLog(@"%f   %f     %f===    %f",self.shapeLayerOne.position.x,self.shapeLayerThree.position.x,point,mm);
//
    if (point >= mm) {
         double point2 = point-mm>=50?50:point-mm;
        self.shapeLayerOne.position = CGPointMake( point2/2, 0);
        self.shapeLayerThree.position = CGPointMake(-point2/2, 0);
    }
    if (mm<=0) {
        double point2 = point>=50?50:point;
        self.shapeLayerOne.position = CGPointMake( point2/2, 0);
        self.shapeLayerThree.position = CGPointMake(-point2/2, 0);
        
    }

    
   
    
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
//     MYLog(@"=====%f   %f",self.shapeLayerOne.position.x,self.shapeLayerThree.position.x);
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

-(UIView *)viewOne{
    if(!_viewOne){
        _viewOne=[UIView new];
        _viewOne.backgroundColor=[UIColor clearColor];
        
    }
    return _viewOne;
}

-(UIView *)viewTwo{
    if(!_viewTwo){
        _viewTwo=[UIView new];
        
        _viewTwo.backgroundColor=[UIColor clearColor];
        
    }
    return _viewTwo;
}

-(UIView *)viewThree{
    if(!_viewThree){
        _viewThree=[UIView new];
        _viewThree.backgroundColor=[UIColor clearColor];
        
    }
    return _viewThree;
}


@end
