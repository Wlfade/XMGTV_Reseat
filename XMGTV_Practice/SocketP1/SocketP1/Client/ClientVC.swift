//
//  ClientVC.swift
//  testSocket
//
//  Created by xsj on 2021/2/10.
//

import UIKit

class ClientVC: UIViewController {

    //ip
    @IBOutlet weak var ipTF: UITextField!
    //端口
    @IBOutlet weak var portTF: UITextField!
    //消息
    @IBOutlet weak var msgTF: UITextField!
    //显示
    @IBOutlet weak var infoTV: UITextView!
    

    fileprivate lazy var userInfo: UserInfo = {
        var userInfo = UserInfo()
        userInfo.name = "摩斯_\(arc4random_uniform(10))"
        userInfo.level = Int32(arc4random() % 100)
        userInfo.iconURL = "色图"
        return userInfo
    }()
    
    fileprivate lazy var socket : HYSocket = HYSocket(addr: "192.168.1.11", port: 7878)

    fileprivate var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //对InfoTextView添加提示内容
    func addText(text: String) {
        infoTV.text = infoTV.text.appendingFormat("%@\n", text)
    }

    @IBAction func connctionAct(_ sender: Any) {
        if socket.connectServer() {
            addText(text: "链接成功")
            socket.startReadMsg()
        }else{
            addText(text: "连接失败")
        }
    }
    @IBAction func disConnection(_ sender: Any) {
      
    }
    @IBAction func sendAct(_ sender: Any) {
        
        //socket.sendJoinRoom()
        //socket.sendLeaveRoom()
        //socket.sendTextMsg(message: "nihao")
        socket.sendGifMessage(gifName: "火箭", gifUrl: "gif图", giftCount: 3)
    }
    
}
