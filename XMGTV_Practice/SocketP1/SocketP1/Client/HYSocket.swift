//
//  HYSocket.swift
//  ClientT
//
//  Created by xsj on 2021/2/9.
//

import UIKit
protocol HYSocketDelegate : class {
    func socket(_ socket : HYSocket, joinRoom user : UserInfo)
    func socket(_ socket : HYSocket, leaveRoom user : UserInfo)
    func socket(_ socket : HYSocket, chatMsg : ChatMessage)
    func socket(_ socket : HYSocket, giftMsg : GiftMessage)
}

class HYSocket{
    fileprivate var tcpClient : TCPClient
    fileprivate var isClientConnected: Bool = false
    weak var delete: HYSocketDelegate?
    fileprivate lazy var userInfo: UserInfo = {
        var userInfo = UserInfo()
        userInfo.name = "摩斯_\(arc4random_uniform(10))"
        userInfo.level = Int32(arc4random() % 100)
        userInfo.iconURL = "色图"
        return userInfo
    }()
    init(addr : String, port : Int) {
        tcpClient = TCPClient(addr: addr, port: port)
        
    }
}
extension HYSocket{
    func connectServer() -> Bool {
        let tuple = tcpClient.connect(timeout: 5)
        print(tuple)
        return tuple.0
    }
    func closeSever(){
        let tuple = tcpClient.close()
        print(tuple)
    }
    func sendMsg(str: String) {
        let tuple = tcpClient.send(str: str)
        print(tuple)
    }
    func sendMsg(data : Data) {
        let tuple = tcpClient.send(data: data)
        print(tuple)
    }
    

}
extension HYSocket {
    func startReadMsg() {
        print("开始阅读")
        isClientConnected = true
        DispatchQueue.global().async {
            while self.isClientConnected {
                if let countBytes = self.tcpClient.read(4) {
                    let countData:Data = Data(bytes: countBytes, count: 4)
                    var count = 0
                    (countData as NSData).getBytes(&count, length: 4)
                    print(count,countBytes,countData)
                    
                    guard let typeBytes = self.tcpClient.read(2) else { return  }
                    let typeData = Data(bytes: typeBytes, count: 2)
                    var type = 0
                    (typeData as NSData).getBytes(&type, length: 2)
                    print(type,typeBytes,typeData)
                    
                    guard let contentBytes = self.tcpClient.read(count) else { return  }
                    let contentData = Data(bytes: contentBytes, count: count)
                    
                    //buffer
                    self.handleMsg(type: type, contentData: contentData)
                } else {
                    print("客户端断开了连接")
                    self.tcpClient.close()
                    self.isClientConnected = false
                }
            }
        }
    }
    func handleMsg(type: Int,contentData: Data) {
        switch type {
        case 0,1:
            let decodedInfo = try! UserInfo(serializedData: contentData)
            print(decodedInfo,decodedInfo.name)
            type == 0 ? delete?.socket(self, joinRoom: decodedInfo) : delete?.socket(self, leaveRoom: decodedInfo)
        case 2:
            let decodedInfo = try! ChatMessage(serializedData: contentData)
            print(decodedInfo,decodedInfo.text)
            delete?.socket(self, chatMsg: decodedInfo)
        case 3:
            let decodedInfo = try! GiftMessage(serializedData: contentData)
            print(decodedInfo,decodedInfo.giftname)
            delete?.socket(self, giftMsg: decodedInfo)
        default:
            print("未知消息")
        }
    }
}

extension HYSocket {
    func sendJoinRoom() {
        let msgData = try! userInfo.serializedData()
        sendMsg(contentData: msgData, type: 0)
    }
    func sendLeaveRoom() {
        let msgData = try! userInfo.serializedData()
        sendMsg(contentData: msgData, type: 1)
    }
    func sendTextMsg(message: String) {
        var chatMessage = ChatMessage()
        chatMessage.text = message
        chatMessage.user = userInfo
        let chatData = try! chatMessage.serializedData()
        sendMsg(contentData: chatData, type: 2)
    }
    func sendGifMessage(gifName: String, gifUrl: String, giftCount: Int) {
        var giftMessage = GiftMessage()
        giftMessage.user = userInfo
        giftMessage.giftname = gifName
        giftMessage.giftURL = gifUrl
        giftMessage.giftcount = Int32(giftCount)
        let giftData = try! giftMessage.serializedData()
        sendMsg(contentData: giftData, type: 3)
        
    }
    func sendHeartBeat () {
        let heartString = "I am is heart beat"
        let heartData = heartString.data(using: .utf8)!
        sendMsg(contentData: heartData, type: 100)
    }
    func sendMsg(contentData: Data, type: Int) {
        
        //1.获取消息长度 写入到data
        var count = contentData.count
        let countData = Data(bytes: &count, count: 4)
        print(count,countData)
        
        //2.消息类型
        var type = type
        let typeData = Data(bytes: &type, count: 2)
        print(type,typeData)
        
        //3.消息汇总
        let totalData = countData + typeData + contentData
        print(totalData)
        
        let tuple = tcpClient.send(data: totalData)
        print(tuple)
    }
}
