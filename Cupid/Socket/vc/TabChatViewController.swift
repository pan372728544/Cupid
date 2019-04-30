//
//  TabChatViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/24.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

class TabChatViewController: ZJBaseViewController {
    
    // 聊天列表数组
    fileprivate var msgArray : [GroupMessage] = [GroupMessage]()
    
    // tableView
    fileprivate lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: NavaBar_H,
                                                   width: Screen_W,
                                                   height: Screen_H-NavaBar_H-Tabbar_H),
                                     style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.tableViewBackGroundColor()
        return tableView
    }()
    // 定时器
    fileprivate var heartBeatTimer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // 配置数据库
        RealmTool.configRealm()
        
        // 初始化View
        setupMainView()
        
        // 没有登录先登录
        if LogInName == nil {
            popLoginView()
        } else {
            // 查询数据
            _ =  searchRealm(curr: 1)
            
            
            // 连接服务器
            connectServer()
            

        }

    }
   
    deinit {
        socketClient.sendLeaveRoom()

    }
}


extension TabChatViewController {
    
    @objc func logOut (){

        let messagesGroup : Results<GroupListMessage> =  RealmTool.getGroupMessages()
        RealmTool.deleteGroupMessages(messages: messagesGroup)
        
        let messages : Results<ChatMessage> =  RealmTool.getMessages()
        RealmTool.deleteMessages(messages: messages)
        
        let user : Results<UserInfoRealm> =  RealmTool.getUserInfo()
        RealmTool.deleteUserInfos(messages: user)
        
        socketClient.sendLeaveRoom()
        // 先关闭连接
        socketClient.closeServer()
        self.msgArray.removeAll()
        // 删除登录信息
        UserDefaults.standard.removeObject(forKey: NICKNAME)
        popLoginView()
    }
    
}


extension TabChatViewController {
    
    func setupMainView()  {
        if (LogInName != nil) {
            
            let Coun = LogInName!.count
            
            self.createNavBarView(withTitle: "\( String(LogInName!.prefix(Coun-4)))")
        }else{
            self.createNavBarView(withTitle: "消息中心")
        }
        
        self.createNavRightBtn(withItem: "退出登录", target: self, action: #selector(logOut))
        self.superNavBarView.backgroundColor = UIColor.commonColor()
        self.setRightTitleColro(UIColor.black)
        self.setTitleColor(UIColor.white)
        setupTableView()
    }
    
    // 创建tableview
    func setupTableView() {
        
        self.tableView.register(TabChatTableViewCell.self, forCellReuseIdentifier: "TabChatTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.white
        view.addSubview(self.tableView)
        
    }
    
    func connectServer() {
        
        DispatchQueue.global().async {
       
            
            // 开始连接
            if socketClient.connectServer().isSuccess {
                print("连接服务器成功")
                DispatchQueue.main.async {
                    socketClient.delegate = self
                    
                    // 获取聊天列表
                    socketClient.sendGroupMsg()
                    // 读取消息
                    socketClient.startReadMsg()
                    
                    // 加入房间
                    socketClient.sendJoinRoom()
                    // 发送心跳包
//                    self.addHeartBeatTimer()
                }
            }
        }
    }
    
    // 弹出登录视图
    func popLoginView()  {
        let vc = SelectAccountViewController()
        vc.completedBlock = {
            
            LogInName =  UserDefaults.standard.string(forKey: NICKNAME)
            // 登录完成连接服务器
            self.connectServer()

            let Coun = LogInName!.count
            self.createNavBarView(withTitle: "欢迎-\( String(LogInName!.prefix(Coun-4)))-归来")
            self.tableView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
   
}

extension TabChatViewController : ZJSocketDelegate {
    
    // 收到聊天列表消息
    func socket(_ socket: ZJSocket, groupMsg: GroupMessage) {
        
           print("接收到群组消息： \(groupMsg.text)")
        if msgArray.count < 3 {
            msgArray.append(groupMsg)
            
            // 插入数据
            let build = try! groupMsg.toBuilder()
            
            insertRealm(cupid: build)
            self.tableView.reloadData()
        }
    }
    
    func socket(_ socket: ZJSocket, joinRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, leaveRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, chatMsg: TextMessage) {
  
        print("接收到回话消息： \(chatMsg.text)")
        
        // 发送通知给会话页面
        notificationToChat(chatMsg)
        
        // 更新聊天列表
        updateChatList(chatMsg)

    }

}

extension TabChatViewController : UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabChatTableViewCell") as! TabChatTableViewCell
        
        cell.textMes = msgArray[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 跳转到聊天页面
        if LogInName != nil  {
            let group = msgArray[indexPath.row]
            let chatVc = IMChatViewController(group: group)
            self.navigationController?.pushViewController(chatVc, animated: true)
        } else {
            popLoginView()
        }
        
    }
    
}

extension TabChatViewController {
    
    // 插入数据
    func insertRealm(cupid : GroupMessage.Builder) {
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
        RealmTool.insertMessage(by: message)
    }
    
    
    // 查询数据
    func searchRealm(curr : Int) -> Int {
        let messages : Results<GroupListMessage>

        messages =  RealmTool.getGroupMessages()

        // 数据库总数据
        let  messageCount = messages.count
        if messageCount == 0 {
            return 0
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
                if messageCount == 3 {
                self.msgArray.append(msg!)
                }
            }
            
        }
        self.tableView.reloadData()
        return messageCount
    }
    
}


// MARK:- 给服务器发送即时消息
extension TabChatViewController {
    
    fileprivate func addHeartBeatTimer() {
        heartBeatTimer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        RunLoop.main.add(heartBeatTimer!, forMode: RunLoop.Mode.common)
    }
    
    @objc fileprivate func sendHeartBeat() {
        socketClient.sendHeartBeat()
        print("发送心跳包")
    }
}

extension TabChatViewController {
    
    // 收到消息通知给会话页面
    func notificationToChat(_ message: Any)  {
        
        NotificationCenter.default.post(name: NSNotification.Name("chatUpdate"), object: self, userInfo: ["mess": message])
    }
    
    // 更新消息列表
    func updateChatList(_ chatMsg: TextMessage)  {

        handleMsgList(chatMsg: chatMsg)
    
    }
    
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
        var names = ["齐天大圣:","BAYMAX:","钢铁侠:","群聊天555555:"]
        for i in 0..<messageCount {
            
            let mess = messages[i]
            
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
                print("qun")
                
                let newMess =  GroupListMessage()
                newMess.groupId = mess.groupId
                newMess.userInfo = mess.userInfo
                newMess.text = "\(names[tonum]) \(text)"
                newMess.id = Int(mess.groupId)
                RealmTool.updateGroupMessage(message: newMess)
            }
            
           
        }
        self.msgArray .removeAll()
        _ = searchRealm(curr: 1)
        
        // 插入数据到数据库
        let builder = try! chatMsg.toBuilder()
        insertRealm(cupid: builder)
    }
    
    
    
    // 插入数据
    func insertRealm(cupid : TextMessage.Builder) {
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
}
