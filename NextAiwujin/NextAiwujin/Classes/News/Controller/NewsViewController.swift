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
import SnapKit
//import ETNavBarTransparent
//定义局部变量、常量
private var viewControllers:[ChildViewController] = []
private var titles:[String] = []
//"武进新闻","生活连线","263行动","连线帮帮团","立波秀","天天向上","跟我出发","开门7+7","标榜汽车","嚼百趣","房产","汽车","旅游","健康","发展大会"
class NewsViewController: TabmanViewController {
    
    var menus:[CH1MenuModel]?{
        didSet{
            //menus有值之后先获取到所有的title
            titles.removeAll()
            viewControllers.removeAll()
            if let menu = menus {
                for i in 0..<menu.count {
                    titles.append(menu[i].Title)
                    let vc = ChildViewController()
                    vc.menu = menu[i]
                    vc.url = menu[i].File
                    vc.currentPage = 1
//                    vc.news = AppDelegate.newsArray?[i]
//                    DispatchQueue.main.async {
//                        AppConfigViewModel.requestCH1Items(url: item.File) { (news) in
//                            vc.news = news
//                        }
//                    }
                    
                    viewControllers.append(vc)
                }
            }
            //更新barItem的内容
//            topBar.reloadData(at: 0...titles.count-1, context: .full)
            //更新barItem和page的内容
            self.reloadData()
        }
    }
    
    var appConfigModel:AppConfigModel?{
        didSet{
            self.menus = appConfigModel?.CH1.menu
//            print(globalAppConfig.CH0.Title)
        }
    }
    
    
    
    //MARK: - 懒加载
    ///顶部bar的容器view
    lazy var barTempView: UIView = {
        let view = UIView()
        view.size = CGSize(width: topBar.width, height: topBar.height)
        view.backgroundColor = .black
        return view
    }()
    
    ///顶部滑动换页控件
    lazy var topBar: TMBar.ButtonBar = {
        //初始化控件
        let bar = TMBar.ButtonBar()
        //设置bar的属性
        bar.indicator.weight = TMLineBarIndicator.Weight.medium
        bar.indicator.tintColor = UIColor.red
        //将weight属性设置为0来去除底部指示条
//        bar.indicator.weight = .custom(value: 0)
        //自定义文字属性
        bar.buttons.customize { (button) in
            button.font = UIFont.systemFont(ofSize: 18)
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
//        self.navBarBgAlpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}
//MARK: - 设置UI
extension NewsViewController{
     private func setUI() {
        navBarTintColor = .white
        navBarTitleColor = .white
        //0.初始化数据
//        DispatchQueue.main.async {
//            self.initData()
//        }
        self.appConfigModel = globalAppConfig
        //1.设置导航栏
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        
        
        
        self.navigationItem.title = "新闻资讯"
        //2.设置顶部滑动换页控件
        setTMButtonBar()
    }
    
    private func initData(){
        AppConfigViewModel.requestAppConfig { (config) in
            self.appConfigModel = config
        }
    }
    
    private func setTMButtonBar(){
        //设置代理
        self.dataSource = self
        
        //1.先将控件添加到页面上
        addBar(topBar, dataSource: self, at: .top)
//        topBar.rightPinnedAccessoryView = editTitleButton
        //2.初始化bar的容器view，将容器view的frame设置为bar的frame,bar右侧需要添加＋时只需改变tempView的width，然后把+设置在tempView的右侧
        self.view.addSubview(barTempView)
        barTempView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.width.equalTo(topBar.snp.width)
            make.height.equalTo(topBar.snp.height)
            make.top.equalTo(topBar.snp.top)
        }
        
        topBar.removeFromSuperview()
        addBar(topBar, dataSource: self, at: .custom(view: barTempView, layout: nil))
//        print(barTempView.height)
        
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
        if titles.count > 0 {
            return TMBarItem(title: titles[index])
        }else{
            return TMBarItem(title: "")
        }
    }
    
    
    
    
}
//MARK: - 点击事件
extension NewsViewController{
    @objc private func editButtonClicked(){
        let vc = BaseViewController()
        self.navigationController?.show(vc, sender: self)
    }
}
