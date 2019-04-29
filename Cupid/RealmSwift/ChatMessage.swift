//
//  ChatMessage.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift


class UserInfoRealm: Object {
    // 用户信息模型
    @objc dynamic var name : String? = ""
    @objc dynamic var level = 0
    @objc dynamic var iconUrl : String? = ""
    @objc dynamic var userId : String? = ""


}

class ChatMessage: Object {
    
    // 消息模型
    @objc dynamic var text : String? = ""
    @objc dynamic var chatId : String? = ""
    @objc dynamic var toUserId : String? = ""
    @objc dynamic var chatType : String? = ""
    @objc dynamic var success : String? = ""
    @objc dynamic var sendTime : String? = ""
    @objc dynamic var userInfo: UserInfoRealm? = nil
    
}


class GroupListMessage: Object {
    
    // 群组列表
    @objc dynamic var text : String? = ""
    @objc dynamic var groupId = 0
    @objc dynamic var id = 0
    @objc dynamic var userInfo: UserInfoRealm? = nil
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
