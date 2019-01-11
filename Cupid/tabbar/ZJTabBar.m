//
//  ZJTabBar.m
//  Cupid
//
//  Created by panzhijun on 2019/1/8.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJTabBar.h"
#import "ZJCommonMacro.h"



@interface ZJTabBar ()<ZJTabBarItemDelegate>

// 毛玻璃效果
@property (nonatomic, strong) UIVisualEffectView *effectView;
// 分割线
@property (nonatomic, strong) UIView *topLine;

@end


@implementation ZJTabBar

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
// 顶部分割线
- (UIView *)topLine
{
    if (_topLine == nil)
    {
        _topLine = [[UIView alloc]init];
        [self addSubview:_topLine];
    }
    return _topLine;
}

// 毛玻璃视图
- (UIVisualEffectView *)effectView
{
    if (_effectView == nil)
    {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 1.0;
//        [self addSubview:_effectView];
    }
    return _effectView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.effectView.frame = self.bounds;
    
    CGFloat fltScale = [UIScreen mainScreen].scale;
    CGFloat lineH = 1/fltScale;
    self.topLine.frame = CGRectMake(0, 0, SCREEN_W, lineH);
    self.topLine.backgroundColor =  RGBAllColor(0xE4E4E4);
    // 设置itme
    [self setupItems];
}

- (void)setupItems
{
    // 加上中间的宽度
    CGFloat width = SCREEN_W/(self.items.count);
    
    
    for (int i = 0; i < self.items.count; i++)
    {
        ZJTabBarItem *item = [self.items objectAtIndex:i];
        
        // 大于中间的时候 位置进行调整
//        if (i>= 2)
//        {
//            item.frame = CGRectMake((i+1)*width, 2, width, TABBAR_H);
//        }
//        else
        {
            item.frame = CGRectMake(i*width, 2, width, TABBAR_H);
        }
//        item.backgroundColor = [UIColor blueColor];
        [self addSubview:item];
        item.delegate = self;
    }
    
//    // 添加中间的item
//    ZJTabBarItem *item = [[ZJTabBarItem alloc]init];;
//    item.icon = @"pgc_tabbar_icon_more_night_24x24_";
//    item.title = @"发头条";
//    item.tag = 2001;
//    item.delegate = self;
//    item.frame = CGRectMake((SCREEN_W-width)*0.5,2,width,TABBAR_H);
//
//    [self addSubview:item];
}

- (void)tabBarItem:(ZJTabBarItem *)item didSelectIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItem:atIndex:)]) {
        
        [self.delegate tabBar:self didSelectItem:item atIndex:index];
    }
}

@end


// *****************************************************
#pragma mark - ZJTabBarItem

static NSInteger defaultTag = 100000;

@interface ZJTabBarItem ()

// 图片
@property (nonatomic, strong)UIImageView *iconImageView;
// 标题
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation ZJTabBarItem


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        // 点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClicked:)];
        [self addGestureRecognizer:tap];
        
//        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag + defaultTag];
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil)
    {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _iconImageView.backgroundColor = [UIColor blueColor];
        self.iconImageView= _iconImageView;
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor grayColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setIcon:(NSString *)icon
{
    _icon = icon;
    self.iconImageView.image = [UIImage imageNamed:icon];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat space = 6.0;
    switch (self.type)
    {
        case ZJTabBarItemTypeDefault:
        {
            CGFloat iconHeight = 32;
            self.iconImageView.frame = CGRectMake(space, 0, CGRectGetWidth(self.frame) - 2 * space, iconHeight);
            self.titleLabel.frame = CGRectMake(space, CGRectGetMaxY(self.iconImageView.frame) , CGRectGetWidth(self.frame) - 2*space, iconHeight/2.0);

        }
            break;
        case ZJTabBarItemTypeImage:
        {
            
            self.iconImageView.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2*space, CGRectGetHeight(self.frame) - 2*space);
        }
            break;
        case ZJTabBarItemTypeText:
        {
            
            self.titleLabel.frame = CGRectMake(space, space, CGRectGetWidth(self.frame) - 2*space, CGRectGetHeight(self.frame) - 2*space);
        }
            break;
            
        default:
            break;
    }
    
}

- (void)itemClicked:(UITapGestureRecognizer *)tap
{
    // item 点击
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarItem:didSelectIndex:)])
    {
        [self.delegate tabBarItem:self didSelectIndex:self.tag - defaultTag];
    }
}

@end
