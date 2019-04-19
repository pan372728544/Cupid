//
//  IMChatViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/19.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class IMChatViewController: ZJBaseViewController {
    
    fileprivate lazy var serverMgr : ServerManager = ServerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createNavBarView(withTitle: "聊天内容")
        self.createNavLeftBtn(withItem: "", target: self, action: #selector(backClick(button:)))
        self.createNavRightBtn(withItem: "链接状态", target: self, action: #selector(settingIM))
        self.setRightTitleColro(UIColor.black)
        
        // 开启链接
        connectServer()
    }
    deinit {
        serverMgr.stopRunning()
    }


}

extension IMChatViewController {
    
    func connectServer() {
        let result = serverMgr.startRunning()
        
        switch result {
        case .success:
            self.createNavBarView(withTitle: "聊天内容(连接成功)")
        case .failure(nil):
            self.createNavBarView(withTitle: "聊天内容(失去连接)")
        default:
            self.createNavBarView(withTitle: "聊天内容(失去连接)")
        }
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
}
