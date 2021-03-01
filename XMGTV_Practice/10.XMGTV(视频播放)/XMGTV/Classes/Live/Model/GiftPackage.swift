//
//  GiftPackage.swift
//  XMGTV
//
//  Created by apple on 16/11/13.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit
@objcMembers
class GiftPackage: NSObject {
    var t : Int = 0
//    var title : String = ""
    var list : [GiftModel] = [GiftModel]()
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        print(key)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list" {
            if let listArray = value as? [[String : Any]] {
                for listDict in listArray {
                    list.append(GiftModel(dict: listDict))
                }
            }
//            print("list数量是\(list.count)")
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
