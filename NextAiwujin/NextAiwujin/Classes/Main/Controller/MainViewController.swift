//
//  MainViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/1/30.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
//        let vc = UIViewController()
//        vc.view.backgroundColor = .red
//        addChild(vc)
        addChildrenController("PicSay")
        addChildrenController("News")
        addChildrenController("Forum")
        addChildrenController("RadioStation")
        addChildrenController("MyCenter")
        // Do any additional setup after loading the view.
        
        //TODO:BaseViewController和MyNavigationController处理
    }
    
    
    func addChildrenController(_ name:String){
        let childVC = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        addChild(childVC)
    }

}

extension MainViewController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //首页tabbarItem添加tag
        if viewController.tabBarItem.tag == 111 {
//            print("头条")
        }else if viewController.tabBarItem.tag == 222{
//            print("新闻")
        }else if viewController.tabBarItem.tag == 333{
//            print("论坛")
        }else if viewController.tabBarItem.tag == 444{
//            print("电台")
        }else if viewController.tabBarItem.tag == 555{
//            print("我的")
        }
        return true
    }
}
