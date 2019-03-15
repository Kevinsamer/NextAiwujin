//
//  MyCenterViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwifterSwift
class MyCenterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension MyCenterViewController{
    override func setUI() {
        super.setUI()
        //1.设置导航栏消失
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .black
        ZZWWaveViewFunc()
        
    }
    
    func ZZWWaveViewFunc()  {
        
        let colors1 = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor,UIColor(hexString: "ffffff")!.cgColor]
        let sColors1 = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6).cgColor,UIColor(hexString: "f0faff")!.cgColor]
        
        let waveView1 = ZZWWaveView.init(frame: CGRect(x: -50.0, y: 100.0, width: finalScreenW + 100, height: 100.0))
        
        self.view.addSubview(waveView1)
        waveView1.waveSpeed = CGFloat(0.1 / .pi)
        waveView1.waveViewType = .OvalType
        waveView1.colors = colors1
        waveView1.sColors = sColors1
        waveView1.percent = 0.4
        waveView1.waveGrowth = 10
        waveView1.startWave()
        
        let colors2 = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4).cgColor]
        let sColors2 = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor]
        let waveView2 = ZZWWaveView.init(frame: CGRect(x: -50.0, y: 50.0, width: finalScreenW + 100, height: 150.0))
        self.view.addSubview(waveView2)
        waveView2.waveSpeed = CGFloat(0.04 / .pi)
        waveView2.waveViewType = .OvalType
        waveView2.colors = colors2
        waveView2.sColors = sColors2
        waveView2.percent = 0.4
        waveView2.waveGrowth = 10
        waveView2.startWave()
        
        
        
    }
}
