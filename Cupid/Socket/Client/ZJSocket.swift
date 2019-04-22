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
}


class ZJSocket {
    
    weak var delegate : ZJSocketDelegate?
    
    fileprivate var tcpClient : TCPClient
    // 用户信息
//    fileprivate var userInfo : UserInfo.Builder = {
//        let userInfo = UserInfo.Builder()
//        userInfo.name = "name:wang\(arc4random_uniform(10))"
//        userInfo.level = 2
//        userInfo.iconUrl = "http://img.52z.com/upload/news/image/20180212/20180212084623_32086.jpg"
//        return userInfo
//    }()
    
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
    
    func sendTextMsg(message : String ,nikeName : String) {
        // 1.创建TextMessage类型
        let chatMsg = TextMessage.Builder()
//        chatMsg.user = try! userInfo.build()
//        chatMsg.text = message
        
        let userInfo = UserInfo.Builder()
        userInfo.name = nikeName
        userInfo.level = 2
        
        
        let imgs : [String] = ["http://pic102.nipic.com/file/20160624/22734439_173946745000_2.jpg","http://img.52z.com/upload/news/image/20180212/20180212084623_32086.jpg","http://photo.tuchong.com/4067228/f/508035880.jpg"]
        
        let defaults = UserDefaults.standard
        let typeStr : String =  defaults.string(forKey: "type") ?? "1"

        let n : Int = Int(typeStr) ?? 1
        
        let str = imgs[n-1]
        
        
        userInfo.iconUrl = str
        
        chatMsg.user = try! userInfo.build()
        chatMsg.text = message
        // 2.获取对应的data
        let chatData = (try! chatMsg.build()).data()
        
        // 3.发送消息到服务器
        sendMsg(data: chatData, type: 2)
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
