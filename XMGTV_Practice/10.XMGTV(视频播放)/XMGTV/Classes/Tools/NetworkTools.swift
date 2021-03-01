//
//  NetworkTools.swift
//  XMGTV
//
//  Created by zy on 2021/1/14.
//

import UIKit
import Alamofire
enum MethodType {
    case get
    case post
}

class NetworkTools {
    
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }
    }

    
//    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
//
//        // 1.获取类型
//        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
//
//         //2.发送网络请求
//        Alamofire.request(URLString, method: method, parameters: parameters).validate(contentType: ["text/plain"]).responseJSON { (response) in
//
//            // 3.获取结果
//            guard let result = response.result.value else {
//                print(response.result.error!)
//                return
//            }
//
//            // 4.将结果回调出去
//            finishedCallback(result)
//        }
//        // 2.发送网络请求
////        Alamofire.request(URLString,method: method,parameters: parameters)
////            .validate(statusCode: 200..<300)
////            .validate(contentType: ["application/json"])
////            .responseData { response in
////                switch response.result {
////                case .success:
////                    let result = response.result.value
////                    // 4.将结果回调出去
////                    finishedCallback(result as Any)
////
////                    print("Validation Successful")
////                case .failure(let error):
////                    print(error)
////                }
////            }
//    }
//
//
//    class func requestJsonData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
//
//        // 1.获取类型
//        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
//
//         //2.发送网络请求
//        Alamofire.request(URLString, method: method, parameters: parameters).validate(contentType: ["application/json"]).responseJSON { (response) in
//
//            // 3.获取结果
//            guard let result = response.result.value else {
//                print(response.result.error!)
//                return
//            }
//
//            // 4.将结果回调出去
//            finishedCallback(result)
//        }
//        // 2.发送网络请求
////        Alamofire.request(URLString,method: method,parameters: parameters)
////            .validate(statusCode: 200..<300)
////            .validate(contentType: ["application/json"])
////            .responseData { response in
////                switch response.result {
////                case .success:
////                    let result = response.result.value
////                    // 4.将结果回调出去
////                    finishedCallback(result as Any)
////
////                    print("Validation Successful")
////                case .failure(let error):
////                    print(error)
////                }
////            }
//    }

}
