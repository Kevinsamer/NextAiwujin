//
//  BaseTrunclentViewController.swift
//  NextAiwujin
//  透明导航栏baseVC
//  Created by DEV2018 on 2019/3/21.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import EFNavigationBar
class BaseTrunclentViewController: UIViewController {
    lazy var navBar = EFNavigationBar.CustomNavigationBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        //automaticallyAdjustsScrollViewInsets = false
        setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
    
    @objc dynamic func setUI(){
        initData()
        self.view.backgroundColor = .white
        setupNavBar()
    }
    
    @objc dynamic func initData(){
        
    }

    func setupNavBar() {
        view.addSubview(navBar)
        
        // 设置自定义导航栏背景图片
        navBar.barBackgroundImage = #imageLiteral(resourceName: "navi_bg")
//        navBar.barBackgroundColor = UIColor(r: 127, g: 125, b: 201, alpha: 1)
        // 设置自定义导航栏背景颜色
        //         navBar.backgroundColor = MainNavBarColor
        EFNavigationBar.defaultNavBarTitleColor = .white
        EFNavigationBar.defaultNavBarTitleColor = .white
        self.navigationController?.navigationBar.setColors(background: .white, text: .white)
        // 设置自定义导航栏标题颜色
        navBar.titleLabelColor = .white
        
        // 设置自定义导航栏左右按钮字体颜色
        navBar.setTintColor(color: .white)
        navBar.setBottomLineHidden(hidden: true)
        
        
    }

}
