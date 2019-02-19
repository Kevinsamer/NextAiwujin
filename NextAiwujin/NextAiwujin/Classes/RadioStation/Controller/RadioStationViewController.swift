//
//  RadioStationViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class RadioStationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension RadioStationViewController{
    override func setUI() {
        super.setUI()
        //1.设置导航栏消失
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
