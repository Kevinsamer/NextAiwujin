//
//  PicSayViewController.swift
//  NextAiwujin
//  改为直播模块
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwifterSwift
import FSPagerView
import Tabman
import Pageboy
//定义私有常量变量
private let titleLabelWidth:CGFloat = 50
private let bannerH:CGFloat = 150
private let bigPicCellID = "bigPicCellID"
private let smallPicCellID = "smallPicCellID"
private let threePicsCellID = "threePicsCellID"
private let bannerCellID = "bannerCellID"
private var banners:[UIImage] = [#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back")]
private let barTitles:[String] = ["直播","电视","广播"]
private let secondSectionTitles:[String] = ["热门直播","节目回看","武进电台"]
private let thirdSectionTitles:[String] = ["正在直播","","节目单"]
private let vcs = [ZhiBoViewController(),DianShiViewController(),GuangBoViewController()]
class PicSayViewController: TabmanViewController {
    
    var appConfigModel:AppConfigModel?{
        didSet{
            
        }
    }
    
    //MARK: - 懒加载
    lazy var searchBar: UISearchBar = {
            let bar = UISearchBar()
    //        bar.backgroundColor = .clear
            bar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.setImage(#imageLiteral(resourceName: "fdj_icon"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
            // bar.placeholder = "请输入商品名称，优惠内容"
            bar.delegate = self
            
            let searchField = bar.getSearchTextField()
            searchField.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickSearchBar)))
            //let placeHolderLabel = searchField.value(forKey: "placeholderLabel") as! UILabel
            searchField.layer.cornerRadius = 18
            searchField.layer.masksToBounds = true
            searchField.backgroundColor = .white
            searchField.attributedPlaceholder = NSMutableAttributedString.init(string: "请输入商品名称，优惠内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)])
            //placeHolderLabel.font = UIFont.systemFont(ofSize: 13)
            //添加单击手势识别
            bar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickSearchBar)))
            return bar
        }()
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
//         Do any additional setup after loading the view.
        
//
//        // Create bar
//        let bar = TMBar.ButtonBar()
////        bar.layout.transitionStyle = .snap // Customize
//
//        // Add to view
//        addBar(bar, dataSource: self, at: .top)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
//MARK: - 设置UI
extension PicSayViewController{
    private func setUI() {
        //1.设置导航栏
        self.view.backgroundColor = .white
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(r: 127, g: 125, b: 201, alpha: 1), size: (self.navigationController?.navigationBar.frame.size)!), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        
//        navBarTintColor = .white
//        navBarTitleColor = .white
        navigationItem.title = "直播武进"
        self.navigationController?.navigationBar.setColors(background: .white, text: .white)
//        navigationController?.navigationBar.tintColor = .yellow
        //2.设置页卡
        addTMBar()
        setSearchBar()
    }
    
    private func setSearchBar(){
        let navBar = self.navigationController!.navigationBar
            //设置搜索框的约束
            navBar.addSubview(searchBar)
            let leftCon = NSLayoutConstraint(item: searchBar, attribute: .left, relatedBy: .equal, toItem: navBar, attribute: .left, multiplier: 1.0, constant: 20)
            let rightCon = NSLayoutConstraint(item: searchBar, attribute: .right, relatedBy: .equal, toItem: navBar, attribute: .right, multiplier: 1.0, constant: -20)
    //        let topCon = NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: navBar, attribute: .top, multiplier: 1.0, constant: 5)
            let bottomCon = NSLayoutConstraint(item: searchBar, attribute: .bottom, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1.0, constant: 2)
            navBar.addConstraints([leftCon, rightCon, bottomCon])
    //        searchBar.alpha = 0.8
            
            
            for view in searchBar.subviews{
                if view.isKind(of: UIView.self) && view.subviews.count > 0{
                    view.backgroundColor = .clear
                    //MARK: - 这段代码导致闪退,用于去除searchBar的背景，现改为将searchBar的背景设置为空图片
    //                view.subviews.item(at: 0)?.removeFromSuperview()
                }
            }
        }
    
    private func addTMBar(){
        self.dataSource = self
        topBar.layout.transitionStyle = .none
        addBar(topBar, dataSource: self, at: .top)
        
        
    }
    
    private func initData() {
        
        self.appConfigModel = globalAppConfig
    }
    
    private func requestAppConfig(){
        AppConfigViewModel.requestAppConfig { (config) in
            self.appConfigModel = config
        }
    }
    
}


//MARK: - 点击事件绑定
extension PicSayViewController{
    @objc private func clickSearchBar(){
    //        print("searchBar")
    //        self.isBackFresh = false
            let searchVC = SearchViewController()
    //        searchVC.modalPresentationStyle = .fullScreen
            let navi = MyNavigationController(rootViewController: searchVC)
    //        navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: false, completion: nil)
        }
}

//MARK: - 实现搜索框的代理协议
extension PicSayViewController:UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return false
    }
}

//MARK: - 实现TMBar的代理
extension PicSayViewController:PageboyViewControllerDataSource, TMBarDataSource{
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return vcs.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        vcs[index].secondSectionTitle = secondSectionTitles[index]
        vcs[index].thirdSectionTitle = thirdSectionTitles[index]
        vcs[index].topBarH = topBar.height
        return vcs[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: barTitles[index])
    }
    
    
}
