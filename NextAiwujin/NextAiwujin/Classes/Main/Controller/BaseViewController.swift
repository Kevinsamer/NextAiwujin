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
    
//    lazy var naviBg: UIImage = {
//        let image = #imageLiteral(resourceName: "navi_bg")
//        return image.resizableImage(withCapInsets: .zero, resizingMode: UIImage.ResizingMode.stretch)
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.modalPresentationStyle = .fullScreen
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
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg").resizableImage(withCapInsets: .zero, resizingMode: .stretch), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
//        self.navigationController?.navigationBar.barTintColor = UIColor.init(r: 127, g: 125, b: 201, alpha: 1)
//        EFNavigationBar.defaultNavBarTitleColor = .white
//        EFNavigationBar.defaultNavBarTitleColor = .white
        self.navigationController?.navigationBar.setColors(background: .white, text: .white)
        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.tintColor = .white
//        navBarTintColor = .white
//        navBarTitleColor = .white
//        navigationController?.navigationBar.tintColor = .yellow
        //2.初始化数据
        initData()
    }
    
    @objc func initData(){
        
    }
}
