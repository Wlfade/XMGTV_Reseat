//
//  BaseModel.swift
//  XMGTV
//
//  Created by zy on 2021/1/13.
//

import UIKit

@objcMembers
class BaseModel: NSObject {
    override init() {
        
    }
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        
    }
}
