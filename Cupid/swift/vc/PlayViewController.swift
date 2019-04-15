//
//  PlayViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import AVKit

class PlayViewController: ZJBaseViewController {
    
    var videoModel : videoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    


}


extension PlayViewController {
    
    func setupUI() -> Void {
        
        print("\(videoModel.videoUrl)")
        let player = AVPlayer(url: NSURL(string: videoModel.videoUrl)! as URL)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = CGRect(x: 0, y: 0, width:Screen_W, height: Screen_H)
        self.addChild(playerViewController)
        self.view.addSubview(playerViewController.view)
        player.play()
    }
    
}
