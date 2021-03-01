//
//  ChatContentCell.swift
//  XMGTV
//
//  Created by 小码哥 on 2016/12/17.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

class ChatContentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.white
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
    }
    
}
