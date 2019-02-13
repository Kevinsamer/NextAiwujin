//
//  ZZWWaveView.swift
//  NextAiwujin
//  水波纹控件
//  Created by DEV2018 on 2019/2/11.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class ZZWWaveView: UIView {
    
    enum ZZWWaveViewType {
        case OvalType
        case SectorType
    }
    // 百分比      默认:0
    var percent : CGFloat = 0.0{
        didSet{
            
            currentWavePointY = self.frame.height * self.percent
            if (percent>0 && percent<1) {
                kExtraHeight = 10
            }
            
            initial()
        }
    }
    
    
    var colors : [CGColor] = [UIColor(hexString: "ff9548")!.cgColor,UIColor(hexString: "f76ae0")!.cgColor]
    var sColors : [CGColor] = [UIColor(hexString: "ffa548")!.cgColor,UIColor(hexString: "f78ae0")!.cgColor]
    
    var waveAmplitude : CGFloat = 0.0     // 波纹振幅     默认:0
    var waveCycle : CGFloat = 0.0// 波纹周期     默认:1.29 * M_PI /
    var waveSpeed : CGFloat = 0.2/CGFloat.pi// 波纹速度     默认:0.2/M_PI
    var waveGrowth : CGFloat = 1.00// 波纹上升速度  默认:1.00
    
    var waveDisplaylink : CADisplayLink?
    var firstWaveLayer : CAShapeLayer?//里层
    var secondWaveLayer : CAShapeLayer?//外层
    var gradientLayer : CAGradientLayer?// 绘制渐变1
    var sGradientLayer : CAGradientLayer?// 绘制渐变2
    var textLayer : CATextLayer?
    
    var waterWaveWidth : CGFloat = 160.0// 宽度
    var offsetX : CGFloat = 0.0// 波浪x位移
    var currentWavePointY : CGFloat = 0.0// 当前波浪上升高度Y
    var kExtraHeight : CGFloat = 0.0     // 保证水波波峰不被裁剪，增加部分额外的高度
    var variable : CGFloat = 0.5/CGFloat.pi// 可变参数 更加真实 模拟波纹
    var increase : Bool = false// 增减变化
    
    var waveViewType :ZZWWaveViewType = .OvalType
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        
    }
    
    func initial()   {
        
        waterWaveWidth  = self.frame.width
        if (waterWaveWidth > 0) {
            self.waveCycle =  1.29 * CGFloat.pi / waterWaveWidth
        }
        
        resetProperty()
    }
    
    func resetProperty() {
        currentWavePointY =  self.frame.height * self.percent
        
        offsetX = 0
        variable = 1.6
        increase = false
        
        kExtraHeight = 0
        if (percent>0 && percent<1) {
            kExtraHeight = 10
        }
        
    }
    
    func startWave()  {
        
        if (firstWaveLayer == nil) {
            // 创建第一个波浪Layer
            firstWaveLayer = CAShapeLayer.init()
            
        }
        
        if (secondWaveLayer == nil) {
            // 创建第二个波浪Layer
            secondWaveLayer = CAShapeLayer.init()
        }
        
        // 添加渐变layer``````
        if ((self.gradientLayer) != nil) {
            self.gradientLayer?.removeFromSuperlayer()
            self.gradientLayer = nil
        }
        self.gradientLayer = CAGradientLayer.init()
        self.gradientLayer?.frame = gradientLayerFrame()
        self.gradientLayer?.mask = firstWaveLayer
        self.layer.addSublayer(self.gradientLayer!)
        
        if (self.sGradientLayer) != nil {
            self.sGradientLayer?.removeFromSuperlayer()
            self.sGradientLayer = nil
        }
        self.sGradientLayer = CAGradientLayer.init()
        self.sGradientLayer?.frame = gradientLayerFrame()
        self.sGradientLayer?.mask = secondWaveLayer
        self.layer.addSublayer(self.sGradientLayer!)
        
        //设置渐变layer相关属性
        setupGradientColor()
        
        if ((self.textLayer) != nil) {
            self.textLayer?.removeFromSuperlayer()
            self.textLayer = nil
        }
        textLayer = CATextLayer.init()
        textLayer?.frame = CGRect(x: (self.width - 18.0)/2.0, y: (self.height - 35.0)/2.0, width: 18.0, height: 35.0)
        textLayer?.contentsScale = 1
        
        textLayer?.fontSize = 16.0
        textLayer?.foregroundColor = UIColor.init(hex: 141414)?.cgColor
        textLayer?.alignmentMode = CATextLayerAlignmentMode.center
        self.layer.addSublayer(textLayer!)
        
        if ((waveDisplaylink) != nil) {
            stopWave()
        }
        
        // 启动定时调用
        waveDisplaylink = CADisplayLink.init(target: self, selector: #selector(getCurrentWave(displayLink:)))
        waveDisplaylink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        
    }
    
    func gradientLayerFrame() -> CGRect{
        
        // gradientLayer在上升完成之后的frame值，如果gradientLayer在上升过程中不断变化frame值会导致一开始绘制卡顿，所以只进行一次赋值
        
        var gradientLayerHeight : CGFloat = self.frame.height * self.percent + kExtraHeight
        
        if (gradientLayerHeight > self.frame.height)
        {
            gradientLayerHeight = self.frame.height
        }
        
        let frame = CGRect(x: 0, y: self.frame.height - gradientLayerHeight, width: self.frame.width, height: gradientLayerHeight)
        return frame
    }
    
    func setupGradientColor() {
        
        // gradientLayer设置渐变色
        if ((self.colors.count) < 1){
            self.colors = defaultColors()
        }
        if ((self.sColors.count) < 1){
            self.sColors = defaultColors()
        }
        
        self.gradientLayer?.colors = self.colors
        self.sGradientLayer?.colors = self.sColors
        
        //设定颜色分割点
        let count  = self.colors.count
        let d : CGFloat = 1.0 / CGFloat(count)
        
        let locations = NSMutableArray.init(capacity: 0)
        for i in 0..<count {
            
            let num = NSNumber.init(value: Float(d + d * CGFloat(i)))
            locations.add(num)
            
        }
        let lastNum = NSNumber.init(value: Float(1.0))
        locations.add(lastNum)
        
        self.gradientLayer?.locations = locations as? [NSNumber]
        self.sGradientLayer?.locations = locations as? [NSNumber]
        
        // 设置渐变方向，从上往下
        self.gradientLayer?.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer?.endPoint = CGPoint(x: 0, y: 1)
        
        self.sGradientLayer?.startPoint = CGPoint(x: 0, y: 0)
        self.sGradientLayer?.endPoint = CGPoint(x: 0, y: 1)
        
    }
    
    func defaultColors() -> [CGColor] {
        
        // 默认的渐变色
        let color0 = UIColor.init(red: 166.0 / 255.0, green: 240.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        let color1 = UIColor.init(red: 240.0 / 255.0, green: 250.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        
        let colors = [color0.cgColor,color1.cgColor]
        return colors
    }
    
    @objc func getCurrentWave(displayLink:CADisplayLink)  {
        
        animateWave()
        
        if (!waveFinished()) {
            currentWavePointY -= self.waveGrowth
        }
        
        // 波浪位移
        offsetX += self.waveSpeed
        
        //textLayer?.string = String(format: "%d", Int(self.frame.height * self.percent - currentWavePointY)) + "\n%"
        
        setCurrentFirstWaveLayerPath()
        
        setCurrentSecondWaveLayerPath()
    }
    
    func setCurrentFirstWaveLayerPath()  {
        
        UIGraphicsBeginImageContext(CGSize(width: bounds.width, height: bounds.width))
        let path = UIBezierPath()
        var y : CGFloat = currentWavePointY
        
        path.move(to: CGPoint(x: 0, y: currentWavePointY + self.waveAmplitude))
        for x in 0..<Int(waterWaveWidth) {
            
            // 正弦波浪公式
            y = currentWavePointY + self.waveAmplitude * (sin(self.waveCycle * CGFloat(x) + offsetX) + 1.0)
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            
        }
        path.addLine(to: CGPoint(x: waterWaveWidth, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        firstWaveLayer?.path = path.cgPath
        self.gradientLayer?.mask = firstWaveLayer
        UIGraphicsEndImageContext()
    }
    
    func setCurrentSecondWaveLayerPath() {
        UIGraphicsBeginImageContext(CGSize(width: bounds.width, height: bounds.height))
        let path = UIBezierPath()
        var y : CGFloat = currentWavePointY
        path.move(to: CGPoint(x: 0, y: currentWavePointY + self.waveAmplitude))
        for x in 0..<Int(waterWaveWidth) {
            
            // 正弦波浪公式
            y = currentWavePointY +  self.waveAmplitude * (cos(self.waveCycle * CGFloat(x) + offsetX) + 1.0)
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            
        }
        path.addLine(to: CGPoint(x: waterWaveWidth, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        secondWaveLayer?.path = path.cgPath
        self.sGradientLayer?.mask = secondWaveLayer
        UIGraphicsEndImageContext()
    }
    
    func animateWave()  {
        if (increase) {
            variable += 0.01
        }else{
            variable -= 0.01
        }
        if (variable<=1) {
            increase = true
        }
        if (variable>=1.6) {
            increase = false
        }
        // 可变振幅
        self.waveAmplitude = variable*9
    }
    
    func waveFinished() -> Bool{
        // 波浪上升动画是否完成
        let d : CGFloat = self.frame.height - self.gradientLayer!.frame.height
        let _ : CGFloat = min(d, kExtraHeight)
        let bFinished : Bool = currentWavePointY <= 0.0
        return bFinished
    }
    
    func stopWave()  {
        waveDisplaylink?.invalidate()
        waveDisplaylink = nil;
    }
    
    func goOnWave()  {
        if ((waveDisplaylink) != nil) {
            stopWave()
        }
        // 启动定时调用
        waveDisplaylink = CADisplayLink.init(target: self, selector: #selector(getCurrentWave(displayLink:)))
        waveDisplaylink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    func reset()  {
        stopWave()
        resetProperty()
        
        firstWaveLayer?.removeFromSuperlayer()
        firstWaveLayer = nil;
        secondWaveLayer?.removeFromSuperlayer()
        secondWaveLayer = nil
        
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        sGradientLayer?.removeFromSuperlayer()
        sGradientLayer = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        switch waveViewType {
        case .OvalType:
            let path = UIBezierPath.init(ovalIn: CGRect(x: 0, y: 1.0, width: self.width, height: self.height - 1.0*2.0))
            UIColor(hexString: "979797")!.setStroke()
            path.lineWidth = 0
            path.stroke()
            let layerTest = CAShapeLayer.init()
            layerTest.path = path.cgPath
            self.layer.mask = layerTest
            
        case .SectorType:
            let path = UIBezierPath.init()
            path.move(to: CGPoint(x: self.width/2.0, y: 0))
            path.addArc(withCenter: CGPoint(x: self.width/2.0, y: self.height - self.width/2.0), radius: self.width/2.0, startAngle: -1.0/6.0*CGFloat.pi, endAngle: -5.0/6.0*CGFloat.pi, clockwise: true)
            
            path.close()
            UIColor(hexString: "979797")!.setStroke()
            path.lineWidth = 0
            path.stroke()
            
            let layerTest = CAShapeLayer.init()
            layerTest.path = path.cgPath
            self.layer.mask = layerTest
        }
    }
    
    
    
}
