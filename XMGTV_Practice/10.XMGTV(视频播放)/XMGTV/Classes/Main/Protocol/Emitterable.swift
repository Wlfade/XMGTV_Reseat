//
//  Emitterable.swift
//  XMGTV
//
//  Created by zy on 2021/1/18.
//

import UIKit

protocol Emitterable {
    
}
extension Emitterable where Self : UIViewController{
    func startEmittering(_ point : CGPoint){
        //1.创建发射器
        let emitter = CAEmitterLayer()
        
        //2.设置发射器的位置
        emitter.emitterPosition = point
        
        //3.开启三维效果
        emitter.preservesDepth = true
        
        //4.创建例子,而且设置例子相关的属性
        var cells = [CAEmitterCell]()
        
        for i in 0..<10 {
            //4.1 创建例子cell
            let cell = CAEmitterCell()
            
            //4.2设置粒子速度
            cell.velocity = 150
            cell.velocityRange = 100
            
            //4.3设置粒子的大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            //4.4设置粒子的方向
            cell.emissionLongitude = CGFloat(-Double.pi/2)
            cell.emissionRange = CGFloat(-Double.pi/12)
            
            //4.5设置粒子的存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            
            //4.6设置粒子的旋转
            cell.spin = CGFloat(Double.pi/2)
            cell.spinRange = CGFloat(Double.pi / 4)
            
            //4.7设置粒子每秒弹出的个数
            cell.birthRate = 2
            
            //4.8设置粒子展示的图片
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            
            //4.9添加到数组中
            cells.append(cell)
        }
        // 5.将粒子设置到发射器中
        emitter.emitterCells = cells
        
        // 6.将发射器的layer添加到父layer中
        view.layer.addSublayer(emitter)
    }
    
    func stopEmittering() {
        /*
        for layer in view.layer.sublayers! {
            if layer.isKind(of: CAEmitterLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
        */
        view.layer.sublayers?.filter({ $0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
}
