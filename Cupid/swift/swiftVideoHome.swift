//
//  swiftVideoHome.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/2.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class swiftVideoHome:  ZJBaseViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        
        let tableView =  UITableView(frame: CGRect(x: 0, y: 100, width: Screen_W
            , height: Screen_H-100), style: UITableView.Style.plain)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view .addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "abc")
        

    }
    

}


extension swiftVideoHome:UITableViewDelegate,UITableViewDataSource  {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell:UITableViewCell

        cell = tableView.dequeueReusableCell(withIdentifier: "abc", for: indexPath)
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "abc")
//
//        }

        cell.textLabel?.text = "cell \(indexPath.row)"
        
        return cell
    }
    
    
    
    
}
