//
//  ServerVC.swift
//  testSocket
//
//  Created by xsj on 2021/2/10.
//
//protoc IMMessage.proto --swift_out="./"
import UIKit

class ServerVC: UIViewController {
    //端口
    @IBOutlet weak var portTF: UITextField!
    //消息
    @IBOutlet weak var msgTF: UITextField!
    //显示
    @IBOutlet weak var infoTV: UITextView!
    
    fileprivate lazy var severMgr : SeverManager = SeverManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    //对InfoTextView添加提示内容
    func addText(text: String) {
        infoTV.text = infoTV.text.appendingFormat("%@\n", text)
    }
    @IBAction func listeningAct(_ sender: Any) {
        severMgr.startRunning()
//        hintLabel.stringValue = "服务器已经开启ing"
        addText(text: "服务器已经开启ing")
    }
    
    @IBAction func disConnectAct(_ sender: Any) {
        severMgr.stopRunning()
        addText(text: "服务器已经关闭")
    }
    @IBAction func sendAct(_ sender: Any) {
    }
    
  
}
