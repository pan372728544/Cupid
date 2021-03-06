//
//  IMChatViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/19.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

private let viewBottom_Height : CGFloat =   60
private let viewBottom_H : CGFloat =  Bottom_H + 60

// 加载视图高度
private let loadingH : CGFloat =  44

private var keyboardH : CGFloat =  0
private var keyboardW : CGFloat =  0

// 每次加载多少条数据
private let page :  Int = 10

// 当前页数
private var currentPage :  Int = 1
// 最大页数
private var maxCount :  Int = 0

// 记录当前tableview偏移位置
private var tableViewoffsetY :  CGFloat = 0


private var tableViewoffsetBefore :  CGFloat = 0
private var tableViewoffsetEnd :  CGFloat = 0

class IMChatViewController: SwiftBaseViewController {
    
    fileprivate var isScrolling : Bool = false
    // 记录之前的时间c
    fileprivate var timeOld : String = ""
    // 聊天列表数据
    fileprivate var  group : GroupMessage

    // 输入框
    fileprivate lazy var textField : ChatInputTextField = {
       
        let textField =  ChatInputTextField()
        textField.frame = CGRect(x: 15, y: 8, width: Screen_W - 80 - 15, height: 44)
        textField.backgroundColor = UIColor.white
        textField.delegate = self
        return textField
    }()
    
    fileprivate lazy var titleLabel : UILabel = {
        
        let titleLabel =  UILabel()
        titleLabel.frame = CGRect(x: 0, y: StatusBar_H, width: Screen_W, height: 50)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        return titleLabel
    }()
    
    fileprivate lazy var leftBtn : UIButton = {
        
        let leftBtn =  UIButton()
        leftBtn.frame = CGRect(x: 0, y: StatusBar_H, width: 50, height: 50)
        leftBtn.setImage(UIImage(named: "back_24x24_"), for: UIControl.State.normal)
        return leftBtn
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
    
    // 输入视图
    fileprivate  var imageView : UIImageView = UIImageView()
    
    // 下拉刷新
    fileprivate var indicatorView : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: -loadingH, width: Screen_W, height: loadingH))
    
    fileprivate lazy var myView : UIView = {
        
        let myView = UIView(frame: CGRect(x: 0, y: -loadingH, width: self.view.frame.size.width, height: loadingH))
        
        myView.backgroundColor = UIColor.red
        return myView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.createNavBarView(withTitle:  self.group.user.name)
        self.createNavLeftBtn(withItem: "", target: self, action: #selector(backClick(button:)))

        currentPage = 1
    
        // 创建聊天tableview
        setupTableView()
        
        // 输入框
        setupChatTool()
        
        // 查询数据库
        searchChatLoad()
        
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;

       
    }
    
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .`default`
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

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 键盘通知
        registerNotification()
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
        
        // 收到消息后的通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateMeseage), name: NSNotification.Name(rawValue:"updataHuiHua"), object: nil)
        
  
    }
    
    //MARK:键盘通知相关操作
    @objc func keyBoardWillShow(_ notification:Notification){
        
        print("keyBoardWillShow")
        // 1.获取动画执行的时间
        let duration =  notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        // 2. 获取键盘最终的Y值
        let endFrame = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        keyboardH = endFrame.height
        keyboardW = endFrame.width

        // 3.执行动画
        UIView.animate(withDuration: duration) {
            self.viewBottom.frame.origin.y = y - viewBottom_Height
        }
        self.tableView.frame.size.height = Screen_H-NavaBar_H - endFrame.size.height-viewBottom_Height
        
        
        // 滚动到tableview底部
        scrollToEnd()
    }
    
    @objc func keyBoardWillHide(_ notification:Notification){
        print("keyBoardWillHide")
        //1.获取动画执行的时间
        let duration =  notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double

        //2.执行动画
        UIView.animate(withDuration: duration) {
            self.viewBottom.frame.origin.y = Screen_H - viewBottom_H
        }
        
        UIView.performWithoutAnimation {
            self.tableView.frame.size.height = Screen_H-NavaBar_H-viewBottom_H
        }

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
        self.tableView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        view.addSubview(self.tableView)
//        self.tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
                self.tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedRowHeight = 0
        
        
        //加载
        indicatorView.backgroundColor = UIColor.tableViewBackGroundColor()
        indicatorView.startAnimating()
        indicatorView.style = UIActivityIndicatorView.Style.gray
        self.tableView.addSubview(indicatorView)


    }
    
    func setupChatTool()  {
        
        viewBottom = UIView(frame: CGRect(x: 0, y: Screen_H-viewBottom_H, width: Screen_W, height: viewBottom_H))
        viewBottom.backgroundColor = UIColor.inputViewColor()
        view.addSubview(viewBottom)
        textField.backgroundColor = UIColor.white
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10.0
        textField.returnKeyType = .send
        btnSend.setTitle("发送", for: UIControl.State.normal)
        btnSend.addTarget(self, action: #selector(sendClick), for: UIControl.Event.touchUpInside)
        btnSend.backgroundColor = UIColor.clear
        btnSend.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btnSend.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        viewBottom.addSubview(textField)
        viewBottom.addSubview(btnSend)
        
    }
    
    func createNavBarView(withTitle : String)  {
        
        self.view.addSubview(self.titleLabel)
        self.titleLabel.text = withTitle
    }
    
    func createNavLeftBtn(withItem: String, target: Any, action: Selector)  {
        
        
        self.view.addSubview(self.leftBtn)
        self.leftBtn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    }
}

// MARK:- 代理
extension IMChatViewController : UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate {
   

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
        if msg.sendTime != "" {
            return heightOfCell(text: msg.text) + 45 + 40
        }
        return heightOfCell(text: msg.text) + 45

    }
    
    // scrollview
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.contentInset =  UIEdgeInsets(top: loadingH, left: 0, bottom: 0, right: 0 )
        if maxCount == 1 {
            indicatorView.stopAnimating()
        } else {

        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  currentPage == maxCount {
            self.tableView.contentInset.top = 0
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 滑动距离大于loading添加新的数据
        if scrollView.contentOffset.y == -loadingH {
            
            currentPage += 1
            if currentPage > maxCount {
                currentPage = maxCount
                indicatorView.stopAnimating()
                return
            } else if currentPage == maxCount {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    self.searchChatLoad()
                }
                
                indicatorView.stopAnimating()
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                
                self.searchChatLoad()
            }
            
        }
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendClick()
        return true
    }
    
}

// MARK:-
extension IMChatViewController {
    
    // 滚动到底部
    func scrollToEnd() {
        
        guard msgArray.count == 0 else {

            self.tableView.scrollToRow(at: IndexPath(item: msgArray.count-1 < 0 ? 0: msgArray.count-1, section: 0 ), at: UITableView.ScrollPosition.bottom, animated: false)
            return
        }

    }
}

// MARK:-
extension IMChatViewController  {
    
    // 通知收到消息
    func updateAndappendMessage(chatMsg: TextMessage) {
        
        print("收到服务器消息： \(String(describing: chatMsg.text))")
        msgArray.append(chatMsg)
        self.tableView.reloadData()
        scrollToEnd()
    }
    
 
}


// MARK:- 给服务器发送即时消息
extension IMChatViewController {
    func searchChatLoad(){
        
        var (msgArray,max) = MessageDataManager.shareInstance.searchRealmChatMessagesList(currentPage: currentPage, group: group)
        var index : Int = 0
        for msg in msgArray {
            
            if currentPage ==  1 {
                self.msgArray.append(msg)
                
            } else {
                self.msgArray.insert(msg, at: index)
            }
            index += 1
        }
        maxCount = max
        reloadTableView()
        
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
    
    // 发送消息
    @objc func sendClick()  {
        
        let cupid =  socketClient.sendTextMsg(message: self.textField.text ?? "", group: group)
        
        if cupid.re.isSuccess {
            print("聊天消息发送成功 \(self.textField.text)")
        } else {
            let chatMsgBuild = cupid.ch
            chatMsgBuild.success = "false"
            let chatMsg = try! chatMsgBuild.build()
            updateAndappendMessage(chatMsg: chatMsg)

            // 更新聊天列表数据库 和 插入数据到聊天记录数据库
            MessageDataManager.shareInstance.handleMsgList(chatMsg: chatMsg)
            
            // 上面已经存储数据到数据库
            MessageDataManager.shareInstance.notificationToGroupList()
        }
        // 清空数据框
        self.textField.text = ""

    }
    
    
}

extension IMChatViewController {
    
    // 数组追加数据
    @objc func updateMeseage(nofi : Notification){
        
        let message = nofi.userInfo!["mess"]
        let textMsg = message as! TextMessage
    
        updateAndappendMessage(chatMsg: textMsg)

    }
    
}

// MARK: - 数据库操作
extension IMChatViewController {
    
    
    func reloadTableView() {

        updateOffset {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
   
        }
        
    }
    
    func updateOffset(finishedCallback : @escaping () -> ())  {
        
        let oldOffset = self.tableView.contentSize.height - self.tableView.contentOffset.y
        
        finishedCallback()
        
        self.tableView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        if currentPage == 1 {
            scrollToEnd()
        }
        if oldOffset == 0 {
            return
        }
        let  offset = self.tableView.contentSize.height - oldOffset
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: offset)
        
    
    }
    
    
}
