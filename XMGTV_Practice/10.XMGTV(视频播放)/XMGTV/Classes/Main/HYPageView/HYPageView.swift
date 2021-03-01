//
//  HYPageView.swift
//  HYPageView
//
//  Created by zy on 2021/1/12.
//

import UIKit

class HYPageView: UIView {

    // MARK: 定义属性
    fileprivate var titles : [String]!
    fileprivate var style : HYTitleStyle!
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    
    fileprivate var titleView : HYTitleView!
    fileprivate var contentView : HYContentView!

    
    init(frame: CGRect, titles : [String], style : HYTitleStyle, childVcs : [UIViewController], parentVc : UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
//        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
// MARK:- 设置UI界面
extension HYPageView {
    fileprivate func setupUI() {
//        setupTitleView()
//        setupContentView()
        
        let titleH : CGFloat = 44
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = HYTitleView(frame: titleFrame, titles: titles, style : style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = HYContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
    
//    private func setupTitleView() {
//        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
//        titleView = HYTitleView(frame: titleFrame, titles: titles,style: style)
//        addSubview(titleView)
//        titleView.backgroundColor = UIColor.randomColor()
//    }
//
//    private func setupContentView() {
//        // ?.取到类型一定是可选类型
//        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
//        let contentView = HYContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
//        addSubview(contentView)
//        contentView.backgroundColor = UIColor.randomColor()
//        // 2.contentView&titleView代理设置
//        titleView.delegate = self
//        contentView.delegate = titleView
//    }
}

// MARK:- 设置HYContentView的代理
extension HYPageView : HYContentViewDelegate {
    func contentView(_ contentView: HYContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: HYContentView) {
        titleView.contentViewDidEndScroll()
    }
}


// MARK:- 设置HYTitleView的代理
extension HYPageView : HYTitleViewDelegate {
    func titleView(_ titleView: HYTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}
