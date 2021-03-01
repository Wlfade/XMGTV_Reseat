//
//  ClientTwoVC.swift
//  SocketP1
//
//  Created by xsj on 2021/2/21.
//

import UIKit

/*
 1.获取到服务器对应的IP/端口号
 2.使用socket,通过IP/端口号和服务器建立连接
 3.开启定时器，实时让服务器发送心跳包
 4.通过sendMsg，给服务器发送消息：字节流 --> headerData(消息长度) + typeData(消息类型) + MsgData(真正的消息)
 5.读取从服务器传送过来的消息（开启子线程）
 */

class ClientTwoVC: UIViewController {
    fileprivate lazy var socket : HYSocket = HYSocket(addr: "192.168.1.11", port: 7878)

    @IBOutlet weak var textFd: UITextField!
    @IBOutlet weak var textTV: UITextView!
    fileprivate var timer: Timer!
    fileprivate var heartTimeCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    deinit {
        timer.invalidate()
        timer = nil
    }
    //对InfoTextView添加提示内容
    func addText(text: String) {
        textTV.text = textTV.text.appendingFormat("%@\n", text)
    }
    
    @IBAction func JoinRoomAction(_ sender: Any) {
        if socket.connectServer() {
            socket.startReadMsg()
            socket.sendJoinRoom()
            socket.delete = self
            
            DispatchQueue.main.async {
                self.addText(text: "链接成功")
            }
            
            timer = Timer(fireAt: Date(timeIntervalSinceNow: 4), interval: 1, target: self, selector: #selector(checkHeartBeat), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .common)

        }else{
            DispatchQueue.main.async {
                self.addText(text: "连接失败")
            }
        }


    }
    
    @IBAction func LeaveRoomAction(_ sender: Any) {
        socket.sendLeaveRoom()
    }
    @IBAction func SendTextAction(_ sender: Any) {
//        let str = textFd.text
        if textFd.text!.count > 0 {
            socket.sendTextMsg(message: textFd.text!)
        }
    }
    
    @IBAction func SendGiftAction(_ sender: Any) {
        socket.sendGifMessage(gifName: "火箭", gifUrl: "gif图", giftCount: 3)
    }
    
}
extension ClientTwoVC : HYSocketDelegate{
    func socket(_ socket : HYSocket, joinRoom user : UserInfo){
        
        DispatchQueue.main.async {
            self.addText(text: user.name + "加入房间")
        }
    }
    func socket(_ socket : HYSocket, leaveRoom user : UserInfo){
        DispatchQueue.main.async {
            self.addText(text: user.name + "离开房间")
        }
    }
    func socket(_ socket : HYSocket, chatMsg : ChatMessage){
        DispatchQueue.main.async {
            self.addText(text: chatMsg.text)
        }
    }
    func socket(_ socket : HYSocket, giftMsg : GiftMessage){
        DispatchQueue.main.async {
            self.addText(text: giftMsg.giftname)
        }
    }

}
extension ClientTwoVC{
    @objc fileprivate func checkHeartBeat () {
        socket.sendHeartBeat()
    }
}

