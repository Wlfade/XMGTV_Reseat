//
//  ClientManager.swift
//  SocketP1
//
//  Created by xsj on 2021/2/15.
//

import UIKit

protocol ClientManagerDelete : class {
    //发送消息到客户端
    func sendMsgToClient(data: Data)
    //客户端移除
    func removeClient(client: ClientManager)
}

class ClientManager: NSObject {
    var tcpClient : TCPClient
    fileprivate var isClientConnected : Bool = false
    fileprivate var heartTimeCount: Int = 0
    weak var delete: ClientManagerDelete?
    fileprivate var timer: Timer!
    init(tcpClient : TCPClient) {
        self.tcpClient = tcpClient
        super.init()
    }
    
}
extension ClientManager {
    func startReadMsg() {
        print("开始新客户端")
        isClientConnected = true
        timer = Timer(fireAt: Date(timeIntervalSinceNow: 5), interval: 1, target: self, selector: #selector(checkHeartBeat), userInfo: nil, repeats: true)
        //放到当前线程 别是main 主线程了
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
        //RunLoop.current.run()
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
                    
                    //拦截
                    if type == 1 {
                        self.removeClient()
                    } else if type == 100 {
                        self.heartTimeCount = 0
                        let msg = String(data: contentData, encoding: .utf8)
                        print(msg ?? "空字符串",contentBytes,contentData)
                        continue
                    }
                    
                    //buffer
                    switch type {
                    case 0,1:
                        let decodedInfo = try! UserInfo(serializedData: contentData)
                        print(decodedInfo,decodedInfo.name)
                    case 2:
                        let decodedInfo = try! ChatMessage(serializedData: contentData)
                        print(decodedInfo,decodedInfo.text)
                    default:
                        print("未知消息")
                    }
                    
                    
                    //回调返回同样数据
                    print("回调啊。。。。。")
                    let totalData = countData + typeData + contentData
                    self.delete?.sendMsgToClient(data: totalData)
                } else {
                    print("客户端断开了连接")
                    self.removeClient()
                }
            }
        }
        //会影响回调发送 我日
        //RunLoop.current.run()
    }
    @objc fileprivate func checkHeartBeat () {
        heartTimeCount += 1
        print("heartTimeCount\(heartTimeCount)")
        if heartTimeCount >= 10 {
            removeClient()
        }
    }
    private func removeClient() {
        print("移除客户端")
        self.isClientConnected = false
        self.tcpClient.close()
        self.delete?.removeClient(client: self)
        
        timer.invalidate()
        timer = nil
    }
}
