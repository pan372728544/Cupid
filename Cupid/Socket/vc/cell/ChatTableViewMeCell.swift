//
//  ChatTableViewMeCell.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/23.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ChatTableViewMeCell: UITableViewCell {
    
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
    
    var textMes : TextMessage? {
        didSet {
            
            let url : URL =  URL(string: textMes!.user.iconUrl)!
            
            imgTou.sd_setImage(with: url)
            
            nameLabel.text = textMes?.user.name
            contentLabel.text = textMes?.text
            let heightCell =  heightOfCell(text: contentLabel.text ?? "")
            contentLabel.frame.size.height = heightCell
            
        
            if  heightCell > 20 {
                contentLabel.textAlignment = NSTextAlignment.left
            } else {
                contentLabel.textAlignment = NSTextAlignment.right
            }
            

        }
    }
    
    
}


extension ChatTableViewMeCell {
    
    func setupView()  {
        
        imgTou.frame = CGRect(x: Screen_W - 15 - 40, y: 15, width: 40, height: 40)
        self.contentView.addSubview(imgTou)
        
        nameLabel.frame = CGRect(x: imgTou.frame.origin.x - 10 - Screen_W + 100, y: 15, width: Screen_W - 100, height: 20)
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.textNameColor()
        nameLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(nameLabel)
        
        
        contentLabel.frame = CGRect(x: Screen_W - 15 - 40 - (Screen_W-100) - 10, y: nameLabel.frame.origin.y+nameLabel.frame.size.height + 10, width: Screen_W-100, height: 30)
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(contentLabel)
        
    }
    
    
    
}

extension ChatTableViewMeCell {
    
    func heightOfCell(text : String) -> CGFloat {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: CGSize(width: Screen_W - 100, height: 0), options: option, attributes: attributes, context: nil)
        print("height is \(rect.size.height)")
        return rect.size.height
    }
    
    func widthOfCell(text : String) -> CGFloat {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: CGSize(width: Screen_W - 100, height: 0), options: option, attributes: attributes, context: nil)
        return rect.size.width
    }
}
