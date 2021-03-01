//
//  NibLoadable.swift
//  05-UIView从xib中加载(POP)
//
//  Created by 小码哥 on 2016/12/10.
//  Copyright © 2016年 xmg. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}
//协议中不能 定义Class  协议相当于 struct
//在协议、结构体 中定义 类方法只能使用 static
//在类class 中才能使用 class
extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
