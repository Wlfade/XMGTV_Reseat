//
//  SeverManager.swift
//  ServerT
//
//  Created by xsj on 2021/2/9.
//

import UIKit
protocol ListenDelegate : class {
    func listenStatus(startStatus: Bool,startContent: String)
}
class SeverManager: NSObject {
    weak var delete: ListenDelegate?

    fileprivate lazy var serverSocket : TCPServer = TCPServer(addr: "192.168.1.11", port: 7878)
    fileprivate var isServerRunning : Bool = false
    fileprivate lazy var clientMrgs : [ClientManager] = [ClientManager]()
}

extension SeverManager {
    func startRunning() {
        // 1.开启监听
        let tuple = serverSocket.listen()
        
        if let startStatus = Optional(tuple.0) {
            print("端口监听成功 \(startStatus)")
        }else{
            print("端口监听失败 \(tuple.1)")
        }
        guard tuple.0 else {
            return
        }
        isServerRunning = true
        
        // 2.开始接受客户端
        DispatchQueue.global().async {
            while self.isServerRunning{
                if let client = self.serverSocket.accept() {
                        
                    DispatchQueue.global().async {
                        print("接收到一个客户端")
                        self.handlerClient(client)
                    }
                }
            }
            
        }
    }
    
    func stopRunning() {
        isServerRunning = false
    }
    
}

extension SeverManager {
    fileprivate func handlerClient(_ client: TCPClient){
        //1.用一个ClientManager管理TCPClient
        let mgr = ClientManager(tcpClient: client)
        
        //2.保存客户端
        clientMrgs.append(mgr)
        
        //3.用client开始接受消息
        mgr.startReadMsg()
        mgr.delete = self
    }
}
extension SeverManager : ClientManagerDelete {
    func sendMsgToClient(data: Data) {
        for mgr in clientMrgs {
            mgr.tcpClient.send(data: data)
        }
    }
    func removeClient(client: ClientManager) {
        guard let index = clientMrgs.firstIndex(of: client) else { return  }
        clientMrgs.remove(at: index)
    }
}
