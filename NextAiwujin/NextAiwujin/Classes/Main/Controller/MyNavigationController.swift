//
//  MyNavigationController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/1/30.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
//import EFNavigationBar
//定义局部变量、常量
class MyNavigationController: UINavigationController, UINavigationControllerDelegate {
    var popDelegate:UIGestureRecognizerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    

    
    //拦截跳转事件
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.children.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
        
    }
    
}

//MARK: - 设置UI
extension MyNavigationController{
    func setUI(){
        //1.设置导航栏基本属性
//        navBarTitleColor = .white
//        navBarTintColor = .white
        navigationController?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        navigationController?.navigationBar.tintColor = .white
        for vc in self.viewControllers {
            vc.navigationController?.navigationBar.topItem?.title = ""
        }
    }
}
