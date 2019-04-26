//
//  UIColor-Extension.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//


import UIKit

extension UIColor {
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    // 随机色
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    // 标准红
    class func commonColor() -> UIColor {
        return UIColor(r: CGFloat(211), g: CGFloat(61), b: CGFloat(61))
    }
    
    // 聊天背景颜色
    class func tableViewBackGroundColor() -> UIColor {
        return UIColor(r: CGFloat(236), g: CGFloat(236), b: CGFloat(236))
    }
    
    // 输入框颜色
    class func inputViewColor() -> UIColor {
        return UIColor(r: CGFloat(245), g: CGFloat(245), b: CGFloat(245))
    }
    
    // 昵称颜色
    class func textNameColor() -> UIColor {
        return UIColor(r: CGFloat(120), g: CGFloat(120), b: CGFloat(120))
    }
}

