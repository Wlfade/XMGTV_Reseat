//
//  AppDelegate.swift
//  XMGTV
//
//  Created by zy on 2021/1/11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //设置全局颜色
        UITabBar.appearance().tintColor = UIColor.orange
        //导航栏标题颜色
        UINavigationBar.appearance().barTintColor = UIColor.black
        
        return true
    }
}

