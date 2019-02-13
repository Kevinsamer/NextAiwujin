//
//  MyCenterViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

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
        
        ZZWWaveViewFunc()
        
    }
    
    func ZZWWaveViewFunc()  {
        let colors = [UIColor(hexString: "86d0f8")!.cgColor,UIColor(hexString: "ffffff")!.cgColor]
        let sColors = [UIColor(hexString: "a6f0ff")!.cgColor,UIColor(hexString: "f0faff")!.cgColor]
        
        let waveView = ZZWWaveView.init(frame: CGRect(x: 0.0, y: 0.0, width: finalScreenW, height: 300.0))
        self.view.addSubview(waveView)
        waveView.waveViewType = .OvalType
        waveView.colors = colors
        waveView.sColors = sColors
        waveView.percent = 0.4
        waveView.startWave()
        
    }
}
