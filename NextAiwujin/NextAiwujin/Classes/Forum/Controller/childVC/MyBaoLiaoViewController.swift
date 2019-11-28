//
//  MyBaoLiaoViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/11/27.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class MyBaoLiaoViewController: BaseViewController {

    //MARK: - 懒加载
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

//MARK: - 设置UI
extension MyBaoLiaoViewController {
    override func setUI() {
        super.setUI()
        //1.设置导航栏
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func initData() {
        super.initData()
    }
}
