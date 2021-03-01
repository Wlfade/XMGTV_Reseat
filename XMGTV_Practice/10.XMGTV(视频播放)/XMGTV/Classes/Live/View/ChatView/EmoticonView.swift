//
//  EmoticonView.swift
//  XMGTV
//
//  Created by 小码哥 on 2016/12/11.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

private let kEmoticonCellID = "kEmoticonCellID"

class EmoticonView: UIView {
    
    var emoticonClickCallback : ((Emoticon) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension EmoticonView {
    fileprivate func setupUI() {
        // 1.创建HYPageCollectionView
        let style = HYTitleStyle()
        style.isShowBottomLine = true
        let layout = HYPageCollectionViewLayout()
        layout.cols = 7
        layout.rows = 3
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let pageCollectionView = HYPageCollectionView(frame: bounds, titles: ["普通", "粉丝专属"], style: style, isTitleInTop: false, layout: layout)
        
        // 2.将pageCollectionView添加到view中
        addSubview(pageCollectionView)
        
        // 3.设置pageCollectionView的属性
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.register(nib: UINib(nibName: "EmoticonViewCell", bundle: nil), identifier: kEmoticonCellID)
    }
}


extension EmoticonView : HYPageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: HYPageCollectionView) -> Int {
        return EmoticonViewModel.shareInstance.packages.count
    }
    
    func pageCollectionView(_ collectionView: HYPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonViewModel.shareInstance.packages[section].emoticons.count
    }
    
    func pageCollectionView(_ pageCollectionView: HYPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! EmoticonViewCell
        cell.emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
}


extension EmoticonView : HYPageCollectionViewDelegate {
    func pageCollectionView(_ pageCollectionView: HYPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        if let emoticonClickCallback = emoticonClickCallback {
            emoticonClickCallback(emoticon)
        }
    }
}
