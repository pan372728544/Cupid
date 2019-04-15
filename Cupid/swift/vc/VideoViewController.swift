//
//  VideoViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class VideoViewController: ZJBaseViewController {

    fileprivate lazy var homeVM : HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // 创建View
        setupUI()
    }
}


extension VideoViewController {
    fileprivate func setupUI(){
        
        // 初始化内容视图
        setupContentView()
    }
    
    fileprivate func setupContentView() {
        
        // 发送请求获取分类名称
        homeVM.loadHomeCategoryData(finishedCallback: {
       
            // 设置滚动标题样式
            let  style = ZJTitleStyle()
            style.font = UIFont.systemFont(ofSize: 15.0)
            style.normalColor = UIColor.init(r: 0, g: 0, b: 0)
            style.selectedColor = UIColor.init(r: 210, g: 50, b: 50)
            style.bottomLineColor =  UIColor.init(r: 210, g: 50, b: 50)
            style.isScrollEnable = true
            style.isShowBottomLine = true
            let pageFrame = CGRect(x: 0, y: StatusBar_H, width: Screen_W, height: Screen_H-StatusBar_H)

            // 临时数组
            var titles : [String] = [String]()
            
            var titlesType : [String] = [String]()
            
                 var homeY : [HomeType] = [HomeType]()
            
            // 遍历接口返回数据
            for model:AnchorModel in  self.homeVM.anchorModels {
                titles.append(model.name)
                titlesType.append(model.category)
                let homeT = HomeType()
                homeT.title = model.category
                homeY.append(homeT)
            }
            // 创建child
            var childvc = [AnchorViewController]()

           
            
            for index in 0..<titles.count{
                
                let vc = AnchorViewController()
                vc.homeType = homeY[index]
                
                childvc.append(vc)
            }
            // 添加
            let pageView = ZJPageView(frame: pageFrame, titles: titles, style: style, childVcs: childvc, parentVc: self)
            self.view.addSubview(pageView)
            
        })

    }
    
}
