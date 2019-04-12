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
        
             setupUI()
        
      
        
    }
}


extension VideoViewController {
    fileprivate func setupUI(){
        
        setupContentView()
    }
    
    
    fileprivate func setupContentView() {
        
        
        // 1.获取数据
//        let homeTypes = loadTypesData()
        let  type = HomeType()
//        type.title = "ss"
//        type.type = 1
        homeVM.loadHomeData(type: type, index : 0, finishedCallback: {
       
            print("")
            
            
            let  style = ZJTitleStyle()
            style.isScrollEnable = true
            style.isShowBottomLine = true
            let pageFrame = CGRect(x: 0, y: StatusBar_H, width: Screen_W, height: Screen_H-StatusBar_H)
            
            //        let titles : [String] = ["新闻","历史","视频","娱乐","推荐","热点","图片","游戏","人文","政治","财经","体育","o游戏","清明节","五一假期","路由","中国","美国"]
            
            var titles : [String] = [String]()
            
            
            for model:AnchorModel in  self.homeVM.anchorModels {
                titles.append(model.name)
            }
            var child: [AnchorViewController]
            
            child = Array()
            
            for _ in 0..<titles.count{
                
                let vc = AnchorViewController()
                let  type = HomeType()
                type.title = "ss"
                type.type = 1
                vc.homeType = type
                vc.view.backgroundColor = UIColor.randomColor()
                
                child.append(vc)
            }
            
            let pageView = ZJPageView(frame: pageFrame, titles: titles, style: style, childVcs: child, parentVc: self)
            self.view.addSubview(pageView)
            
        })
        
     
        
    }
    
}
