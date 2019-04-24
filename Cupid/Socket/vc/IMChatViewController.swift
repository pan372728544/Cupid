//
//  IMChatViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/19.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit


class IMChatViewController: ZJBaseViewController {
    
    fileprivate var viewBottom_Height : CGFloat =   60
    fileprivate var viewBottom_H : CGFloat =  Bottom_H + 60
    
    fileprivate var titleNav : String
    // 服务器地址
    fileprivate var socket : ZJSocket = ZJSocket(addr: "10.2.116.69", port: 7878)
    
    // 输入框
    fileprivate lazy var textField : ChatInputTextField = {
       
        let textField =  ChatInputTextField()
        textField.frame = CGRect(x: 15, y: 8, width: Screen_W - 80 - 15, height: 44)
        textField.backgroundColor = UIColor.white
        textField.delegate = self
        return textField
    }()
    
    // 发送按钮
    fileprivate var btnSend : UIButton = UIButton(frame: CGRect(x: Screen_W-80, y: 10, width: 80, height: 44))
    
    // tableView
    fileprivate lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: NavaBar_H,
                                                   width: Screen_W,
                                                   height: Screen_H-NavaBar_H-viewBottom_H),
                                     style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.tableViewBackGroundColor()
        return tableView
    }()
    
    // 模型数组
    fileprivate var msgArray : [TextMessage] = [TextMessage]()
    
    // 输入视图
    fileprivate  var viewBottom : UIView = UIView()
    
    // 用户名
//    let name : String =  UserDefaults.standard.string(forKey: "nikeName") ?? ""

    // 设置昵称图片
//    @objc public func setNickName(str: String, type : String)  {
//        let defaults = UserDefaults.standard
//        defaults.set(str, forKey: "nikeName")
//        defaults.set(type, forKey: "type")
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.createNavBarView(withTitle: titleNav)
        self.createNavLeftBtn(withItem: "", target: self, action: #selector(backClick(button:)))
        self.setRightTitleColro(UIColor.black)
        self.delegate = self
        // 处理通知
        registerNotification()
        
        // 链接服务器
        connectServer()
        
        // 创建聊天tableview
        setupTableView()
        
        // 输入框
        setupChatTool()
    }
    

    init(titleNav : String) {
        self.titleNav = titleNav
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}

extension IMChatViewController {
    // 通知
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
        // 1.获取动画执行的时间
        let duration =  notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        // 2. 获取键盘最终的Y值
        let endFrame = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 3.执行动画
        UIView.animate(withDuration: duration) {
            self.viewBottom.frame.origin.y = y - self.viewBottom_Height
        }
        self.tableView.frame.size.height = Screen_H-NavaBar_H - endFrame.size.height-self.viewBottom_Height
        // 滚动到tableview底部
        scrollToEnd()
    }
    
    @objc func keyBoardWillHide(_ notification:Notification){
        //1.获取动画执行的时间
        let duration =  notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double

        //2.执行动画
        UIView.animate(withDuration: duration) {
            self.viewBottom.frame.origin.y = Screen_H - self.viewBottom_H
        }
        self.tableView.frame.size.height = Screen_H-NavaBar_H-viewBottom_H
    }
    
    func heightOfCell(text : String) -> CGFloat {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: CGSize(width: Screen_W - 100, height: 0), options: option, attributes: attributes, context: nil)
        return rect.size.height
    }
}

extension IMChatViewController {
    
    // 创建tableview
    func setupTableView() {
        
        self.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        self.tableView.register(ChatTableViewMeCell.self, forCellReuseIdentifier: "ChatTableViewMeCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        view.addSubview(self.tableView)
        
    }
    
    func setupChatTool()  {
        
        viewBottom = UIView(frame: CGRect(x: 0, y: Screen_H-viewBottom_H, width: Screen_W, height: viewBottom_H))
        viewBottom.backgroundColor = UIColor.inputViewColor()
        view.addSubview(viewBottom)
        textField.backgroundColor = UIColor.white
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10.0
        btnSend.setTitle("发送", for: UIControl.State.normal)
        btnSend.addTarget(self, action: #selector(sendClick), for: UIControl.Event.touchUpInside)
        btnSend.backgroundColor = UIColor.clear
        btnSend.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnSend.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        viewBottom.addSubview(textField)
        viewBottom.addSubview(btnSend)
    }
}

extension IMChatViewController : UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,BaseViewControllerPangestureDelegate {
    func panGesture(_ pan: UIPanGestureRecognizer!) {

//        print("\(pan.state)")
////        if pan.state == .began {
////            if textField.isFirstResponder {
//        textField.nextText = self.view.superview?.superview?.next
//
//            }
//        } else {
//            textField.nextText = nil
//        }
    }
    
    
    // tabview代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let msg : TextMessage = msgArray[indexPath.row]
        
        let name = UserDefaults.standard.string(forKey: NICKNAME)
        
        let Coun = name!.count

        if String(name!.prefix(Coun-4)) == msg.user.name {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewMeCell") as! ChatTableViewMeCell
            cell.textMes = msg
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
            cell.textMes = msg
            return cell
        }
 
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let msg : TextMessage = msgArray[indexPath.row]
        
        
        return heightOfCell(text: msg.text) + 60

    
    }
    

    // scrollview
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    // textfield
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendClick()
        return true
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
    
    func scrollToEnd() {
        guard msgArray.count == 0 else {
            self.tableView.scrollToRow(at: IndexPath(item: msgArray.count-1 < 0 ? 0: msgArray.count-1, section: 0 ), at: UITableView.ScrollPosition.top, animated: false)
            return
        }

    }
}

extension IMChatViewController : ZJSocketDelegate{
    func socket(_ socket: ZJSocket, groupMsg: GroupMessage) {
        
    }
    
    func socket(_ socket: ZJSocket, joinRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, leaveRoom user: UserInfo) {
        
    }
    
    func socket(_ socket: ZJSocket, chatMsg: TextMessage) {
        print("收到服务器消息： \(String(describing: chatMsg.text))")
        
        msgArray.append(chatMsg)
        self.tableView.reloadData()
        // 滚动到tableview底部
        scrollToEnd()
   
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
