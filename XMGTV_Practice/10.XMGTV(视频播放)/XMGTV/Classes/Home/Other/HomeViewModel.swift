//
//  HomeViewModel.swift
//  XMGTV
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 coderwhy. All rights reserved.
//  MVVM --> M(model)V(View)C(Controller网络请求/本地存储数据(sqlite)) --> 网络请求
// ViewModel : RAC/RxSwift




import UIKit

class HomeViewModel {
    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
    func loadHomeData(type : HomeType, index : Int,  finishedCallback : @escaping () -> ()) {
//        https://mbl.56.com/home/v5p2/homeData.ios?brepri=0&ip=125.108.154.121&poid=1&product=ios&signature=2fab1572ef15f8cb8020e3df1b8b32cb&sver=5.9.33&sysver=14.1&ts=1610616465&unid=NzY1QUJENTktNTJBOS00QjI3LUE0QUMtNjYxNkU2MTNEMzY0
        
        // 1.获取请求的地址
        let URLString = "https://mbl.56.com/home/v5p2/homeData.ios"
        
        // 2.获取请求的参数
        let parameters : [String : Any] =
            ["brepri" : "1",
             "ip" : "111.1.98.25",
             "poid" : 1,
             "product" : "ios",
             "signature" : "6aeef4225a0071c8a27f3015bce48569",
             "sver":"5.9.35",
             "sysver":"14.4",
             "ts":"1614564969",
             "unid":"NzY1QUJENTktNTJBOS00QjI3LUE0QUMtNjYxNkU2MTNEMzY0",
            ]
        
        NetworkTools.requestData(.get, URLString: URLString, parameters:parameters, finishedCallback: { (result) -> Void in

            guard let resultDict = result as? [String : Any] else { return }
            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }

            for (index, dict) in dataArray.enumerated() {
                let anchor = AnchorModel(dict: dict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }

            finishedCallback()
        })
        
        
//        NetworkTools.requestData(.get, URLString: "https://mbl.56.com/home/v5p2/homeData.ios?brepri=0&ip=125.108.154.121&poid=1&product=ios&signature=2fab1572ef15f8cb8020e3df1b8b32cb&sver=5.9.33&sysver=14.1&ts=1610616465&unid=NzY1QUJENTktNTJBOS00QjI3LUE0QUMtNjYxNkU2MTNEMzY0", parameters: nil, finishedCallback: { (result) -> Void in
//
//            guard let resultDict = result as? [String : Any] else { return }
//            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
//            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
//
//            for (index, dict) in dataArray.enumerated() {
//                let anchor = AnchorModel(dict: dict)
//                anchor.isEvenIndex = index % 2 == 0
//                self.anchorModels.append(anchor)
//            }
//
//            finishedCallback()
//        })
    }
}
