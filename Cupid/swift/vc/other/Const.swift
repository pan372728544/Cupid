//
//  Const.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/3.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit


let Screen_W : CGFloat = UIScreen.main.bounds.width

let Screen_H : CGFloat = UIScreen.main.bounds.height

let Tabbar_H : CGFloat = CGFloat(49+(UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom)! )

let Bottom_H : CGFloat = (UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom)!


let StatusBar_H : CGFloat = UIApplication.shared.statusBarFrame.size.height



let NavaBar_H : CGFloat = StatusBar_H + 50


let socketClient : ZJSocket = ZJSocket(addr: "10.2.116.43", port: 7878)

let LogInName =  UserDefaults.standard.string(forKey: NICKNAME)

