//
//  ChatToolsView.swift
//  XMGTV
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

protocol ChatToolsViewDelegate : class {
    func chatToolsView(toolView : ChatToolsView, message : String)
}

class ChatToolsView: UIView, NibLoadable {
    
    weak var delegate : ChatToolsViewDelegate?
    
    fileprivate lazy var emoticonBtn : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    fileprivate lazy var emoticonView : EmoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 250))
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendMsgBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    @IBAction func textFieldDidEdit(_ sender: UITextField) {
//        sendMsgBtn.isEnabled = sender.text!.characters.count != 0
        sendMsgBtn.isEnabled = sender.text!.count != 0

    }
    
    @IBAction func sendBtnClick(_ sender: UIButton) {
        // 1.获取内容
        let message = inputTextField.text!
        
        // 2.清空内容
        inputTextField.text = ""
        sender.isEnabled = false
        
        // 3.将内容回调出去
        delegate?.chatToolsView(toolView: self, message: message)
    }
}


extension ChatToolsView {
    fileprivate func setupUI() {
        
        // 0.测试: 让textFiled显示`富文本`
        /*
        let attrString = NSAttributedString(string: "I am fine", attributes: [NSForegroundColorAttributeName : UIColor.green])
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "[大哭]")
        let attrStr = NSAttributedString(attachment: attachment)
        inputTextField.attributedText = attrStr
        */
        
        
        // 1.初始化inputView中rightView
        emoticonBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emoticonBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emoticonBtn.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        
        inputTextField.rightView = emoticonBtn
        inputTextField.rightViewMode = .always
        inputTextField.allowsEditingTextAttributes = true
        
        // 2.设置emotionView的闭包(weak当对象销毁值, 会自动将指针指向nil)
        // weak var weakSelf = self
        emoticonView.emoticonClickCallback = {[weak self] emoticon in
            // 1.判断是否是删除按钮
            if emoticon.emoticonName == "delete-n" {
                self?.inputTextField.deleteBackward()
                return
            }
            
            // 2.获取光标位置
            guard let range = self?.inputTextField.selectedTextRange else { return }
            self?.inputTextField.replace(range, withText: emoticon.emoticonName)
        }
    }
}

extension ChatToolsView {
    @objc fileprivate func emoticonBtnClick(_ btn : UIButton) {
        btn.isSelected = !btn.isSelected
        
        // 切换键盘
        let range = inputTextField.selectedTextRange
        inputTextField.resignFirstResponder()
        inputTextField.inputView = inputTextField.inputView == nil ? emoticonView : nil
        inputTextField.becomeFirstResponder()
        inputTextField.selectedTextRange = range
    }
}
