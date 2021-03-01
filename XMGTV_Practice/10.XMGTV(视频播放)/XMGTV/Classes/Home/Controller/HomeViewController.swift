//
//  HomeViewController.swift
//  XMGTV
//
//  Created by zy on 2021/1/11.
//

import UIKit

class HomeViewController: UIViewController {

    fileprivate lazy var severMgr : SeverManager = SeverManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
//        view.backgroundColor = UIColor.randomColor()
    }
}
// MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupUI() {
        setupNavigationBar()
        setupContentView()
    }
    
    fileprivate func setupNavigationBar() {
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: #selector(listeningAct))
        
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(collectItemClick))
        
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        
        //奔溃 api UISearchBar's _searchField ivar is prohibited. This is an application bug'
//        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
//        searchFiled?.textColor = UIColor.white

        
        // 替代方案 1，使用 iOS 13 的新属性 searchTextField
//        searchBar.searchTextField.textColor = UIColor.white
        
        searchBar.searchTextField.textColor = UIColor(named: "red")
        

        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    
    fileprivate func setupContentView() {
        // 1.获取数据
        let homeTypes = loadTypesData()
        
        // 2.创建主题内容
        let style = HYTitleStyle()
        style.isScrollEnable = true
        style.isShowBottomLine = true
        let pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 44)
        /*
        var titles = [String]()
        for type in homeTypes {
            titles.append(type.title)
        }
        */
        
        /*
        let titles = homeTypes.map { (type : HomeType) -> String in
            return type.title
        }
        */
        let titles = homeTypes.map({ $0.title })
        var childVcs = [AnchorViewController]()
        for type in homeTypes {
            let anchorVc = AnchorViewController()
            anchorVc.homeType = type
            childVcs.append(anchorVc)
        }
        let pageView = HYPageView(frame: pageFrame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
    }
    
    fileprivate func loadTypesData() -> [HomeType] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        var tempArray = [HomeType]()
        for dict in dataArray {
            tempArray.append(HomeType(dict: dict))
        }
        return tempArray
    }
}


// MARK:- 事件监听函数
extension HomeViewController {
    @objc fileprivate func listeningAct() {
        print("开启服务器")
        severMgr.startRunning()
    }
    @objc fileprivate func collectItemClick() {
        print("关闭服务器")
        severMgr.stopRunning()

    }

}
