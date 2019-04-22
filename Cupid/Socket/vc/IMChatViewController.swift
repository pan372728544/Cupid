//
//  IMChatViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/19.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit


class IMChatViewController: ZJBaseViewController {
    
//    fileprivate lazy var serverMgr : ServerManager = ServerManager()
    
    fileprivate var socket : ZJSocket = ZJSocket(addr: "10.2.116.26", port: 7878)
    
    fileprivate var textField : UITextField = UITextField(frame: CGRect(x: 0, y: 300, width: Screen_W, height: 44))
    
    fileprivate var btnSend : UIButton = UIButton(frame: CGRect(x: 0, y: 355, width: 100, height: 44))
    
    fileprivate var tableView : UITableView = UITableView(frame: CGRect(x: 0, y: StatusBar_H+44, width: Screen_W, height: Screen_H-StatusBar_H-44), style: UITableView.Style.plain)
    
    fileprivate var msgArray : [TextMessage] = [TextMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createNavBarView(withTitle: "聊天内容")
        self.createNavLeftBtn(withItem: "", target: self, action: #selector(backClick(button:)))
        self.setRightTitleColro(UIColor.black)
        
        // 链接服务器
        connectServer()
        
        
        
    
        
        setupTableView()
        
        setupTextField()
    }
    deinit {

    }


}

extension IMChatViewController : UITableViewDataSource,UITableViewDelegate {
    
    func setupTextField()  {
        textField.backgroundColor = UIColor.orange
        btnSend.setTitle("发送", for: UIControl.State.normal)
        btnSend.addTarget(self, action: #selector(sendClick), for: UIControl.Event.touchUpInside)
        btnSend.backgroundColor = UIColor.blue
        self.view.addSubview(textField)
        self.view.addSubview(btnSend)
    }
    
    func setupTableView() {
        
      self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableView")
        self.tableView.delegate = self
        self.tableView.dataSource = self
      view.addSubview(self.tableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "tableView")!
//        let cell = tableView.de
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "tableView")
        
        
        
        let msg : TextMessage = msgArray[indexPath.row]
        
        cell.textLabel!.text = msg.text
        cell.detailTextLabel?.text = msg.user.name
        
        cell.imageView?.image = UIImage.init(named: "tabbar_publish_article_34x34_")
        
        return cell
    }
    
    
 
}

extension IMChatViewController {
    
    func connectServer() {
        if socket.connectServer().isSuccess {
            print("连接成功")
            socket.delegate = self
            
            socket.startReadMsg()
        }
        
    }
}

extension IMChatViewController : ZJSocketDelegate{
    func socket(_ socket: ZJSocket, joinRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, leaveRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, chatMsg: TextMessage) {
        print("收到服务器消息： \(String(describing: chatMsg.text))")
        
        msgArray.append(chatMsg)
        self.tableView.reloadData()
    }
    
    func socket(_ socket: ZJSocket, giftMsg: GiftMessage) {
        
    }
    
 
}

extension IMChatViewController {

    // 返回上一页面
    @objc func backClick(button : UIButton)  {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 设置服务器
    @objc func settingIM()  {
        let status = IMStatusViewController()
        status.heightTop = CGFloat(Screen_H-400)
        self.navigationController?.present(status, animated: true, completion: nil)

        
    }
    
    
    @objc func sendClick()  {
        
        socket.sendTextMsg(message: self.textField.text ?? "空的消息")
//        socket.startReadMsg()
    }
    
    
}
