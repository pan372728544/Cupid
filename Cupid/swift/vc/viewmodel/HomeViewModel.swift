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
    
     lazy var videoModels = [videoModel]()
}

extension HomeViewModel {
    
    
    // 加载分类
    func loadHomeCategoryData( finishedCallback : @escaping () -> ()) {
        
        // 获取公共参数
        let param = HomeRequest.getCommonParamDic()
        
        // 发送请求
        NetworkTools.requestData(.get, URLString: "https://lf-hl.snssdk.com/category/get_ugc_video/2/", parameters: param as? [String : Any], finishedCallback: { (result) -> Void in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["data"] as? [String : Any] else { return }
            guard let dataArray = messageDict["data"] as? [[String : Any]] else { return }
            
            // 转模型数据
            for (_, dict) in dataArray.enumerated() {
                let anchor = AnchorModel(dict: dict)
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
                // 添加到数组中
                self.anchorModels.append(anchor)
            }
            
            finishedCallback()
        })
    }
    
    
    
    // 请求页面内容信息
    func loadHomeContentData(type : HomeType,  finishedCallback : @escaping () -> ()) {
        
        var param = [String:Any]()

        //获取当前时间
        let now = NSDate()

        //当前时间的时间戳
        let timeInterval : TimeInterval = now.timeIntervalSince1970
        let timeSp = Int(timeInterval)
        
        
        param.updateValue("F2TqPzKtP2wbFlDqLlU1FYweLlqM", forKey: "fp")
        param.updateValue("7.1.4", forKey: "version_code")
        param.updateValue("1.11.4.0", forKey: "tma_jssdk_version")
        param.updateValue("news_article", forKey: "app_name")
        param.updateValue("B1D04F39-B96D-497F-A70A-E83CA65C5F40", forKey: "vid")
        param.updateValue("51323627722", forKey: "device_id")
        param.updateValue("aaaa", forKey: "channel")
        
        param.updateValue(type.title, forKey: "category")
        param.updateValue("13", forKey: "aid")
        param.updateValue("z2", forKey: "ab_feature")
        param.updateValue("674052,770488,691934,170988,643890,789047,374117,796903,736955,718154,787497,674789,550042,779836,649429,614100,677128,522765,416055,710077,801968,707372,799600,758017,775820,471406,603441,789029,789246,800950,822925,800208,783645,603384,603397,603404,603406,819029,833900,791017,799524,661899,831094,668775,832706,737592,802346,768905,788012,795195,787344,792681,607361,798863,739594,780799,739393,764921,662099,812271,717949,828943,812396,833138,834067,796690,668774,799948,766806,833238,822673,773349,797402,775311,741713,554836,765190,549647,31644,829921,615291,546703,798354,757280,798160,782137,679101,735201,767991,779958,798121,780078,799341,660830,825059,754087,810110,770571,662176,448104,661781,457481,649402", forKey: "ab_version")
        param.updateValue("5326e05065bd38f79fc442f83ac49b30463c6368", forKey: "openudid")
        param.updateValue("71419", forKey: "update_version_code")
        param.updateValue("a", forKey: "ssmix")

            
        param.updateValue("B1D04F39-B96D-497F-A70A-E83CA65C5F40", forKey: "idfv")
        param.updateValue("iphone", forKey: "device_platform")
        param.updateValue("65728184383", forKey: "iid")
        param.updateValue("a1,f2,f7,e1", forKey: "ab_client")
        param.updateValue("00000000-0000-0000-0000-000000000000", forKey: "idfa")
        param.updateValue("5", forKey: "refresh_reason")
        param.updateValue("1", forKey: "detail")
        param.updateValue(timeSp, forKey: "last_refresh_sub_entrance_interval")
        param.updateValue("auto", forKey: "tt_from")
        param.updateValue("20", forKey: "count")
        param.updateValue("21", forKey: "list_count")
        param.updateValue("4", forKey: "support_rn")
        param.updateValue("deny", forKey: "LBS_status")
        param.updateValue("52C6B403540EAq1", forKey: "cp")
        param.updateValue("0", forKey: "loc_mode")
        param.updateValue("1555051278", forKey: "min_behot_time")
        param.updateValue("1", forKey: "session_refresh_idx")
        param.updateValue("1", forKey: "image")
        param.updateValue("0", forKey: "strict")
        param.updateValue("1", forKey: "refer")
        
        param.updateValue("6286225228934679042", forKey: "concern_id")
        param.updateValue("zh-Hans-CN", forKey: "language")
        param.updateValue("2707", forKey: "st_time")
        param.updateValue("002e00626f97f2958ae862cc7180be4eddd478665da6128a4b2acf", forKey: "mas")
        param.updateValue("a2b5a56b499e7c80003459", forKey: "as")
        param.updateValue(timeSp, forKey: "ts")
        
        
        // MARK: 字符串转字典
        func stringValueDic(_ str: String) -> [String : Any]?{
            let data = str.data(using: String.Encoding.utf8)
            if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
                return dict
            }
            return nil
        }

        NetworkTools.requestData(.get, URLString: "https://lf-hl.snssdk.com/api/news/feed/v88/", parameters:param , finishedCallback: { (result) -> Void in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [ Any] else { return }
            for item in dataArray {
                
                var mm:Dictionary = item as! [String : Any]
                let aa = mm["content"] as!  String
                let dic =  stringValueDic(aa)
                
                let dataAA = dic!["raw_data"] as? [String : Any]
                
                guard let resultDictBB = dataAA?["video"] as? [String : Any] else { return }
                
                // 图片地址
                guard let origin_cover = resultDictBB["origin_cover"] as? [String : Any] else { return }

                guard let url_list = origin_cover["url_list"] as? [String] else { return }
                
                // 视频地址
                guard let play_addr = resultDictBB["play_addr"] as? [String : Any] else { return }

                guard let url_listVideo = play_addr["url_list"] as? [String] else { return }
                
                let modelL = videoModel();

                modelL.img_url = url_list[0]
                modelL.videoUrl = url_listVideo[0]
                modelL.title = dataAA?["title"] as? String ?? ""
                self.videoModels.append(modelL)
            }
            
            
          
            
            finishedCallback()
        })
    }
}
