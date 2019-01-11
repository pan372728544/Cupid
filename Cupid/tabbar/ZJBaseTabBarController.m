//
//  ZJBaseTabBarController.m
//  Cupid
//
//  Created by panzhijun on 2019/1/3.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#import "ZJBaseTabBarController.h"
#import "ZJBaseNavigationController.h"
#import "ZJCommonMacro.h"
#import "ZJTabBar.h"
#import "TabBarPublishView.h"


@interface ZJBaseTabBarController ()<ZJTabBarDelegate>

@property (nonatomic, strong) ZJTabBar *customTabBar;
@property (nonatomic, strong) ZJTabBarConfig *config;

@property(nonatomic,strong) TabBarPublishView *viewPub;

@end

@implementation ZJBaseTabBarController

// TabBar 创建
- (ZJTabBar *)customTabBar {
    
    if (_customTabBar == nil) {
        _customTabBar = [[ZJTabBar alloc]init];
        _customTabBar.delegate = self;
    }
    
    return _customTabBar;
}

+ (instancetype)createTabBarController:(tabBarBlock)block {
    static dispatch_once_t onceToken;
    static ZJBaseTabBarController *tabBar;
    dispatch_once(&onceToken, ^{
        
        tabBar = [[ZJBaseTabBarController alloc]initWithBlock:block];
    });
    
    return tabBar;
}

+ (instancetype)defaultTabBarController {
    
    return [ZJBaseTabBarController createTabBarController:nil];
}

// 隐藏tabbar
- (void)hiddenTabBarWithAnimation:(BOOL)isAnimation {
    
    if (isAnimation)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.customTabBar.alpha = 0;
        }];
    } else {
        
        self.customTabBar.alpha = 0;
    }
}

// 显示tabbar
- (void)showTabBarWithAnimation:(BOOL)isAnimation {
    
    if (isAnimation) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.customTabBar.alpha = 1.0;
        }];
    } else {
        
        self.customTabBar.alpha = 1.0;
    }
}

- (instancetype)initWithBlock:(tabBarBlock)block {
    
    self = [super init];
    if (self) {
        
        ZJTabBarConfig *config = [[ZJTabBarConfig alloc]init];
        
        NSAssert(block, @"Param 'block' in zhe function, can not be nil");
        if (block) {
            
            _config = block(config);
        }
        
        NSAssert(_config.viewControllers, @"Param 'viewControllers' in the 'config', can not be nil");
        [self setupViewControllers];
        [self setupTabBar];
        
        _isAutoRotation = YES;
    }
    
    return self;
}

- (void)setupViewControllers {
    
    // 设置tabbar vcs
    if (_config.isNavigation) {
        
        NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:_config.viewControllers.count];
        for (UIViewController *vc in _config.viewControllers) {
            if (![vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [vcs addObject:nav];
            } else {
                [vcs addObject:vc];
            }
        }
        
        self.viewControllers = [vcs copy];
    } else {
        
        self.viewControllers = [_config.viewControllers copy];
    }
}

// 设置tabbar 标题 图片
- (void)setupTabBar {
    
    NSMutableArray *items = [NSMutableArray array];
    
    ZJTabBarItemType type;
    // 图片 标题都是值
    if ((_config.selectedImages.count > 0 || _config.normalImages.count > 0) && _config.titles.count > 0)
    {
        type = ZJTabBarItemTypeDefault; // 默认模式
    }
    // 只有图片
    else if ((_config.selectedImages.count > 0 || _config.normalImages.count > 0) && _config.titles.count <= 0)
    {
        type = ZJTabBarItemTypeImage; // 图片模式
    }
    // 只有标题
    else if ((_config.selectedImages.count <= 0 && _config.normalImages.count <= 0) && _config.titles.count > 0)
    {
        type = ZJTabBarItemTypeText; // 文本模式
    }
    else
    {
        type = ZJTabBarItemTypeDefault;
    }
    
    for (int i = 0; i < _config.viewControllers.count + 1; i++)
    {
        // 创建tabbar Item
        ZJTabBarItem *item = [[ZJTabBarItem alloc]init];
        item.type = type;
        if (i == 0)
        {
            // 默认第一个被选中
            item.icon = _config.selectedImages[i];
            if (_config.titles.count > 0)
            {
                item.titleColor = _config.selectedColor;
            }
        }
        else
        {
            // 中间的item
            if (i == 2) {
                item.icon = @"pgc_tabbar_icon_more_night_24x24_";
            }
            else if(i > 2)
            {
                item.icon = _config.normalImages[i-1];
                if (_config.titles.count > 0)
                {
                    item.titleColor = _config.normalColor;
                }
            }
            else
            {
                item.icon = _config.normalImages[i];
                if (_config.titles.count > 0)
                {
                    item.titleColor = _config.normalColor;
                }
            }
        }
        
        if (i <= _config.titles.count)
        {
            // 中间的item
            if (i == 2) {
                item.title = @"发头条";
            }
            else if(i > 2)
            {
                item.title = _config.titles[i-1];
            }
            else
            {
            item.title = _config.titles[i];
            }
        }
        [items addObject:item];
        item.tag = i;
    }

    // 添加自定义tabbar
    self.tabBar.hidden = YES;
    self.customTabBar.items = [items copy];
    self.customTabBar.frame = CGRectMake(0, SCREEN_H - TABBAR_IPHONEX_H, SCREEN_W, TABBAR_IPHONEX_H);
    [self.view addSubview:self.customTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedIndex = 0;
}

#pragma mark - ZJTabBarDelegate
- (void)tabBar:(ZJTabBar *)tab didSelectItem:(ZJTabBarItem *)item atIndex:(NSInteger)index
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    for (UIView *view in tab.subviews)
    {
        if ([view isKindOfClass:[ZJTabBarItem class]])
        {
            [items addObject:view];
        }
    }
    
    
    for (int i = 0; i < items.count; i++)
    {
        UIView *view = items[i];
        if ([view isKindOfClass:[ZJTabBarItem class]]) {
            ZJTabBarItem *item = (ZJTabBarItem *)view;
            if (i < 2) {
                item.icon = self.config.normalImages[i];
                if (self.config.titles.count > 0) {
                    item.titleColor = _config.normalColor;
                }
            }
            else if(i>2)
            {
                // 大于2的情况
                item.icon = self.config.normalImages[i-1];
                if (self.config.titles.count > 0) {
                    item.titleColor = _config.normalColor;
                }
            }
        }
    }
    
    
    if (index < 2)
    {
        item.icon = self.config.selectedImages[index];
        if (self.config.titles.count > 0)
        {
            item.titleColor = self.config.selectedColor;
        }
    }

    else if(index > 2)
    {
        item.icon = self.config.selectedImages[index-1];
        if (self.config.titles.count > 0)
        {
            item.titleColor = self.config.selectedColor;
        }
    }
    
    if (index != 2) {
        // 设置被选中的tabbaritem
        self.selectedIndex = index;
    }
    else
    {
        
        NSLog(@"中间被点击了");
        
        self.viewPub =[[TabBarPublishView alloc]initWithFrame:CGRectMake(0, SCREEN_H-100, SCREEN_W, 100)];
        
        [self.view addSubview:self.viewPub];
    }

}

// 屏幕旋转时调整tabbar
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.customTabBar.frame = CGRectMake(0, size.height - TABBAR_IPHONEX_H, size.width, TABBAR_IPHONEX_H);
}

- (BOOL)shouldAutorotate {
    
    return self.isAutoRotation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.isAutoRotation) {
        
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        
        return UIInterfaceOrientationMaskPortrait;
    }
}


@end


@implementation ZJTabBarConfig

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _isNavigation = YES;
        _normalColor =[UIColor lightGrayColor];
        _selectedColor = [UIColor colorWithRed:233/255.0 green:34/255.0 blue:12/255.0 alpha:1];
    }
    return self;
}
@end


