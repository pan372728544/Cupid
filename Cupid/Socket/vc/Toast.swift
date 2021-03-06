//
//  Toast.swift
//  Cupid
//
//  Created by panzhijun on 2019/5/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

///Toast默认停留时间
let toastDispalyDuration: CGFloat = 2.0
///Toast背景颜色
let toastBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)

class Toast: NSObject {
    
    var contentView: UIButton
    var duration: CGFloat = toastDispalyDuration
    
    init(text: String) {
        let rect = text.boundingRect(with: CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude), options:[NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.size.width + 40, height: rect.size.height + 20))
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.text = text
        textLabel.numberOfLines = 0
        
        contentView = UIButton(frame: CGRect(x: 0, y: 0, width: textLabel.frame.size.width, height: textLabel.frame.size.height))
        contentView.layer.cornerRadius = 2.0
        contentView.backgroundColor = toastBackgroundColor
        contentView.addSubview(textLabel)
        contentView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        super.init()
        contentView.addTarget(self, action: #selector(toastTaped), for: .touchDown)
        ///添加通知获取手机旋转状态.保证正确的显示效果
        NotificationCenter.default.addObserver(self, selector: #selector(toastTaped), name: UIDevice.orientationDidChangeNotification, object: UIDevice.current)
    }
    @objc func toastTaped() {
        self.hideAnimation()
    }
    func deviceOrientationDidChanged(notify: Notification) {
        self.hideAnimation()
    }
    @objc func dismissToast() {
        contentView.removeFromSuperview()
    }
    func setDuration(duration: CGFloat) {
        self.duration = duration
    }
    func showAnimation() {
        UIView.beginAnimations("show", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        UIView.setAnimationDuration(0.3)
        contentView.alpha = 1.0
        UIView.commitAnimations()
    }
    @objc func hideAnimation() {
        UIView.beginAnimations("hide", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(dismissToast))
        UIView.setAnimationDuration(0.3)
        contentView.alpha = 0.0
        UIView.commitAnimations()
    }
    
    func show() {
        let window: UIWindow = UIApplication.shared.windows.last!
        contentView.center = window.center
        window.addSubview(contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
    }
    func showFromTopOffset(top: CGFloat) {
        let window: UIWindow = UIApplication.shared.windows.last!
        contentView.center = CGPoint(x: window.center.x, y: top + contentView.frame.size.height/2)
        window.addSubview(contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
    }
    func showFromBottomOffset(bottom: CGFloat) {
        let window: UIWindow = UIApplication.shared.windows.last!
        contentView.center = CGPoint(x: window.center.x, y: window.frame.size.height - (bottom + contentView.frame.size.height/2))
        window.addSubview(contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(duration))
    }
    // MARK: 中间显示
    class func showCenterWithText(text: String) {
        Toast.showCenterWithText(text: text, duration: CGFloat(toastDispalyDuration))
    }
    class func showCenterWithText(text: String, duration: CGFloat) {
        let toast: Toast = Toast(text: text)
        toast.setDuration(duration: duration)
        toast.show()
    }
    // MARK: 上方显示
    class func showTopWithText(text: String) {
        Toast.showTopWithText(text: text, topOffset: 100.0, duration: toastDispalyDuration)
    }
    class func showTopWithText(text: String, duration: CGFloat) {
        Toast.showTopWithText(text: text, topOffset: 100, duration: duration)
    }
    class func showTopWithText(text: String, topOffset: CGFloat) {
        Toast.showTopWithText(text: text, topOffset: topOffset, duration: toastDispalyDuration)
    }
    class func showTopWithText(text: String, topOffset: CGFloat, duration: CGFloat) {
        let toast = Toast(text: text)
        toast.setDuration(duration: duration)
        toast.showFromTopOffset(top: topOffset)
    }
    // MARK: 下方显示
    class func showBottomWithText(text: String) {
        Toast.showBottomWithText(text: text, bottomOffset: 100.0, duration: toastDispalyDuration)
    }
    class func showBottomWithText(text: String, duration: CGFloat) {
        Toast.showBottomWithText(text: text, bottomOffset: 100.0, duration: duration)
    }
    class func showBottomWithText(text: String, bottomOffset: CGFloat) {
        Toast.showBottomWithText(text: text, bottomOffset: bottomOffset, duration: toastDispalyDuration)
    }
    class func showBottomWithText(text: String, bottomOffset: CGFloat, duration: CGFloat) {
        let toast = Toast(text: text)
        toast.setDuration(duration: duration)
        toast.showFromBottomOffset(bottom: bottomOffset)
    }
}

