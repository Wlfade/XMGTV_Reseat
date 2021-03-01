//
//  EmoticonViewCell.swift
//  XMGTV
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    var emoticon : Emoticon? {
        didSet {
            iconImageView.image = UIImage(named: emoticon!.emoticonName)
        }
    }
}
