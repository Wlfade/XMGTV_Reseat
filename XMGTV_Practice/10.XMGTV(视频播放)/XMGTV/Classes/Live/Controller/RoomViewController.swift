//
//  LiveViewController.swift
//  XMGTV
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit
import IJKMediaFramework

private let kChatToolsViewHeight : CGFloat = 44
private let kGiftlistViewHeight : CGFloat = kScreenH * 0.5
private let kChatContentViewHeight : CGFloat = 200

class RoomViewController: UIViewController,Emitterable{
    
    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    
    fileprivate lazy var chatToolsView : ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftListView : GiftListView = GiftListView.loadFromNib()
    
    fileprivate lazy var chatContentView : ChatContentView = ChatContentView.loadFromNib()

    fileprivate lazy var socket : HYSocket = HYSocket(addr: "192.168.1.11", port: 7878)
    fileprivate var heartBeatTimer : Timer?

    var anchor : AnchorModel?
    
    fileprivate var ijkPlayer : IJKFFMoviePlayerController?
    // MARK: 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // 3.连接聊天服务器
        if socket.connectServer() {
            print("连接成功")
            socket.startReadMsg()
            addHeartBeatTimer()
            socket.sendJoinRoom()
            socket.delete = self
        }
        loadAnchorLiveAddress()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socket.sendLeaveRoom()
        invalidateTimer()
        ijkPlayer?.shutdown()

    }
    deinit {
        invalidateTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    func invalidateTimer(){
        heartBeatTimer?.invalidate()
        heartBeatTimer = nil
    }

}


// MARK:- 设置UI界面内容
extension RoomViewController {
    fileprivate func setupUI() {
        setupBlurView()
        setupBottomView()
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    fileprivate func setupBottomView(){
        
        // 0.设置Chat内容的View
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - 44 - kChatContentViewHeight, width: view.bounds.width, height: kChatContentViewHeight)
        chatContentView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.addSubview(chatContentView)
        
        // 1.设置chatToolsView
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        //添加约束
        chatToolsView.autoresizingMask = [.flexibleTopMargin,.flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        //2.设置giftListView
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(giftListView)
        giftListView.delegate = self
    }
}

// MARK:- 请求主播信息
extension RoomViewController {
    fileprivate func loadAnchorLiveAddress() {
        
//        // 1.获取请求的地址
//        let URLString = "http://qf.56.com/play/v2/preLoading.ios"
//
//        // 2.获取请求的参数
//        let parameters : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056", "signature" : "f69f4d7d2feb3840f9294179cbcb913f", "roomId" : anchor!.roomid, "userId" : anchor!.uid]
        
        // 1.获取请求的地址
        let URLString = "https://mbl.56.com/play/v9/preLoading.ios"
        
        // 2.获取请求的参数
        let parameters : [String : Any] =
            ["brepri" : "1",
             "ip" : "111.1.98.25",
             "poid" : 1,
             "product" : "ios",
             "signature" : "6aeef4225a0071c8a27f3015bce48569",
             "sver":"5.9.35",
             "sysver":"14.4",
             "ts":"1614564969",
             "unid":"NzY1QUJENTktNTJBOS00QjI3LUE0QUMtNjYxNkU2MTNEMzY0",
             "roomId" : anchor!.roomid,
             "userId" : anchor!.uid]
        
        NetworkTools.requestData(.get, URLString: URLString, parameters: parameters, finishedCallback: { result in
            
            print(result)
            
            // 1.将result转成字典类型
            let resultDict = result as? [String : Any]
            
            // 2.从字典中取出数据
            let infoDict = resultDict?["message"] as? [String : Any]
            
            // 3.获取请求直播地址的URL
            guard let rURL = infoDict?["rUrl"] as? String else { return }
            
            // 4.请求直播地址
            NetworkTools.requestData(.get, URLString: rURL, finishedCallback: { (result) in
                let resultDict = result as? [String : Any]
                let liveURLString = resultDict?["url"] as? String
                
                self.displayLiveView(liveURLString)
            })
        })
    }
    
    fileprivate func displayLiveView(_ liveURLString : String?) {
        // 1.获取直播的地址
        guard let liveURLString = liveURLString else {
            return
        }
        
        // 2.使用IJKPlayer播放视频
        let options = IJKFFOptions.byDefault()
        options?.setOptionIntValue(1, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)
        ijkPlayer = IJKFFMoviePlayerController(contentURLString: liveURLString, with: options)
        
        // 3.设置frame以及添加到其他View中
        if anchor?.push == 1 {
            ijkPlayer?.view.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: bgImageView.bounds.width, height: bgImageView.bounds.width * 3 / 4))
            ijkPlayer?.view.center = bgImageView.center
        } else {
            ijkPlayer?.view.frame = bgImageView.bounds
        }
        
        print("bounds:", bgImageView.bounds)
        
        bgImageView.addSubview(ijkPlayer!.view)
        ijkPlayer?.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // 4.开始播放
        ijkPlayer?.prepareToPlay()
    }
}
// MARK:- 事件监听
extension RoomViewController {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {
            self.giftListView.frame.origin.y = kScreenH
        })
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("点击了聊天")
            chatToolsView.inputTextField.becomeFirstResponder()

        case 1:
            print("点击了分享")
        case 2:
            print("点击了礼物")
            UIView.animate(withDuration: 0.25, animations: {
                self.giftListView.frame.origin.y = kScreenH - kGiftlistViewHeight
            })
        case 3:
            print("点击了更多")
        case 4:
            print("点击了粒子")
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmittering(point) : stopEmittering()

            
        default:
            fatalError("未处理按钮")
        }
    }
}
//MARK: -监听键盘的弹出
extension RoomViewController{
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification){
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight

        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: 7)!)
            
//            UIView.setAnimationCurve(.easeInOut)
            
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
            let contentEndY = inputViewY == (kScreenH - kChatToolsViewHeight) ? (kScreenH - kChatContentViewHeight - 44) : endY - kChatContentViewHeight
            self.chatContentView.frame.origin.y = contentEndY

        })
    }
}
// MARK:- 监听用户输入的内容 Delegate
extension RoomViewController : ChatToolsViewDelegate ,GiftListViewDelegate{
    func chatToolsView(toolView: ChatToolsView, message: String) {
        socket.sendTextMsg(message: message)
    }
    func giftListView(giftView: GiftListView, giftModel: GiftModel) {
        socket.sendGifMessage(gifName: giftModel.subject, gifUrl: giftModel.img2, giftCount: 1)
        
    }

}
// MARK:- 给服务器发送即时消息
extension RoomViewController {
    
    fileprivate func addHeartBeatTimer() {
        heartBeatTimer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        RunLoop.main.add(heartBeatTimer!, forMode: .common)
    }
    
    @objc fileprivate func sendHeartBeat() {
        socket.sendHeartBeat()
    }
}


// MARK:- 接受聊天服务器返回的消息
extension RoomViewController : HYSocketDelegate {
    func socket(_ socket: HYSocket, joinRoom user: UserInfo) {
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, true))
    }
    
    func socket(_ socket: HYSocket, leaveRoom user: UserInfo) {
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, false))
    }
    
    func socket(_ socket: HYSocket, chatMsg: ChatMessage) {
        // 1.通过富文本生成器, 生产需要的富文本
        let chatMsgMAttr = AttrStringGenerator.generateTextMessage(chatMsg.user.name, chatMsg.text)
        
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(chatMsgMAttr)
    }
    
    func socket(_ socket: HYSocket, giftMsg: GiftMessage) {
        // 1.通过富文本生成器, 生产需要的富文本
        let giftMsgAttr = AttrStringGenerator.generateGiftMessage(giftMsg.giftname, giftMsg.giftURL, giftMsg.user.name)
        
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(giftMsgAttr)
    }
}
