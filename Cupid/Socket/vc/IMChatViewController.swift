//
//  IMChatViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/19.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

private let viewBottom_Height : CGFloat =   60
private let viewBottom_H : CGFloat =  Bottom_H + 60

class IMChatViewController: ZJBaseViewController {
    
    fileprivate var isScrolling : Bool = false
    
    // 聊天列表数据
    fileprivate var  group : GroupMessage
    // 定时器
    fileprivate var heartBeatTimer : Timer?

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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.createNavBarView(withTitle:  self.group.user.name)
        self.createNavLeftBtn(withItem: "", target: self, action: #selector(backClick(button:)))
        self.setRightTitleColro(UIColor.black)
        self.setTitleColor(UIColor.white)
        self.delegate = self
        // 处理通知
        registerNotification()
        
        // 连接服务器
        connectServer()
        
        // 创建聊天tableview
        setupTableView()
        
        // 输入框
        setupChatTool()
    }
    
    // 初始化
    init(group : GroupMessage) {
        self.group  = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        heartBeatTimer?.invalidate()
        heartBeatTimer = nil
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socketClient.sendLeaveRoom()
    }

}

// MARK:- 键盘通知
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
            self.viewBottom.frame.origin.y = y - viewBottom_Height
        }
        self.tableView.frame.size.height = Screen_H-NavaBar_H - endFrame.size.height-viewBottom_Height
        // 滚动到tableview底部
        scrollToEnd()
    }
    
    @objc func keyBoardWillHide(_ notification:Notification){

        //1.获取动画执行的时间
        let duration =  notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double

        //2.执行动画
        UIView.animate(withDuration: duration) {
            self.viewBottom.frame.origin.y = Screen_H - viewBottom_H
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
        textField.becomeFirstResponder()
        btnSend.setTitle("发送", for: UIControl.State.normal)
        btnSend.addTarget(self, action: #selector(sendClick), for: UIControl.Event.touchUpInside)
        btnSend.backgroundColor = UIColor.clear
        btnSend.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnSend.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        viewBottom.addSubview(textField)
        viewBottom.addSubview(btnSend)
    }
}

// MARK:- 代理
extension IMChatViewController : UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,BaseViewControllerPangestureDelegate {
    
    func panGesture(_ pan: UIPanGestureRecognizer!) {

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msg : TextMessage = msgArray[indexPath.row]

        let count = LogInName!.count
        if String(LogInName!.prefix(count-4)) == msg.user.name {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendClick()
        return true
    }
    
}

// MARK:-连接服务器
extension IMChatViewController {
    
    func connectServer() {
        
        DispatchQueue.global().async {
            if socketClient.connectServer().isSuccess {
                print("连接会话成功")
                DispatchQueue.main.async {
                    socketClient.delegate = self
                    // 进入会话
                    socketClient.sendJoinRoom()
                    // 接受消息
                    socketClient.startReadMsg()
                    // 发送心跳包
                    self.addHeartBeatTimer()
                }
            }
        }

    }
    
    // 滚动到底部
    func scrollToEnd() {
        guard msgArray.count == 0 else {
            self.tableView.scrollToRow(at: IndexPath(item: msgArray.count-1 < 0 ? 0: msgArray.count-1, section: 0 ), at: UITableView.ScrollPosition.top, animated: false)
            return
        }

    }
}

// MARK:- socket代理
extension IMChatViewController : ZJSocketDelegate {
    
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
    
 
}

// MARK:- 给服务器发送即时消息
extension IMChatViewController {
    
    fileprivate func addHeartBeatTimer() {
        heartBeatTimer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        RunLoop.main.add(heartBeatTimer!, forMode: RunLoop.Mode.common)
    }
    
    @objc fileprivate func sendHeartBeat() {
        socketClient.sendHeartBeat()
    }
}

// MARK:- 点击事件
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
        
        socketClient.sendTextMsg(message: self.textField.text ?? "", group: group)
        self.textField.text = ""
    }
    
    
}

