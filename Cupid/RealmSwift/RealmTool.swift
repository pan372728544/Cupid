//
//  RealmTool.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/28.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

class RealmTool: Object {
    private class func defaultRealm() -> Realm {
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL.init(string: getRealmPath())!)
        return defaultRealm
    }
}

extension RealmTool {
    
    private class func getRealmPath() -> String{
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/message.realm")
        print("realm地址为： \(dbPath)")
        return dbPath
    }
}

// MARK: - 配置
extension RealmTool  {

    @objc  public class func configRealm() {

        var config = Realm.Configuration()
        // 设置路径
        config.fileURL = URL.init(string: getRealmPath())
        Realm.Configuration.defaultConfiguration = config
        
        // 异步打开数据库
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
                print("Realm 服务器配置成功!")
            }else if let error = error {
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
}

// MARK: - 数据库操作 增加数据
extension RealmTool {
    /// 保存一个ChatMessage
    public class func insertMessage(by message : ChatMessage) {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.add(message)
        }
    }
    
    /// 保存数据ChatMessage
    public class func insertMessages(by messages : [ChatMessage])  {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.add(messages)
        }
    }
    
    /// 保存群组列表
    public class func insertMessage(by message : GroupListMessage) {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.add(message)
        }
    }
    
}

// MARK: - 数据库操作 查找
extension RealmTool {
    /// 获取 所保存的 ChatMessage
    public class func getMessages() -> Results<ChatMessage> {
        let realm = self.defaultRealm()
        return realm.objects(ChatMessage.self)
    }
    
    
    public class func getUserInfo() -> Results<UserInfoRealm> {
        let realm = self.defaultRealm()
        return realm.objects(UserInfoRealm.self)
    }
    
    
    /// 获取 所保存的 groupMessage
    public class func getGroupMessages() -> Results<GroupListMessage> {
        let realm = self.defaultRealm()
        return realm.objects(GroupListMessage.self)
    }
    
    /// 获取 指定id (主键) 的 ChatMessage
    public class func getMessage(from id : Int) -> ChatMessage? {
        let realm = self.defaultRealm()
        return realm.object(ofType: ChatMessage.self, forPrimaryKey: id)
    }
    
    /// 获取 指定条件查询
    public class func getMessageByPredicate(_ predicate: String) -> Results<ChatMessage> {
        let realm = self.defaultRealm()

        let pre = NSPredicate(format: predicate)
        let results = realm.objects(ChatMessage.self)
        return  results.filter(pre)
    }
    
    /// 获取 按id排序
    public class func getMessageByIdSorted(_ isAscending: Bool) -> Results<ChatMessage> {
        let realm = self.defaultRealm()
        let results = realm.objects(ChatMessage.self)
        return  results.sorted(byKeyPath: "id", ascending: isAscending)
    }
}

// MARK: - 数据库操作 更新
extension RealmTool {
    
    /// 更新单个 messages
    public class func updateGroupMessage(message : GroupListMessage) {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.add(message, update: true)
        }
    }
    
    
    /// 更新单个 messages
    public class func updateMessage(message : ChatMessage) {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.add(message, update: true)
        }
    }
    
    /// 更新多个 messages
    public class func updateMessage(messages : [ChatMessage]) {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.add(messages, update: true)
        }
    }
    
    /// 更新 用户名
    public class func updateMessageName(name : String) {
        let realm = self.defaultRealm()
        try! realm.write {
            let messages = realm.objects(ChatMessage.self)
            messages.setValue(name, forKey: "name")
        }
    }
    
}

// MARK: - 数据库操作 删除
extension RealmTool {
    /// 删除单个 ChatMessage
    public class func deleteMessage(message : ChatMessage) {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.delete(message)
        }
    }
    
    /// 删除多个 ChatMessage
    public class func deleteMessages(messages : Results<ChatMessage>) {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.delete(messages)
        }
    }
    
    
    /// 删除多个 GroupListMessage
    public class func deleteGroupMessages(messages : Results<GroupListMessage>) {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.delete(messages)
        }
    }
    
    
    /// 删除多个 UserInfoRealm
    public class func deleteUserInfos(messages : Results<UserInfoRealm>) {
        let realm = self.defaultRealm()
        try! realm.write {
            realm.delete(messages)
        }
    }
}



