//
//  IMStatusViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/19.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class IMStatusViewController: ZJBasePresentViewController {

    fileprivate lazy var statusLabel : UILabel = UILabel()
    fileprivate lazy var serverLabel : UILabel = UILabel()
    fileprivate lazy var serverStatusLabel : UILabel = UILabel()
    fileprivate lazy var switchButton : UISwitch = UISwitch()
    
    
//      fileprivate lazy var serverMgr : ServerManager = ServerManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        setupView()
    }
    



}

extension IMStatusViewController {
    
    func setupView()  {
        
        statusLabel.frame = CGRect(x: 0, y: 0, width: Screen_W, height: 44)
        statusLabel.text = "服务器链接状态"
        statusLabel.textAlignment = NSTextAlignment.center
        statusLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(statusLabel)
        
        serverLabel.frame = CGRect(x: 0, y: statusLabel.frame.origin.y+statusLabel.frame.size.height + 50, width: Screen_W, height: 44)
        serverLabel.text = "打开关闭服务器设置"
        serverLabel.textAlignment = NSTextAlignment.center
        serverLabel.font = UIFont.systemFont(ofSize: 14)
        serverLabel.backgroundColor = UIColor.randomColor()
        self.view.addSubview(serverLabel)
        
        
        switchButton.frame = CGRect(x: 30, y: serverLabel.frame.origin.y+serverLabel.frame.size.height + 50, width: 100, height: 44)
        switchButton.isOn = false
        switchButton.addTarget(self, action: #selector(switchClick), for: .touchUpInside)
        self.view.addSubview(switchButton);
        
        serverStatusLabel.frame = CGRect(x: 130, y: serverLabel.frame.origin.y+serverLabel.frame.size.height + 50, width: Screen_W, height: 44)
        serverStatusLabel.text = "服务器未连接"
        serverStatusLabel.textAlignment = NSTextAlignment.left
        serverStatusLabel.font = UIFont.systemFont(ofSize: 14)
        serverStatusLabel.textColor = UIColor.red
        self.view.addSubview(serverStatusLabel)
        

    }
    
    @objc func switchClick()  {
        
//        if switchButton.isOn {
//            let result = serverMgr.startRunning()
//            
//            switch result {
//            case .success:
//                serverStatusLabel.text = "服务器链接成功"
//            case .failure(nil):
//                serverStatusLabel.text = "服务器未连接--连接失败"
//                switchButton.isOn = false
//            default:
//                serverStatusLabel.text = "服务器未连接--连接失败"
//                switchButton.isOn = false
//            }
//            
//        }else{
//            
//            serverMgr.stopRunning()
//            serverStatusLabel.text = "服务器未连接"
//   
//          
//        }
        
    }
    
    
}
