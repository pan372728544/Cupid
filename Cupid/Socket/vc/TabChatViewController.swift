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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化View
        setupMainView()
        
        // 没有登录先登录
        if LogInName == nil {
            popLoginView()
        } else {
            // 查询并刷新tableview
            searchAndReload()
        }
        // 注册通知 添加收到消息更新列表数据
        registerNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}


extension TabChatViewController {
    
    @objc func logOut (){

        SocketManager.sharedInstanceSwift.close()
        self.msgArray.removeAll()

        popLoginView()
    }
    
    // 注册通知 添加收到消息更新列表数据
    func registerNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateGroup(nofi:)),
                                               name: NSNotification.Name(rawValue: "updateGroupList"),
                                               object: nil)
        
    }
    
    // 查询数据并且刷新列表
    func searchAndReload() {
        // 查询聊天列表数据
        msgArray.removeAll()
        msgArray =  MessageDataManager.shareInstance.searchRealmGroupList(curr: 1)
        self.tableView.reloadData()
    }
}


extension TabChatViewController {
    
    @objc func updateGroup(nofi : Notification){
        
        // 刷新数据
        searchAndReload()

    }
    
    func setupMainView()  {
        if (LogInName != nil) {
            
            let Coun = LogInName!.count
            
            self.createNavBarView(withTitle: "\( String(LogInName!.prefix(Coun-4)))")
        }else{
            self.createNavBarView(withTitle: "消息中心")
        }
        
        self.createNavRightBtn(withItem: "退出", target: self, action: #selector(logOut))
        self.superNavBarView.backgroundColor = UIColor.commonColor()
        self.setRightTitleColro(UIColor.white)
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
    

    
    // 弹出登录视图
    func popLoginView()  {
        let vc = SelectAccountViewController()
        vc.completedBlock = {
            
            LogInName =  UserDefaults.standard.string(forKey: NICKNAME)
            // 登录完成连接服务器
            let succ = SocketManager.sharedInstanceSwift.connect()

            let Coun = LogInName!.count
            self.createNavBarView(withTitle: "欢迎-\( String(LogInName!.prefix(Coun-4)))-归来")
            
            if !succ {
                Toast.showCenterWithText(text: "连接服务器失败!!!")
                // 服务器连接失败，刷新本地数据
                self.searchAndReload()
            } else {
                Toast.showCenterWithText(text: "登录成功\(String(LogInName!.prefix(Coun-4)))")
            }

        }
        self.present(vc, animated: true, completion: nil)
        
        // 删除登录信息
        UserDefaults.standard.removeObject(forKey: NICKNAME)
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
    
    // 收到消息通知给会话页面
    func notificationToChat(_ message: Any)  {
        
        NotificationCenter.default.post(name: NSNotification.Name("chatUpdate"), object: self, userInfo: ["mess": message])
    }

}

