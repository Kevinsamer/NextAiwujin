//
//  MainViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/1/30.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
//import ESTabBarController_swift
class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
//        self.tabBar.shadowImage = UIImage(named: "transparent")
//        self.tabBar.backgroundImage = UIImage(named: "background_dark")
        self.modalPresentationStyle = .fullScreen
        addChildrenController("PicSay")
        addChildrenController("News")
        //addChildrenController("Forum")
        addChildrenController("RadioStation")
        addChildrenController("MyCenter")
        // Do any additional setup after loading the view.
//        let picSayVC = UIViewController()
//        let newsVC = UIViewController()
//        let forumVC = UIViewController()
//        let radioVC = UIViewController()
//        let myVC = UIViewController()
        
//        let picSayVC = UIStoryboard(name: "PicSay", bundle: nil).instantiateInitialViewController()!
//        let newsVC = UIStoryboard(name: "News", bundle: nil).instantiateInitialViewController()!
//        let forumVC = UIStoryboard(name: "Forum", bundle: nil).instantiateInitialViewController()!
//        let radioVC = UIStoryboard(name: "RadioStation", bundle: nil).instantiateInitialViewController()!
//        let myVC = UIStoryboard(name: "MyCenter", bundle: nil).instantiateInitialViewController()!
        //系统方法添加item
//        picSayVC.tabBarItem = UITabBarItem.init(title: "直播", image: UIImage.init(named: "broadcast_tabIcon"), selectedImage: UIImage.init(named: "broadcast_tabIcon_selected"))
//        newsVC.tabBarItem = UITabBarItem.init(title: "新闻", image: UIImage.init(named: "newstabicon"), selectedImage: UIImage.init(named: "newstabicon_selected"))
//        forumVC.tabBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "govericon"), selectedImage: UIImage.init(named: "govericon_selected"))
//        radioVC.tabBarItem = UITabBarItem.init(title: "最飨购", image: UIImage.init(named: "lifetabicon"), selectedImage: UIImage.init(named: "lifetabicon_selected"))
//        myVC.tabBarItem = UITabBarItem.init(title: "我的", image: UIImage.init(named: "minetabicon"), selectedImage: UIImage.init(named: "minetabicon_selected"))
        //ES方法添加item
//        picSayVC.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "直播", image: UIImage.init(named: "broadcast_tabIcon"), selectedImage: UIImage.init(named: "broadcast_tabIcon_selected"), tag: 111)
//        newsVC.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "新闻", image: UIImage.init(named: "newstabicon"), selectedImage: UIImage.init(named: "newstabicon_selected"), tag: 222)
//        forumVC.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage.init(named: "govericon"), selectedImage: UIImage.init(named: "govericon_selected"), tag: 333)
//        radioVC.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "飨家", image: UIImage.init(named: "lifetabicon"), selectedImage: UIImage.init(named: "lifetabicon_selected"), tag: 444)
//        myVC.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "我的", image: UIImage.init(named: "minetabicon"), selectedImage: UIImage.init(named: "minetabicon_selected"), tag: 555)
        
        
//        viewControllers = [picSayVC, newsVC, forumVC, radioVC, myVC]
//        let navigationController = MyNavigationController.init(rootViewController: self)
//        self.title = "AAAA"
//        UIApplication.shared.keyWindow?.rootViewController = navigationController
//        v1.tabBarItem = ESTabBarItem.init(ExampleTipsBasicContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func addChildrenController(_ name:String){
        
        let childVC = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        
        addChild(childVC)
    }

}

//MARK: - 实现UITabBarControllerDelegate的shouldSelect viewController方法，通过SB中向tabBarItem添加的tag来实现点击各个模块的监听
extension MainViewController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 555{
            if AppDelegate.appUser?.id == -1{
                YTools.presentToLoginOrNextControl(vc: self, itemTag: viewController.tabBarItem.tag, completion: nil)
                return false
            }else{
                return true
            }
        }
        //首页tabbarItem添加tag
        if viewController.tabBarItem.tag == 111 {
//            print("直播")
        }else if viewController.tabBarItem.tag == 222{
//            print("新闻")
        }else if viewController.tabBarItem.tag == 333{
//            print("报料")
        }else if viewController.tabBarItem.tag == 444{
//            print("商城")
        }else if viewController.tabBarItem.tag == 555{
//            print("我的")
        }
        return true
    }
}
