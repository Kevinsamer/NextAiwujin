//
//  ZhiBoBaseViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/16.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SBCycleScrollView
import Kingfisher
import PullToRefreshKit
class ZhiBoBaseViewController: BaseViewController {
    let bannerH:CGFloat = 150
    let tableCellID:String = "tableCellID"
    let collCellID:String = "collCellID"
    let guangboCellID:String = "guangboCellID"
    let zhiboCellID:String = "zhiboCellID"
    let dianshiCellID:String = "dianshiCellID"
    var urls:[String] = ["https://ss3.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=8493682d0233874483c5297c610ed937/55e736d12f2eb938e9e74c8fdb628535e4dd6fc0.jpg","https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=f888027cebdde711f8d245f697eecef4/71cf3bc79f3df8dcfcea3de8c311728b461028f7.jpg","https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=d8d48aa8a151f3dedcb2bf64a4eff0ec/4610b912c8fcc3ce863f8b519c45d688d53f20d0.jpg"]
    //第二段的标题
    var secondSectionTitle:String = ""
    //第三段的标题
    var thirdSectionTitle:String = ""
    //顶部页卡的高度
    var topBarH:CGFloat = 0
    //直播页的数据
    var ZhiBoData:CH2Model = globalAppConfig.CH2
    //电视页的数据
    var TVData:CH3Model = globalAppConfig.CH3
    //广播页的数据
    var GuangBoData:CH4Model = globalAppConfig.CH4
    //banner推荐数据（CHO每个item的第一条）
    var TuiJianData:CH0Model = globalAppConfig.CH0{
        didSet{
            self.topBanner.imageURLStringsGroup = []
            self.topBanner.titlesGroup = []
            for url in self.TuiJianData.Channel[3].Item {
                self.topBanner.imageURLStringsGroup.append(url.titlepic)
                self.topBanner.titlesGroup.append(url.title)
            }
        }
    }
    //MARK: - 懒加载
    lazy var topBanner: CycleScrollView = {
        var options = CycleOptions()
        options.scrollTimeInterval = 3.0
//        options.pageAliment = PageControlAliment.center
//        options.imageViewMode = .scaleToFill
//        options.pageStyle = .jalapeno
        options.bottomOffset = options.titleLabelHeight
        options.textAlignment = .center
        options.showPageControl = false
        let banner = CycleScrollView.initScrollView(frame: CGRect(x: 0, y: 10, width: finalScreenW, height: bannerH), delegate: self, placehoder: #imageLiteral(resourceName: "loading"), cycleOptions: options)
        
        return banner
    }()
    
    ///主体tableView
    lazy var mainTable: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 51, width: finalScreenW, height: finalContentViewHaveTabbarH - topBarH), style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: tableCellID)
        table.register(UINib(nibName: "GuangboCell", bundle: nil), forCellReuseIdentifier: guangboCellID)
        table.register(UINib(nibName: "ZhiBoCell", bundle: nil), forCellReuseIdentifier: zhiboCellID)
        table.register(UINib(nibName: "DianshiCell", bundle: nil), forCellReuseIdentifier: dianshiCellID)
        table.contentInsetAdjustmentBehavior = .never
        table.separatorStyle = .none
        table.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        return table
    }()
    
    ///第二段的横向collectionView
    lazy var secondCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110 * 5 / 7, height: 110)
        layout.minimumLineSpacing = 0
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 110), collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.register(UINib(nibName: "SecondSectionCell", bundle: nil), forCellWithReuseIdentifier: collCellID)
        coll.alwaysBounceHorizontal = true
        coll.backgroundColor = .white
        coll.showsHorizontalScrollIndicator = false
        return coll
    }()
    
    ///顶部刷新提示信息view
    lazy var header: DefaultRefreshHeader = {
        let header = DefaultRefreshHeader.header()
        header.setText("下拉刷新", mode: .pullToRefresh)
        header.setText("释放刷新", mode: .releaseToRefresh)
        header.setText("数据刷新成功", mode: .refreshSuccess)
        header.setText("刷新中...", mode: .refreshing)
        header.setText("数据刷新失败，请检查网络设置", mode: .refreshFailure)
        header.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).lighten()
        header.imageRenderingWithTintColor = true
        header.durationWhenHide = 0.4
        
        return header
    }()
    
    ///底部刷新提示信息view
    lazy var footer: DefaultRefreshFooter = {
        let footer = DefaultRefreshFooter.footer()
        footer.setText("上拉加载更多", mode: .pullToRefresh)
        footer.setText("——— 我是有底线的 ———", mode: .noMoreData)
        footer.textLabel.font = UIFont.systemFont(ofSize: 10)
        footer.setText("加载中...", mode: .refreshing)
        footer.setText("点击加载更多", mode: .tapToRefresh)
        footer.textLabel.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).lighten()
        footer.refreshMode = .scroll
        return footer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
//MARK: - 设置ui
extension ZhiBoBaseViewController{
    override func setUI() {
        super.setUI()
        self.navigationController?.navigationBar.isTranslucent = false
//        self.view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
//        topBanner.imageURLStringsGroup = urls
//        topBanner.imageNamesGroup = ["loading","loading","loading"]
        self.view.addSubview(mainTable)
        mainTable.configRefreshHeader(with: header, container: self) {
            self.initData()
            self.secondCollView.reloadData()
//            self.topBanner.imageURLStringsGroup = []
//            self.topBanner.imageURLStringsGroup = self.urls
//            self.mainTable.switchRefreshHeader(to: HeaderRefresherState.refreshing)
            
        }
        mainTable.configRefreshFooter(with: footer, container: self) {
            self.mainTable.switchRefreshFooter(to: FooterRefresherState.noMoreData)
        }
        mainTable.switchRefreshHeader(to: HeaderRefresherState.refreshing)
//        self.view.addSubview(topBanner)
//        self.view.addSubview(topBannerControl)
//        topBanner.snp.makeConstraints { (make) in
//            make.width.equalTo(finalScreenW)
//            make.height.equalTo(bannerH)
//            make.left.equalTo(self.view.snp.left)
//            make.top.equalTo(self.view.snp.top).offset(52)
//        }
    }
    
    override func initData() {
        super.initData()
        AppConfigViewModel.requestAppConfig { (appConfig) in
            self.ZhiBoData = appConfig.CH2
            self.TVData = appConfig.CH3
            self.GuangBoData = appConfig.CH4
            self.TuiJianData = appConfig.CH0
        }
    }
}
//MARK: - 点击事件
extension ZhiBoBaseViewController:CycleScrollViewDelegate{
    func didSelectedCycleScrollView(_ cycleScrollView: CycleScrollView, _ Index: NSInteger) {
        //webView链接
        let url = self.TuiJianData.Channel[3].Item[Index].titleurl
        let vc = NewsDetailViewController()
        vc.newsDetailURL = url
        vc.sharePicURL = self.TuiJianData.Channel[3].Item[Index].titlepic
        vc.textShare = self.TuiJianData.Channel[3].Item[Index].title
        self.navigationController?.show(vc, sender: self)
    }
}

//MARK: - 实现UITableView的代理
extension ZhiBoBaseViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if thirdSectionTitle == "" {
            //去除底部多余的空白cell
            tableView.tableFooterView = UIView(frame: .zero)
            return 2
            
        }else {
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 20
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath)
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                cell.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                cell.addSubview(topBanner)
            }
            break
        case 1:
            cell.backgroundColor = .white
            cell.removeSubviews()
            if indexPath.row == 0 {
                let imageV = UIImageView(frame: CGRect(x: 10, y: cell.frame.height/4, width: 5, height: cell.frame.height/2))
                imageV.image = #imageLiteral(resourceName: "redline")
                let label = UILabel(frame: CGRect(x: 20, y: cell.frame.height/4, width: 100, height: cell.frame.height/2))
//                label.font = UIFont.systemFont(ofSize: 60)
                label.adjustsFontSizeToFitWidth = true
                label.backgroundColor = .white
                label.text = secondSectionTitle
//                label.backgroundColor = .yellow
                cell.addSubview(label)
                cell.addSubview(imageV)
//                cell.backgroundColor = .blue
            }else if indexPath.row == 1 && secondSectionTitle != "节目回看"{
                let alphaView = UIView(frame: CGRect(x: 0, y: 110, width: finalScreenW, height: 10))
                alphaView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                cell.addSubview(alphaView)
                cell.addSubview(secondCollView)
            }
            break
        case 2:
            cell.backgroundColor = .random
            cell.removeSubviews()
            if indexPath.row == 0 {
                let imageV = UIImageView(frame: CGRect(x: 10, y: cell.frame.height/4, width: 5, height: cell.frame.height/2))
                imageV.image = #imageLiteral(resourceName: "redline")
                let label = UILabel(frame: CGRect(x: 20, y: cell.frame.height/4, width: 100, height: cell.frame.height/2))
                
                //                label.font = UIFont.systemFont(ofSize: 60)
                label.adjustsFontSizeToFitWidth = true
                label.backgroundColor = .white
                label.text = thirdSectionTitle
//                label.backgroundColor = .yellow
                cell.addSubview(label)
                cell.addSubview(imageV)
                cell.backgroundColor = .white
//                cell.backgroundColor = .red
            }
            break
        default:
            break
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return bannerH + 20
            }
            
        case 1:
            if indexPath.row == 0{
                return 40
            }else {
                return 120
            }
        case 2:
            if indexPath.row == 0{
                return 40
            }
            break
        case 3:
            if indexPath.row == 0{
                return 50
            }
            break
            
        default:
            break
        }
        return 50
    }
    
}

//MARK: - collectionView的代理
extension ZhiBoBaseViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCellID, for: indexPath) as! SecondSectionCell
//        cell.backgroundColor = .random
        return cell
    }
    
    
}
