//
//  BaseViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/1/30.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwifterSwift
import EFNavigationBar
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension BaseViewController{
    @objc func setUI(){
        //1.设置背景色
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
//        self.navigationController?.navigationBar.barTintColor = UIColor.init(r: 127, g: 125, b: 201, alpha: 1)
        navBarTintColor = .white
        navBarTitleColor = .white
//        navigationController?.navigationBar.tintColor = .yellow
        //2.初始化数据
        initData()
    }
    
    @objc func initData(){
        
    }
}
