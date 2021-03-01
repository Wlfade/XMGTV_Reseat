//
//  HYPageCollectionViewLayout.swift
//  HYPageView
//
//  Created by zy on 2021/1/18.
//

import UIKit

class HYPageCollectionViewLayout: UICollectionViewFlowLayout {
    
    var cols : Int = 4  //默认列数
    var rows : Int = 2  //默认行数
    
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxWidth : CGFloat = 0
}


extension HYPageCollectionViewLayout {
    override func prepare() {
        super.prepare()
        
        // 0.计算item宽度&高度
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1)) / CGFloat(rows)
        
        // 1.获取一共多少组
        let sectionCount = collectionView!.numberOfSections
        
        // 2.获取每组中有多少个Item
        var prePageCount : Int = 0
        //先遍历组数 sectionCount
        for i in 0..<sectionCount {
            //获取每组的个数 rowCount
            let itemCount = collectionView!.numberOfItems(inSection: i)
            for j in 0..<itemCount {
                // 2.1.获取Cell对应的indexPath
                let indexPath = IndexPath(item: j, section: i)
                
                // 2.2.根据indexPath创建UICollectionViewLayoutAttributes
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // 2.3.计算j在该组中第几页
                let page = j / (cols * rows)
                let index = j % (cols * rows)
                
                // 2.3.设置attr的frame
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / cols)
                let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                // 2.4.保存attr到数组中
                cellAttrs.append(attr)
            }
            
            prePageCount += (itemCount - 1) / (cols * rows) + 1
        }
        
        
        // 3.计算最大宽度
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }
}


extension HYPageCollectionViewLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}


extension HYPageCollectionViewLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: 0)
    }
}
