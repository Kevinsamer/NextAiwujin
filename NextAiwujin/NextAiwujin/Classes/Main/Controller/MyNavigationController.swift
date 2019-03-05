//
//  MyNavigationController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/1/30.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
//定义局部变量、常量


class MyNavigationController: UINavigationController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //设置进入二级页面时隐藏tabbar
        if self.viewControllers.count > 0{
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = ""
        //print(self.viewControllers.count)
        //YTools.setNavigationBarAndTabBar(navCT: (self.viewControllers.first?.navigationController)!, navItem: (self.viewControllers.first?.navigationItem)!)
    }
}

//MARK: - 设置UI
extension MyNavigationController{
    func setUI(){
        //1.设置导航栏基本属性
        navigationController?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        for vc in self.viewControllers {
            vc.navigationController?.navigationBar.topItem?.title = ""
        }
        //2.设置左侧app_icon、爱武进label和右侧搜索icon(金坛台方案)
//        self.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "navigation_app_icon", size: CGSize(width: 40, height: 40), clickAbled: false)
//        
//        self.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "navigation_search_icon", size: CGSize(width: 20, height: 20), clickAbled: true)
        //2.设置导航栏背景
        navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)]
    }
}
