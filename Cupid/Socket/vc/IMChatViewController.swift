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
    
    fileprivate var textField : UITextField = UITextField(frame: CGRect(x: 15, y: 15, width: Screen_W-100, height: 44))
    
    fileprivate var btnSend : UIButton = UIButton(frame: CGRect(x: Screen_W-15-50, y: 15, width: 50, height: 44))
    
    fileprivate var tableView : UITableView = UITableView(frame: CGRect(x: 0, y: StatusBar_H+44, width: Screen_W, height: Screen_H-StatusBar_H-44), style: UITableView.Style.plain)
    
    fileprivate var msgArray : [TextMessage] = [TextMessage]()
    
    fileprivate  var viewBottom : UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createNavBarView(withTitle: "聊天内容")
        self.createNavLeftBtn(withItem: "", target: self, action: #selector(backClick(button:)))
        self.setRightTitleColro(UIColor.black)
        
        // 处理通知
    
       registerNotification()
     
        // 链接服务器
        connectServer()
    
        // 创建聊天tableview
        setupTableView()
        
//        setupTextField()
        setupChatTool()
    }
    deinit {
    NotificationCenter.default.removeObserver(self)
    }


}

extension IMChatViewController {
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow(_ :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    //MARK:键盘通知相关操作
    @objc func keyBoardWillShow(_ notification:Notification){
        //1.获取动画执行的时间
        let duration =  notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        //2. 获取键盘最终的Y值
        let endFrame = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        //3.执行动画
        UIView.animate(withDuration: duration) {
            self.viewBottom.frame.origin.y = y - 49 - 30
        }
    }
    
    @objc func keyBoardWillHide(_ notification:Notification){
        //1.获取动画执行的时间
        let duration =  notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double

        //2.执行动画
        UIView.animate(withDuration: duration) {
            self.viewBottom.frame.origin.y = Screen_H - Tabbar_H
        }
    }

}

extension IMChatViewController {
    
    func setupTableView() {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableView")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        view.addSubview(self.tableView)
        
    }
    func setupChatTool()  {
        
        
        viewBottom = UIView(frame: CGRect(x: 0, y: Screen_H-Tabbar_H, width: Screen_W, height: Tabbar_H))
        
        viewBottom.backgroundColor = UIColor.randomColor()
        view.addSubview(viewBottom)
        
        
        textField.backgroundColor = UIColor.lightGray
        btnSend.setTitle("发送", for: UIControl.State.normal)
        btnSend.addTarget(self, action: #selector(sendClick), for: UIControl.Event.touchUpInside)
        btnSend.backgroundColor = UIColor.clear
        btnSend.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnSend.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        viewBottom.addSubview(textField)
        viewBottom.addSubview(btnSend)
    }
}

extension IMChatViewController : UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    

    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "tableView")
        
        
        
        let msg : TextMessage = msgArray[indexPath.row]
        
        cell.textLabel!.text = msg.text
        cell.detailTextLabel?.text = msg.user.name
        
        cell.imageView?.image = UIImage.init(named: "tabbar_publish_article_34x34_")
        
        return cell
    }
    
 
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
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
        self.textField.text = ""
    }
    
    
}
