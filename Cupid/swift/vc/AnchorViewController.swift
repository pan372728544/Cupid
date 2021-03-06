//
//  AnchorViewController.swift
//  Cupid
//
//  Created by panzhijun on 2019/4/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

private let kEdgeMargin : CGFloat = 8
private let kAnchorCellID = "kAnchorCellID"

private let load_more = "load_more";
private let pull = "pull";
private let enter_auto = "enter_auto";

class AnchorViewController: ZJBaseViewController {
    
    // MARK: 对外属性
    var homeType : HomeType!
    
    // MARK: 定义属性
    fileprivate lazy var homeVM : HomeViewModel = HomeViewModel()
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = WaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds , collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: kAnchorCellID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    deinit {

    }

    
}


// MARK:- 设置UI界面内容
extension AnchorViewController {
    fileprivate func setupUI() {
 
        view.addSubview(collectionView)
        
        self.collectionView.mj_header = MJDrawAnimationHeader(refreshingBlock: {
            self.loadData(type: pull)
        })

        
        self.collectionView.mj_footer = MJLoadMoreFooter(refreshingBlock: {
            self.loadData(type: load_more)
        })
        
        loadData(type: enter_auto)
        self.collectionView.mj_header.beginRefreshing()
    }
    
}

extension AnchorViewController {

}

extension AnchorViewController {
    fileprivate func loadData(type : String) {
  
        print("\(homeType.title)=========")
        homeType.typeLoad = type
        homeVM.loadHomeContentData(type: homeType, finishedCallback: {

            
            self.collectionView.mj_header.endRefreshing()
            
            self.collectionView.mj_footer.endRefreshing()
            self.collectionView.reloadData()
        })
       
    }
}

// MARK:- collectionView的数据源&代理
extension AnchorViewController : UICollectionViewDataSource, WaterfallLayoutDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return homeVM.videoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAnchorCellID, for: indexPath) as! HomeViewCell
        
        cell.videoModel = homeVM.videoModels[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomVc = PlayViewController()
        roomVc.videoModel = homeVM.videoModels[indexPath.item]
        navigationController?.pushViewController(roomVc, animated: true)
    }
    
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? Screen_W * 2 / 3 : Screen_W * 0.5
    }

}
