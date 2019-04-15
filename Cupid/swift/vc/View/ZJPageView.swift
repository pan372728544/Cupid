//
//  ZJPageView.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit


class ZJPageView: UIView {
    
    // MARK: 定义属性
    fileprivate var titles : [String]!
    fileprivate var style : ZJTitleStyle!
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    
    fileprivate var titleView : ZJTitleView!
    fileprivate var contentView : ZJContentView!
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles : [String], style : ZJTitleStyle, childVcs : [UIViewController], parentVc : UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ZJPageView {
    fileprivate func setupUI() {
        let titleH : CGFloat = 44
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = ZJTitleView(frame: titleFrame, titles: titles, style : style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = ZJContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}

// MARK:- 设置ZJContentView的代理
extension ZJPageView : ZJContentViewDelegate {
    func contentView(_ contentView: ZJContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
        
        
    }
    
    func contentViewEndScroll(_ contentView: ZJContentView) {
        titleView.contentViewDidEndScroll()
    }
}


// MARK:- 设置ZJTitleView的代理
extension ZJPageView : ZJTitleViewDelegate {
    func titleView(_ titleView: ZJTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}
