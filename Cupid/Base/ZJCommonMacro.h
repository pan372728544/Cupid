//
//  ZJCommonMacro.h
//  Cupid
//
//  Created by panzhijun on 2019/1/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

#ifndef ZJCommonMacro_h
#define ZJCommonMacro_h



// tabbar安全区域底部高度
#define TABBAE_BOTTOM (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) ? [UIApplication sharedApplication].keyWindow.rootViewController.view.safeAreaInsets.bottom : 0)

// 状态栏高度
#define STATUSBAR_H ([UIApplication sharedApplication].statusBarFrame.size.height)

// 屏幕宽度和高度
#define SCREEN_W   [UIScreen mainScreen].bounds.size.width
#define SCREEN_H   [UIScreen mainScreen].bounds.size.height


// tabbar高度
#define TABBAR_H    (49)

// 导航高度
#define NAVBAR_H (50)

#define  NAV_Btn_Font [UIFont systemFontOfSize:14]

// X以后高度
#define NAVBAR_IPHONEX_H (NAVBAR_H + STATUSBAR_H)

// X以后高度
#define TABBAR_IPHONEX_H (TABBAR_H + TABBAE_BOTTOM)


/// 通过RGBA设置颜色，使用0x格式，如：RGBAAllColor(0xAABBCC, 0.5);
#define RGBAAllColor(rgb, a) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0  \
green:((float)((rgb & 0xFF00) >> 8))/255.0     \
blue:((float)(rgb & 0xFF))/255.0              \
alpha:(a)/1.0]

/// 通过RGB设置颜色，使用0x格式，如：RGBAAllColor(0xAABBCC);
#define RGBAllColor(rgb) RGBAAllColor(rgb, 1.0)

/// 通过RGBA设置颜色，支持10位和16位，使用16位时每个色值前加0x，系统会默认16进制
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0  \
green:(g)/255.0  \
blue:(b)/255.0  \
alpha:(a)/1.0]

/// 通过RGB设置颜色，支持10位和16位，使用16位时每个色值前加0x，系统会默认16进制
#define RGBColor(r, g, b) RGBAColor(r, g, b, 1.0)

/// 随机颜色 用于区分不同的布局
#define Randon_Color [UIColor colorWithRed:(random() % 256) / 255.0  \
green:(random() % 256) / 255.0  \
blue:(random() % 256) / 255.0  \
alpha:1.0]


#define COLOR_COMMONRED RGBAllColor(0xDE4A43)


#define WEAKSELF typeof(self) __weak weakSelf = self;


#define NavBar_Btn_H (44)       /// 左右Button的高度
#define NavBar_Btn_W (80)       /// 左右各有一个Button的宽度
#define  NavBar_BtnTitle_Color  RGBAllColor(0xD2D2D2) /// NavBar按钮文字颜色


#define SearchBar_H (38)       /// 左右Button的高度

#endif /* ZJCommonMacro_h */
