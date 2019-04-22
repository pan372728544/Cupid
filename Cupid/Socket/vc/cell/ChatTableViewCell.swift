//
//  ChatTableViewCell.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
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
            
            let defaults = UserDefaults.standard
            let name : String =  defaults.string(forKey: "nikeName") ?? ""
            if name == textMes?.user.name {
                
                imgTou.frame.origin.x = Screen_W - 15 - 40
                nameLabel.frame.origin.x = Screen_W - 15 - 40 - 100  - 10
                contentLabel.frame.origin.x = Screen_W - 15 - 40 - (Screen_W-100) - 10
                contentLabel.textAlignment = NSTextAlignment.right
                nameLabel.textAlignment = NSTextAlignment.right
            }
            else
            {
                imgTou.frame.origin.x = 15
                nameLabel.frame.origin.x = imgTou.frame.origin.x+imgTou.frame.size.width+10
                contentLabel.frame.origin.x = imgTou.frame.origin.x+imgTou.frame.size.width+10
                contentLabel.textAlignment = NSTextAlignment.left
                              nameLabel.textAlignment = NSTextAlignment.left
            }
        }
    }
    

}


extension ChatTableViewCell {
    
    func setupView()  {
        
        imgTou.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        imgTou.backgroundColor = UIColor.orange
        self.contentView.addSubview(imgTou)
        
        nameLabel.frame = CGRect(x: imgTou.frame.origin.x+imgTou.frame.size.width+10, y: 15, width: 100, height: 30)
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.randomColor()
        self.contentView.addSubview(nameLabel)
        
        
        contentLabel.frame = CGRect(x: imgTou.frame.origin.x+imgTou.frame.size.width+10, y: 15 + 30, width: Screen_W-100, height: 30)
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(contentLabel)
        
    }
    
    
    
}

extension ChatTableViewCell {
    
    func heightOfCell(text : String) -> CGFloat {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: CGSize(width: Screen_W - 100, height: 0), options: option, attributes: attributes, context: nil)
        print("height is \(rect.size.height)")
        return rect.size.height
    }
}
