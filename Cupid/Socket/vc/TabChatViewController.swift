//
//  TabChatViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/24.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化View
        setupMainView()
        
        // 没有登录先登录
        if LogInName == nil {
            popLoginView()
        } else {
            // 连接服务器
            connectServer()
        }
    }
}


extension TabChatViewController {
    
    @objc func logOut (){
        // 删除登录信息
        UserDefaults.standard.removeObject(forKey: NICKNAME)
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
            // 先关闭连接
            socketClient.closeServer()
            
            // 开始连接
            if socketClient.connectServer().isSuccess {
                print("连接服务器成功")
                DispatchQueue.main.async {
                    socketClient.delegate = self
                    
                    // 获取聊天列表
                    socketClient.sendGroupMsg()
                    // 读取消息
                    socketClient.startReadMsg()
                }
            }
        }
    }
    
    // 弹出登录视图
    func popLoginView()  {
        let vc = SelectAccountViewController()
        vc.completedBlock = {
            // 登录完成连接服务器
            self.connectServer()
            LogInName =  UserDefaults.standard.string(forKey: NICKNAME)
            
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
        
        if msgArray.count < 3 {
            msgArray.append(groupMsg)
            self.tableView.reloadData()
        }
    }
    
    func socket(_ socket: ZJSocket, joinRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, leaveRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, chatMsg: TextMessage) {
  
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
        
        return 60
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
