//
//  ChatTableViewMeCell.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/23.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ChatTableViewMeCell: UITableViewCell {
    
    
    internal var timeLabel : UILabel = UILabel()
    
    internal var imgTou: UIImageView = UIImageView()
    
    internal var nameLabel : UILabel = UILabel()
    
    internal var contentLabel : UILabel = UILabel()
    
    // 气泡
    internal var imgPao: UIImageView = UIImageView()
    
    // 发送失败图片
    internal var imgFaild: UIImageView = UIImageView()
    
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
            timeLabel.isHidden = true
            if textMes?.sendTime != "" {
                timeLabel.text = textMes?.sendTime
                timeLabel.isHidden = false
            }

            imgTou.image = UIImage.init(named: textMes!.user.iconUrl)
            imgTou.frame.origin.y = textMes?.sendTime != nil ? 15+40 : 15
            
            nameLabel.text = textMes?.user.name
            nameLabel.frame.origin.y = imgTou.frame.origin.y
            contentLabel.text = textMes?.text
            let heightCell =  heightOfCell(text: contentLabel.text ?? "")
            let widthCell = widthOfCell(text: contentLabel.text ?? "")
            
            contentLabel.frame.size.height = heightCell
            contentLabel.frame.size.width = widthCell
//            contentLabel.frame = CGRect(x: Screen_W-15-40-10-widthCell-10+4, y: nameLabel.frame.origin.y+nameLabel.frame.size.height + 10+1.5 , width: widthCell, height: heightCell)
            contentLabel.frame = CGRect(x: Screen_W-15-40-10-widthCell-10+4, y: imgTou.frame.origin.y+10+1.5 , width: widthCell, height: heightCell)
            let oriImg = UIImage.init(named: "sendchat")
            
            let edgeInsets = UIEdgeInsets(top: oriImg!.size.height*0.7, left: oriImg!.size.width*0.3, bottom: oriImg!.size.height*0.29, right: oriImg!.size.width*0.3)
            
            
            let resiImg = oriImg!.resizableImage(withCapInsets: edgeInsets, resizingMode: UIImage.ResizingMode.stretch)
            // 计算图片尺寸
            imgPao.frame = CGRect(x: Screen_W-15-40-10-widthCell - 18  , y: imgTou.frame.origin.y , width: widthCell + 25, height: heightCell + 30)
            imgPao.image = resiImg

            if  heightCell > 20 {
                contentLabel.textAlignment = NSTextAlignment.left
            } else {
                contentLabel.textAlignment = NSTextAlignment.right
            }

            imgFaild.frame = CGRect(x: imgPao.frame.origin.x-15, y: imgPao.frame.origin.y + 4, width: 20, height: 20)
            imgFaild.isHidden = textMes?.success == "true"

        }

    }
    
    var isSuccess: Bool?  {
        didSet {
            imgFaild.frame = CGRect(x: imgPao.frame.origin.x-15, y: imgPao.frame.origin.y + 4, width: 20, height: 20)
            
            imgFaild.isHidden = isSuccess!
            }
    }
    
    
}


extension ChatTableViewMeCell {
    
    func setupView()  {
        timeLabel.frame = CGRect(x: 0, y: 10, width: Screen_W, height: 40)
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = UIColor.textNameColor()
        self.contentView.addSubview(timeLabel)
        imgTou.frame = CGRect(x: Screen_W - 15 - 40, y: 15 , width: 40, height: 40)
        imgTou.contentMode = .scaleAspectFill
        imgTou.clipsToBounds = true
        self.contentView.addSubview(imgTou)
        

        
        nameLabel.frame = CGRect(x: imgTou.frame.origin.x - 10 - Screen_W + 100, y: 15, width: Screen_W - 100, height: 20)
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.textNameColor()
        nameLabel.textAlignment = NSTextAlignment.right
        nameLabel.isHidden = true
        self.contentView.addSubview(nameLabel)
        
        
        imgPao.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
        self.contentView.addSubview(imgPao)
      
        imgFaild.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        imgFaild.image = UIImage.init(named: "MessageListSendFail~iphone")
        imgFaild.isHidden = true
        self.contentView.addSubview(imgFaild)
        
        contentLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textAlignment = NSTextAlignment.right
//        contentLabel.backgroundColor = UIColor.randomColor()
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
