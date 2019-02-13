//
//  WaveView.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/11.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class WaveView: UIView {
    
    var firstWaveColor = UIColor() // 第一个波浪颜色
    var secondWaveColor = UIColor() // 第二个波浪颜色
    
    var waveDisplaylink : CADisplayLink!
    var firstWaveLayer : CAShapeLayer! // 第一个波浪
    var secondWaveLayer : CAShapeLayer! // 第二个波浪
    
    var waveAmplitude : CGFloat = 0.0 // 波纹振幅
    var waveCycle : CGFloat = 0.0 // 波纹周期
    var waveSpeed : CGFloat = 0.0 // 波纹速度
    
    var offsetX : CGFloat = 0.0 // 波浪 x 位移
    var currentWavePointY : CGFloat = 0.0 // 当前波浪上市高度Y（高度从大到小 坐标系向下增长
    
    var variable : Float = 0.0 // 可变参数 更加真实 模拟波纹
    var increase : Bool = true // 增减变化
    
    var waterWaveWidth : CGFloat = 0.0 // 水波宽度
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        
        self.backgroundColor = UIColor.clear
        firstWaveColor = UIColor.white
        secondWaveColor = UIColor.white
        dispatch_async(dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL)) {
            self.startWave()
        }
        
        waveCycle =  2 * CGFloat(Double.pi) / self.frame.size.width
        waterWaveWidth = UIScreen.main.bounds.size.width + 10
        
        waveSpeed = CGFloat(0.05 / Double.pi)
        currentWavePointY = 0
        variable = 1.6
        increase = false
        offsetX = 0
    }
    
    func startWave() {
        if firstWaveLayer == nil {
            // 创建第一个波浪
            firstWaveLayer = CAShapeLayer()
            firstWaveLayer.fillColor = firstWaveColor.cgColor
            firstWaveLayer.opacity = 0.3
            self.layer.addSublayer(firstWaveLayer)
        }
        
        if secondWaveLayer == nil {
            // 创建第二个波浪
            secondWaveLayer = CAShapeLayer()
            secondWaveLayer.fillColor = secondWaveColor.cgColor
            self.layer.addSublayer(secondWaveLayer)
        }
        
        if waveDisplaylink == nil {
            // 启动调用定时器
            waveDisplaylink = CADisplayLink(target: self, selector: #selector(getCurrentWave(_:)))
            waveDisplaylink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        }
        
    }
    
    @objc private func getCurrentWave(displayLink: CADisplayLink) {
        //        这里是调整波浪状态，自行发挥
        //        if (increase) {
        //            variable += 0.01
        //        } else {
        //            variable -= 0.01
        //        }
        //        if (variable <= 1) {
        //            increase = true
        //        }
        //
        //        if (variable >= 1.6) {
        //            increase = false
        //        }
        
        waveAmplitude = CGFloat(variable * 2.5)
        offsetX += waveSpeed
        
        setCurrentFirstWaveLayerPath()
        
        setCurrentSecondWaveLayerPath()
    }
    
    private func setCurrentFirstWaveLayerPath() {
        let path = CGMutablePath()
        var y = currentWavePointY
        var x : CGFloat = 0.0
        path.move(to: <#T##CGPoint#>, transform: <#T##CGAffineTransform#>)
        CGPathMoveToPoint(path, UnsafePointer<CGAffineTransform>.init(bitPattern: 0)!, 0, 0)
        while (true) {
            y = waveAmplitude * sin(waveCycle * x + offsetX) + currentWavePointY
            CGPathAddLineToPoint(path, nil, x, y)
            x += 1
            if x >= waterWaveWidth {
                break
            }
        }
        
        CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height)
        CGPathAddLineToPoint(path, nil, 0, self.frame.size.height)
        path.closeSubpath()
        
        firstWaveLayer.path = path
    }
    
    private func setCurrentSecondWaveLayerPath() {
        let path = CGMutablePath()
        var y = currentWavePointY
        var x : CGFloat = 0.0
        
        CGPathMoveToPoint(path, nil, 0, 0)
        while (true) {
            
            y = waveAmplitude * cos(waveCycle * x + offsetX) + currentWavePointY
            CGPathAddLineToPoint(path, nil, x, y)
            
            x += 1
            if x >= waterWaveWidth {
                break
            }
        }
        
        CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height)
        CGPathAddLineToPoint(path, nil, 0, self.frame.size.height)
        path.closeSubpath()
        
        secondWaveLayer.path = path
    }
    
    deinit {
        reset()
    }
    
    private func reset() {
        if firstWaveLayer != nil {
            firstWaveLayer.removeFromSuperlayer()
            firstWaveLayer = nil
        }
        if secondWaveLayer != nil {
            secondWaveLayer.removeFromSuperlayer()
            secondWaveLayer = nil
        }
    }
    
}

