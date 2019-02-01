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

//        let vc = UIViewController()
//        vc.view.backgroundColor = .red
//        addChild(vc)
        addChildrenController("News")
        addChildrenController("PicSay")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
