//
//  NewsViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
//定义局部变量、常量
private var viewControllers = [ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController(), ChildViewController()]
private var titles = ["武进新闻","生活连线","263行动","连线帮帮团","立波秀","天天向上","跟我出发","开门7+7","标榜汽车","嚼百趣","房产","汽车","旅游","健康","发展大会"]
class NewsViewController: TabmanViewController {
    
    //MARK: - 懒加载
    
    ///顶部滑动换页控件
    lazy var topBar: TMBar.ButtonBar = {
        //初始化控件
        let bar = TMBar.ButtonBar()
        //设置bar的属性
        //去除底部指示条
        bar.indicator.weight = .custom(value: 0)
        //自定义文字属性
        bar.buttons.customize { (button) in
            button.tintColor = .black
            button.selectedTintColor = .red
            button.selectedFont = UIFont.systemFont(ofSize: 18)
        }
        //自定义文字button的layout
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        bar.layout.interButtonSpacing = 10
        //bar.layout.layout(in: tempView)
        //设置背景色
        bar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return bar
    }()
    
    ///编辑页面按钮
    lazy var editTitleButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 160, height: topBar.height)
        btn.setImageForAllStates(#imageLiteral(resourceName: "icon_plus"))
        btn.contentMode = .center
        btn.centerTextAndImage(spacing: 0)
        btn.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        //btn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return btn
    }()
    
    

    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(tempView)
        setUI()
    }

}
//MARK: - 设置UI
extension NewsViewController{
     private func setUI() {
        //1.设置导航栏
        
        //2.设置顶部滑动换页控件
        setTMButtonBar()
    }
    
    private func setTMButtonBar(){
        //设置代理
        self.dataSource = self
//        //初始化控件
//        let bar = TMBar.ButtonBar()
//        //设置bar的属性
//        //去除底部指示条
//        bar.indicator.weight = .custom(value: 0)
//        //自定义文字属性
//        bar.buttons.customize { (button) in
//            button.tintColor = .black
//            button.selectedTintColor = .red
//            button.selectedFont = UIFont.systemFont(ofSize: 18)
//        }
//        //自定义文字button的layout
//        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        //设置背景色
//        bar.backgroundColor = .white
        
        //将控件添加到页面上
        addBar(topBar, dataSource: self, at: .top)
        topBar.rightPinnedAccessoryView = editTitleButton
        
    }
}

//MARK: - 实现tabman代理
extension NewsViewController:PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: titles[index])
    }
    
    
    
    
}
//MARK: - 点击事件
extension NewsViewController{
    @objc private func editButtonClicked(){
    
    }
}
