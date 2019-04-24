//
//  TabChatTableViewCell.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/24.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class TabChatTableViewCell: UITableViewCell {
    internal var imgTou: UIImageView = UIImageView()
    
    internal var nameLabel : UILabel = UILabel()
    
    internal var contentLabel : UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear
        
        // 创建视图
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textMes : GroupMessage? {
        didSet {
            
            let url : URL =  URL(string: textMes!.user.iconUrl)!

            imgTou.sd_setImage(with: url)
            nameLabel.text = textMes?.user.name
            contentLabel.text = textMes?.text


        }
    }
    
    
}


extension TabChatTableViewCell {
    
    func setupView()  {
        
        imgTou.frame = CGRect(x: 15, y: 10, width: 40, height: 40)
        imgTou.contentMode = .scaleAspectFit
        self.contentView.addSubview(imgTou)
        
        nameLabel.frame = CGRect(x: imgTou.frame.origin.x+imgTou.frame.size.width+10, y: 10, width: Screen_W - 100, height: 10)
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.textNameColor()
        self.contentView.addSubview(nameLabel)
        
        contentLabel.frame = CGRect(x: imgTou.frame.origin.x+imgTou.frame.size.width+10, y: nameLabel.frame.origin.y+nameLabel.frame.size.height + 5 , width: Screen_W-100, height: 30)
        contentLabel.numberOfLines = 1
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(contentLabel)
        
    }
    
    
    
}

extension ChatTableViewCell {
    
//    public  func heightOfCell(text : String) -> CGFloat {
//        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]
//        let option = NSStringDrawingOptions.usesLineFragmentOrigin
//        let rect:CGRect = text.boundingRect(with: CGSize(width: Screen_W - 100, height: 0), options: option, attributes: attributes, context: nil)
//        return rect.size.height
//    }
}
