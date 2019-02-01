//
//  BaseViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/1/30.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwifterSwift
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }

}

extension BaseViewController{
    func setUI(){
        //1.设置背景色
        self.view.backgroundColor = .random
    }
}
