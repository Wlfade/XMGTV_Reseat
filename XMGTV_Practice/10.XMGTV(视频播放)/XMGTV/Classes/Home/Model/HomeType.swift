//
//  HomeType.swift
//  XMGTV
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

//class HomeType: BaseModel {
//    @objc var title : String = "偶像派"
//    @objc var type : Int = 0
//}

@objcMembers
class HomeType: NSObject {
     var title : String = ""
     var type : Int = 0
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key)
    }
}

