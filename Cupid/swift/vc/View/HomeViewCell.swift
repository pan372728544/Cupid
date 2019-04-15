//
//  HomeViewCell.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewCell: UICollectionViewCell {
    
    // MARK: 控件属性
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    // MARK: 定义属性
    var videoModel : videoModel? {
        didSet {

           albumImageView.setImage(videoModel?.img_url, "")
            nickNameLabel.text = videoModel?.title
        }
    }
}
