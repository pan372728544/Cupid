//
//  TestViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/24.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

//    var titleA : String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var param:String?
    
    init(param: String) {
        self.param = param
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
