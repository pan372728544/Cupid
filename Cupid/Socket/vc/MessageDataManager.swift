//
//  MessageDataManager.swift
//  Cupid
//
//  Created by panzhijun on 2019/5/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

class MessageDataManager: NSObject {

    
    static let shareInstance = MessageDataManager()
    
    func updateHuiHua(_ message: Any)  {
        NotificationCenter.default.post(name: NSNotification.Name("updataHuiHua"), object: self, userInfo: ["mess": message])
    }
    
    // 更新列表数据库
    open func insertRealmGroupMessage(cupid : GroupMessage.Builder) {
        let chatMsg = try! cupid.build()
        let userChat = chatMsg.user
        // realm消息数据
        let message = GroupListMessage()
        message.text = chatMsg.text
        message.groupId = Int(chatMsg.groupId)
        message.id = Int(chatMsg.groupId)
        // realm用户数据
        let realmUser = UserInfoRealm()
        realmUser.name = userChat!.name
        realmUser.level = Int(userChat!.level)
        realmUser.iconUrl = userChat!.iconUrl
        realmUser.userId = userChat!.userId
        
        message.userInfo = realmUser
        RealmTool.updateGroupMessage(message: message)
    }
    
    // 插入聊天会话 聊天记录
   open func insertRealmTextMessage(cupid : TextMessage.Builder) {
        let chatMsg = try! cupid.build()
        let userChat = chatMsg.user
        // realm消息数据
        let message = ChatMessage()
        message.text = chatMsg.text
        message.chatId = chatMsg.chatId
        message.toUserId = chatMsg.toUserId
        message.chatType = chatMsg.chatType
        message.success = chatMsg.success
        message.sendTime = chatMsg.sendTime
        
        // realm用户数据
        let realmUser = UserInfoRealm()
        realmUser.name = userChat!.name
        realmUser.level = Int(userChat!.level)
        realmUser.iconUrl = userChat!.iconUrl
        realmUser.userId = userChat!.userId
        
        message.userInfo = realmUser
        RealmTool.insertMessage(by: message)
        
    }
    
    
    // 查询聊天列表数据
    func searchRealmGroupList(curr : Int) -> [GroupMessage] {
        
        // 返回的数组
        var msgArray : [GroupMessage] = [GroupMessage]()
        
        let messages : Results<GroupListMessage>
        
        messages =  RealmTool.getGroupMessages()
        
        // 数据库总数据
        let  messageCount = messages.count
        if messageCount == 0 {
            return msgArray
        }
        
        // 遍历数据
        for mess in messages {
            
            // 创建聊天类型数据
            let textMsg = GroupMessage.Builder()
            textMsg.text = mess.text!
            textMsg.groupId = Int64(mess.groupId)
            
            // realm类型用户信息
            let userRealm : UserInfoRealm = mess.userInfo!
            
            // 创建聊天用户类型数据
            let  userInfo = UserInfo.Builder()
            userInfo.name = userRealm.name!
            userInfo.level = Int64(userRealm.level)
            userInfo.iconUrl = userRealm.iconUrl!
            userInfo.userId = userRealm.userId!
            
            // 用户信息
            textMsg.user = try! userInfo.build()
            
            let msg = try? textMsg.build()
            if msg != nil {

                let userId : Int64 = Int64(LogInName!.suffix(1))!
                if (msg?.groupId)! - 1000 !=  userId {
                    msgArray.append(msg!)
                }
        
            }
            
        }

        return msgArray
    }
    
}

extension MessageDataManager {
    
    func handleMsgList(chatMsg: TextMessage) {
        
        // 聊天内容
        let  text = chatMsg.text!
        // 发送给谁的id
        let id = Int(chatMsg.toUserId)! + 1000
        // 发送者id
        let toid  = chatMsg.user.userId
        let messages  =  RealmTool.getGroupMessages()
        let num : Int64 = Int64(id)
        let tonum : Int = Int(toid!)! - 1
        let  messageCount = messages.count
        let other : Int = Int(toid!)! + 1000
        var names = ["TheMokeyKing:","BAYMAX:","IronMan:","群聊天555555:"]
        for i in 0..<messageCount {
            
            let mess = messages[i]
            
            // 更新列表最后一套数据
            if chatMsg.chatType == "1" {
                if mess.groupId == num {
                    
                    let newMess =  GroupListMessage()
                    newMess.groupId = Int(num)
                    newMess.userInfo = mess.userInfo
                    
                    newMess.text = "\(names[tonum]) \(text)"
                    newMess.id = Int(num)
                    RealmTool.updateGroupMessage(message: newMess)
                } else if mess.groupId == other {
                    let newMess =  GroupListMessage()
                    newMess.groupId = Int(other)
                    newMess.userInfo = mess.userInfo
                    newMess.text = "\(names[tonum]) \(text)"
                    newMess.id = Int(other)
                    RealmTool.updateGroupMessage(message: newMess)
                }
            } else if String(mess.groupId) == "1004" {

                let newMess =  GroupListMessage()
                newMess.groupId = mess.groupId
                newMess.userInfo = mess.userInfo
                newMess.text = "\(names[tonum]) \(text)"
                newMess.id = Int(mess.groupId)
                RealmTool.updateGroupMessage(message: newMess)
            }
            
            
        }
        
        // 更新聊天记录
        let builder = try! chatMsg.toBuilder()
        insertRealmTextMessage(cupid: builder)
    }
}


extension MessageDataManager : ZJSocketDelegate {
    func socket(_ socket: ZJSocket, joinRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, leaveRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, chatMsg: TextMessage) {
        print("接收到会话消息： \(chatMsg.text ?? "")")
        
        // 发送通知给会话页面 数组添加这条数据
        MessageDataManager.shareInstance.updateHuiHua(chatMsg)
        
        // 更新聊天列表数据库 和 插入数据到聊天记录数据库
        MessageDataManager.shareInstance.handleMsgList(chatMsg: chatMsg)
        
        // 上面已经存储数据到数据库
        notificationToGroupList()
    }
    
    func socket(_ socket: ZJSocket, groupMsg: GroupMessage) {
        
        print("接收到列表消息数据： \(groupMsg.text ?? "")")
        // 列表消息插入更新到数据库
        let build = try! groupMsg.toBuilder()
        
        MessageDataManager.shareInstance.insertRealmGroupMessage(cupid: build)
    }
    
    
}


extension MessageDataManager {
    
    // 收到消息通知给列表
    func notificationToGroupList()  {
        
        NotificationCenter.default.post(name: NSNotification.Name("updateGroupList"), object: self, userInfo:nil)
    }
}
