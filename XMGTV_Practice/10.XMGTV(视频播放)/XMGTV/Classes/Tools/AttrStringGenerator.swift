//
//  AttrStringGenerator.swift
//  XMGTV
//
//  Created by 小码哥 on 2016/12/17.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit
import Kingfisher

class AttrStringGenerator {
    
}


extension AttrStringGenerator {
    class func generateJoinLeaveRoom(_ username : String, _ isJoin : Bool) -> NSAttributedString {
        let roomString = "\(username) " + (isJoin ? "进入房间" : "离开房间")
        let roomMAttr = NSMutableAttributedString(string: roomString)
        roomMAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 0, length: username.count))
        
        /*
         let attachment = NSTextAttachment()
         let font = UIFont.systemFont(ofSize: 15)
         attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
         attachment.image = UIImage(named: "room_btn_gift")
         let imageAttrStr = NSAttributedString(attachment: attachment)
         joinRoomMAttr.append(imageAttrStr)
         */
        return roomMAttr
    }
    
    class func generateTextMessage(_ username : String, _ message : String) -> NSAttributedString {
        // 1.获取整个字符串
        let chatMessage = "\(username): \(message)"
        
        // 2.根据整个字符串创建NSMutableAttributedString
        let chatMsgMAttr = NSMutableAttributedString(string: chatMessage)
        
        // 3.将名称修改成橘色
        chatMsgMAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 0, length: username.count))
        
        // 4.将所有表情匹配出来, 并且换成对应的图片进行展示
        // 4.1.创建正则表达式匹配表情 我是主播[哈哈], [嘻嘻][嘻嘻] [123444534545235]
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return chatMsgMAttr }
        let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.count))
        
        // 4.2.获取表情的结果
        for i in (0..<results.count).reversed() {
            // 4.3.获取结果
            let result = results[i]
            let emoticonName = (chatMessage as NSString).substring(with: result.range)
            
            // 4.4.根据结果创建对应的图片
            guard let image = UIImage(named: emoticonName) else {
                continue
            }
            
            // 4.5.根据图片创建NSTextAttachment
            let attachment = NSTextAttachment()
            attachment.image = image
            let font = UIFont.systemFont(ofSize: 15)
            attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            let imageAttrStr = NSAttributedString(attachment: attachment)
            
            // 4.6.将imageAttrStr替换到之前文本的位置
            chatMsgMAttr.replaceCharacters(in: result.range, with: imageAttrStr)
        }
        
        return chatMsgMAttr
    }
    
    
    class func generateGiftMessage(_ giftname : String, _ giftURL : String, _ username : String) -> NSAttributedString {
        // 1.获取赠送礼物的字符串
        let sendGiftMsg = "\(username) 赠送 \(giftname) "
        
        // 2.根据字符串创建NSMutableAttributeString
        let sendGiftMAttrMsg = NSMutableAttributedString(string: sendGiftMsg)
        
        // 3.修改用户的名称
        sendGiftMAttrMsg.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 0, length: username.count))
        
        // 4.修改礼物的名称
        let range = (sendGiftMsg as NSString).range(of: giftname)
        sendGiftMAttrMsg.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: range)
        
        // 5.在最后拼接上礼物的图片
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftURL) else {
            return sendGiftMAttrMsg
        }
        let attacment = NSTextAttachment()
        attacment.image = image
        let font = UIFont.systemFont(ofSize: 15)
        attacment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        let imageAttrStr = NSAttributedString(attachment: attacment)
        
        // 6.将imageAttrStr拼接到最后
        sendGiftMAttrMsg.append(imageAttrStr)
        
        // 7.将内容显示在ChatContentView中
        return sendGiftMAttrMsg
    }
}
