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
    
    // 气泡
    internal var imgPao: UIImageView = UIImageView()
    
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
            
            //            imgTou.sd_setImage(with: url)
            imgTou.image = UIImage.init(named: textMes!.user.iconUrl)
            
            nameLabel.text = textMes?.user.name
            contentLabel.text = textMes?.text
            let heightCell =  heightOfCell(text: contentLabel.text ?? "")
            let widthCell = widthOfCell(text: contentLabel.text ?? "")
            
            contentLabel.frame.size.height = heightCell
            contentLabel.frame.size.width = widthCell
            contentLabel.frame = CGRect(x: Screen_W-15-40-10-widthCell-5, y: nameLabel.frame.origin.y+nameLabel.frame.size.height + 10, width: widthCell, height: heightCell)
            
            let oriImg = UIImage.init(named: "sendchat")
            
            let edgeInsets = UIEdgeInsets(top: oriImg!.size.height*0.7, left: oriImg!.size.width*0.3, bottom: oriImg!.size.height*0.29, right: oriImg!.size.width*0.3)
            
            
            let resiImg = oriImg!.resizableImage(withCapInsets: edgeInsets, resizingMode: UIImage.ResizingMode.stretch)
            // 计算图片尺寸
            imgPao.frame = CGRect(x: Screen_W-15-40-10-widthCell - 20, y: nameLabel.frame.origin.y+nameLabel.frame.size.height , width: widthCell + 25, height: heightCell + 30)
            imgPao.image = resiImg

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
        
        
        imgPao.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
        self.contentView.addSubview(imgPao)
      
        
        contentLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
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

        return rect.size.height
    }
    
    func widthOfCell(text : String) -> CGFloat {
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: CGSize(width: Screen_W - 100, height: 0), options: option, attributes: attributes, context: nil)
        return rect.size.width
    }
}
