//
//  HomeViewModel.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class HomeViewModel {
    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
    func loadHomeData(type : HomeType, index : Int,  finishedCallback : @escaping () -> ()) {
        
        let param = HomeRequest.getCommonParamDic()
        
        
        NetworkTools.requestData(.get, URLString: "https://lf-hl.snssdk.com/category/get_ugc_video/2/", parameters: param as? [String : Any], finishedCallback: { (result) -> Void in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["data"] as? [String : Any] else { return }
            guard let dataArray = messageDict["data"] as? [[String : Any]] else { return }

//            let dataArray = ["default_add": "ddd","default_add":"dddddd"]
            

            
            for (_, dict) in dataArray.enumerated() {
                let anchor = AnchorModel(dict: dict)
//                anchor.isEvenIndex = index % 2 == 0
                if (dict["default_add"] != nil)
                {
                anchor.default_add = dict["default_add"] as! Int
                }
                anchor.web_url = dict["web_url"] as! String
                if (dict["stick"] != nil){
                anchor.stick = dict["stick"] as! Int
                }
                anchor.category = dict["category"] as! String
                anchor.name = dict["name"] as! String
                anchor.icon_url = dict["icon_url"] as! String
                anchor.concern_id = dict["concern_id"] as! String
                anchor.image_url = dict["image_url"] as! String
                anchor.tip_new = dict["tip_new"] as! Int
                anchor.flags = dict["flags"] as! Int
                anchor.type = dict["type"] as! Int
                self.anchorModels.append(anchor)
            }
            
            finishedCallback()
        })
    }
}
