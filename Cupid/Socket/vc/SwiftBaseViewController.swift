//
//  SwiftBaseViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/5/6.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class SwiftBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.获取系统的Pop手势
        guard let systemGes = self.navigationController?.interactivePopGestureRecognizer else { return }

        //2.获取手势添加到的View中
        guard  let gesView = systemGes.view else { return }
        
        //3.获取target／action
        //3.1利用运行时机制查看所有的属性名称
        //        var count : UInt32 = 0
        //        let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)!
        //        for i in 0..<count {
        //            let ivar = ivars[Int(i)]
        //            let name = ivar_getName(ivar)
        //            print(String(cString: name!))
        //        }
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        
        //取出target
        guard let target = targetObjc.value(forKey: "target") else { return }
        
        //取出action
        //        guard let action = targetObjc.value(forKey: "action") as? Selector else { return }
        let action = Selector(("handleNavigationTransition:"))
        
        
        // 创建自己的pan手势
        let panGes = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)
 
    }
    

}
