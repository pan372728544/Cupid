//
//  SocketManager.swift
//  Cupid
//
//  Created by panzhijun on 2019/5/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

@objc
open class SocketManager : NSObject {
    
    static let sharedInstanceSwift = SocketManager()
    
    // 定时器
    fileprivate var heartBeatTimer : Timer?
    // 聊天列表数组
    fileprivate var msgGroups : [GroupMessage] = [GroupMessage]()
    // 连接
    @objc open func connect() {
        

        
        if  UserDefaults.standard.string(forKey: NICKNAME) == nil {
            return
        }

        // 开始连接
        if socketClient.connectServer().isSuccess {
            print("连接服务器成功")
            DispatchQueue.global().async {

                socketClient.delegate = MessageDataManager.shareInstance as ZJSocketDelegate
                
                
                self.msgGroups   =  MessageDataManager.shareInstance.searchRealmGroupList(curr: 1)
                if self.msgGroups.count <= 0 {
                    // 获取聊天列表
                    socketClient.sendGroupMsg()
                } else {
                    
                    DispatchQueue.main.async {
                        print(Thread.current)
                        NotificationCenter.default.post(name: NSNotification.Name("chatUpdateGroupList"), object: self, userInfo: nil)
                    }
               
                }

                // 读取消息
                socketClient.startReadMsg()
                
                // 加入房间
                socketClient.sendJoinRoom()
                // 发送心跳包
                self.addHeartBeatTimer()
            }
        }
    }
    
    // swift 获取
    @objc open class func sharedInstance() -> SocketManager
    {
        return sharedInstanceSwift
    }
    
    // 关闭
   @objc open func close()   {
        DispatchQueue.global().async {
            self.heartBeatTimer?.invalidate()
            self.heartBeatTimer = nil
            socketClient.sendLeaveRoom()
            socketClient.closeServer()
            
            // 删除登录信息
            UserDefaults.standard.removeObject(forKey: NICKNAME)

        }
    }
    
    func addHeartBeatTimer() {
        heartBeatTimer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        RunLoop.main.add(heartBeatTimer!, forMode: RunLoop.Mode.common)
    }
    
    @objc fileprivate func sendHeartBeat() {
        socketClient.sendHeartBeat()
        print("发送心跳包")
    }

}

