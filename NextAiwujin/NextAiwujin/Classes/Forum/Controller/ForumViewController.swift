//
//  ForumViewController.swift
//  NextAiwujin
//  报料VC
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
class ForumViewController: TabmanViewController {
    private let vcs:[UIViewController] = [MyBaoLiaoViewController(), BaoLiaoViewController()]
    private let titles:[String] = ["我的报料","报料"]
    
    //MARK: - 懒加载
    ///顶部滑动换页控件
    lazy var topBar: TMBar.ButtonBar = {
        //初始化控件
        let bar = TMBar.ButtonBar()
        
        //设置bar的属性
        bar.indicator.weight = TMLineBarIndicator.Weight.medium
        bar.indicator.tintColor = UIColor.red
//        bar.width = self.view.frame.size.width
        //将weight属性设置为0来去除底部指示条
        //        bar.indicator.weight = .custom(value: 0)
        //自定义文字属性
        bar.buttons.customize { (button) in
            button.font = UIFont.systemFont(ofSize: 18)
            button.tintColor = .black
            button.selectedTintColor = .red
            button.selectedFont = UIFont.systemFont(ofSize: 18)
//            button.width = self.view.frame.size.width / 3
        
        }
        bar.layout.contentMode = .fit
        //自定义文字button的layout
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        //        bar.layout.interButtonSpacing = 10
        //bar.layout.layout(in: tempView)
        //设置背景色
        bar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return bar
    }()
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "报料"
        self.dataSource = self

        

        // Add to view
        addBar(topBar, dataSource: self, at: .top)
        
    }

}

//MARK: - 设置UI
extension ForumViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return vcs.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vcs[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.first
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: titles[index])
    }
    
    
}
