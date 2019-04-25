//
//  ZJSocket.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/17.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

// 代理
protocol ZJSocketDelegate : class {
    func socket(_ socket : ZJSocket, joinRoom user : UserInfo)
    func socket(_ socket : ZJSocket, leaveRoom user : UserInfo)
    func socket(_ socket : ZJSocket, chatMsg : TextMessage)
    func socket(_ socket : ZJSocket, giftMsg : GiftMessage)
    func socket(_ socket : ZJSocket, groupMsg : GroupMessage)
}


class ZJSocket : NSObject{
    
    weak var delegate : ZJSocketDelegate?
    
    fileprivate var tcpClient : TCPClient

    var imgs : [String] = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556091375677&di=b77ddcda0fdcb6e4062b63c2e349cd09&imgtype=0&src=http%3A%2F%2Fimg.storage.17wanba.org.cn%2Fgame%2F2016%2F05%2F10%2Fd729d853b0519256f9c6189e6f9eb457.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556091346923&di=94a030de1baced5369065862835fad23&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F010b0d5541ef6c000001714a5ae2e9.jpg%402o.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556091569946&di=e9d9569824014cb2733c8ceb10c19ad4&imgtype=0&src=http%3A%2F%2Fimg.7xz.com%2Fimg%2Fpicimg%2F201607%2F20160728163406_389ae972b1283f76160.jpg","http://img.qqzhi.com/upload/img_1_3452678024D953860635_23.jpg"]
    
    init(addr: String, port : Int32) {
        // 创建TCP
        tcpClient = TCPClient(address: addr, port: port )
    }
}


// MARK:- scoket调用方法
extension ZJSocket {
    
    // 连接服务器
    func connectServer() -> Result {
        
        return tcpClient.connect(timeout: 5)
    }
    
    
    // 连接服务器
    func closeServer() {
        
        return tcpClient.close()
    }
    
    
    // 读取消息
    func startReadMsg()  {
        // 开启线程读取消息
        DispatchQueue.global().async {
            print("客户端读取消息。。。\(Thread.current)")
      
            while true {
       
                // 读取4个长度
                guard let lMsg = self.tcpClient.read(4) else {
                    continue
                }
                // 1.读取长度的data
                let headData = Data(bytes: lMsg, count: 4)
                var length : Int = 0
                (headData as NSData).getBytes(&length, length: 4)
                
                // 2.读取类型
                guard let typeMsg = self.tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type : Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
//                print(type)
                
                // 2.根据长度, 读取真实消息
                guard let msg = self.tcpClient.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)
                
                // 3.处理消息
                DispatchQueue.main.async {
                    self.handleMsg(type: type, data: data)
                }
                
                
                
            }
            
        }
    }
    
    // 处理消息
    fileprivate func handleMsg(type : Int, data : Data) {
        switch type {
        case 0, 1:
            let user = try! UserInfo.parseFrom(data: data)
            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
        case 2:
            let chatMsg = try! TextMessage.parseFrom(data: data)
            delegate?.socket(self, chatMsg: chatMsg)
        case 3:
            let giftMsg = try! GiftMessage.parseFrom(data: data)
            delegate?.socket(self, giftMsg: giftMsg)
            
        case 10:
            let group = try! GroupMessage.parseFrom(data: data)
            delegate?.socket(self, groupMsg: group)
        default:
            print("未知类型")
        }
    }
}


extension ZJSocket {
    func sendJoinRoom() {
        // 1.获取消息的长度
//        let msgData = (try! userInfo.build()).data()
//
//        // 2.发送消息
//        sendMsg(data: msgData, type: 0)
    }
    
    func sendLeaveRoom() {
//        // 1.获取消息的长度
//        let msgData = (try! userInfo.build()).data()
//
//        // 2.发送消息
//        sendMsg(data: msgData, type: 1)
    }
    
    func sendTextMsg(message : String, group : GroupMessage) {
        
        let defaults = UserDefaults.standard
        // 获取用户名和id
        let name = defaults.string(forKey: NICKNAME)
        
        let userId : String = String(name!.suffix(1))

        let chatMsg = TextMessage.Builder()
        
        let userInfo = UserInfo.Builder()
        
        let Coun = name!.count
    
        // 用户名
        userInfo.name = String(name!.prefix(Coun-4) )

        // 用户等级
        userInfo.level = Int64(userId)!
        // 用户ID
        userInfo.userId = userId


        let n : Int = Int(userId)!
        
        let str = imgs[n-1]
        
        // 头
        userInfo.iconUrl = str
        
        chatMsg.user = try! userInfo.build()
        chatMsg.text = message
        chatMsg.chatId = String(group.groupId)
        // 2.获取对应的data
        let chatData = (try! chatMsg.build()).data()
        
        // 3.发送消息到服务器
        sendMsg(data: chatData, type: 2)
    }
    
    // 获取聊天列表
    func sendGroupMsg() {
        
        var names = ["齐天大圣-001","BAYMAX-002","钢铁侠-003","群聊天555555-004"]
        
        var texts = ["如来在哪里？","你看起来很健康。","我没有电了！！！","大家都来这里，这里有好东西！"]
        
        let defaults = UserDefaults.standard
        // 获取用户名和id
        let name = defaults.string(forKey: NICKNAME)
        let userId : String = String(name!.suffix(1))
        
        names.remove(at: Int(userId)!-1)
        texts.remove(at: Int(userId)!-1)
        imgs.remove(at:  Int(userId)!-1)
        
        for  i in 0...2 {
            
            // 群组信息
            let chatMsg = GroupMessage.Builder()
            
            let userInfo = UserInfo.Builder()
            
      
            
            let Coun = names[i].count - 4
            
            userInfo.name = String(names[i].prefix(Coun))
            userInfo.level = Int64(i)

            userInfo.userId = String(i)
            userInfo.iconUrl = imgs[i]
            
            chatMsg.user = try! userInfo.build()
            chatMsg.text = texts[i]
            chatMsg.groupId = Int64(names[i].suffix(3))! + 1000
            
            // 2.获取对应的data
            let chatData = (try! chatMsg.build()).data()
            
            sendMsg(data: chatData, type: 10)
        }

    }
    
    func sendGiftMsg(giftName : String, giftURL : String, giftCount : String) {
        // 1.创建GiftMessage
//        let giftMsg = GiftMessage.Builder()
//        giftMsg.user = try! userInfo.build()
//        giftMsg.giftname = giftName
//        giftMsg.giftUrl = giftURL
//        giftMsg.giftCount = giftCount
//
//        // 2.获取对应的data
//        let giftData = (try! giftMsg.build()).data()
//
//        // 3.发送礼物消息
//        sendMsg(data: giftData, type: 3)
    }
    
    func sendHeartBeat() {
        // 1.获取心跳包中的数据
        let heartString = "I am is heart beat;"
        let heartData = heartString.data(using: .utf8)!
        
        // 2.发送数据
        sendMsg(data: heartData, type: 100)
    }
    
    func sendMsg(data : Data, type : Int) {
        // 1.将消息长度, 写入到data
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        
        // 2.消息类型
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 3.发送消息
        let totalData = headerData + typeData + data
        let res : Result = tcpClient.send(data: totalData)
        if res.isSuccess {
            print("消息发送成功。。。")
        }
    }
}
