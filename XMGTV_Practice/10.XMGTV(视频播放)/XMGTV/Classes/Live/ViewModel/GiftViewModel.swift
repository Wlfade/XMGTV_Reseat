//
//  GiftViewModel.swift
//  XMGTV
//
//  Created by apple on 16/11/13.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

class GiftViewModel {
    lazy var giftlistData : [GiftPackage] = [GiftPackage]()
}

extension GiftViewModel {
    func loadGiftData(finishedCallback : @escaping () -> ()) {
        // http://qf.56.com/pay/v4/giftList.ios?type=0&page=1&rows=150
        
        if giftlistData.count != 0 { finishedCallback() }
        
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/pay/v4/giftList.ios", parameters: ["type" : 0, "page" : 1, "rows" : 150], finishedCallback: { result in
            guard let resultDict = result as? [String : Any] else { return }
            
            guard let dataDict = resultDict["message"] as? [String : Any] else { return }
            
//            for i in 0..<dataDict.count {
            for i in 0..<6 {
                guard let dict = dataDict["type\(i+1)"] as? [String : Any] else { continue }
                self.giftlistData.append(GiftPackage(dict: dict))
            }
//            print("数量是\(self.giftlistData.count)")
            
            self.giftlistData = self.giftlistData.filter({ return $0.t != 0 }).sorted(by: { return $0.t > $1.t })
            
            finishedCallback()
        })
    }
}
