//
//  TabChatViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/24.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class TabChatViewController: ZJBaseViewController {

    // 服务器地址
    fileprivate var socket : ZJSocket = ZJSocket(addr: "10.2.116.69", port: 7878)
    
        fileprivate var msgArray : [GroupMessage] = [GroupMessage]()
    
    fileprivate lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: NavaBar_H,
                                                   width: Screen_W,
                                                   height: Screen_H-NavaBar_H-Tabbar_H),
                                     style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.tableViewBackGroundColor()
        return tableView
    }()
    
    fileprivate lazy var  name : String =  UserDefaults.standard.string(forKey: NICKNAME) ?? ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
       
        if UserDefaults.standard.string(forKey: NICKNAME) == nil {
            
            popLoginView()
            
        } else {
            connectServer()
        }
        

    }
    


}


extension TabChatViewController {
    
    @objc func logOut (){
        
        UserDefaults.standard.removeObject(forKey: NICKNAME)
//        self.socket.closeServer()
    }
}


extension TabChatViewController {
    
    // 创建tableview
    func setupTableView() {
        
        self.tableView.register(TabChatTableViewCell.self, forCellReuseIdentifier: "TabChatTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        view.addSubview(self.tableView)
        
    }
    
    func setupView()  {
        if (UserDefaults.standard.string(forKey: NICKNAME) != nil) {
            let name = UserDefaults.standard.string(forKey: NICKNAME)
            
            let Coun = name!.count
            
            self.createNavBarView(withTitle: "\( String(name!.prefix(Coun-4)))")
        }else
        {
            self.createNavBarView(withTitle: "消息中心")
        }

        self.createNavRightBtn(withItem: "退出登录", target: self, action: #selector(logOut))
        self.superNavBarView.backgroundColor = UIColor.commonColor()
        
        setupTableView()
    }
    
    func connectServer() {
        
        DispatchQueue.global().async {
            
            if self.socket.connectServer().isSuccess {
                print("连接成功")
                DispatchQueue.main.async {
                    self.socket.delegate = self
                    
                    self.socket.sendGroupMsg()
                    self.socket.startReadMsg()
                }
             
            }
            
        }
    }
    
    func popLoginView()  {
        let vc = SelectAccountViewController()
        vc.completedBlock = {
            self.connectServer()
            let name = UserDefaults.standard.string(forKey: NICKNAME)
            
            let Coun = name!.count
            
            self.createNavBarView(withTitle: "欢迎-\( String(name!.prefix(Coun-4)))-归来")
            self.tableView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
   
}

extension TabChatViewController : ZJSocketDelegate{
    func socket(_ socket: ZJSocket, groupMsg: GroupMessage) {
        msgArray.append(groupMsg)
        self.tableView.reloadData()
    }
    
    func socket(_ socket: ZJSocket, joinRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, leaveRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, chatMsg: TextMessage) {

  
        
    }
    
    
    func socket(_ socket: ZJSocket, giftMsg: GiftMessage) {
        
    }
    
    
}

extension TabChatViewController : UITableViewDataSource,UITableViewDelegate {


    // tabview代理
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
//
        if UserDefaults.standard.string(forKey: NICKNAME) != nil  {
            let group = msgArray[indexPath.row]
            
            let chatVc = IMChatViewController(group: group)
            
            self.navigationController?.pushViewController(chatVc, animated: true)
        } else {
            
               popLoginView()
        }

        
        
    }
    
}
