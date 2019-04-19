//
//  TVHuiKanController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/19.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import PullToRefreshKit
import Kingfisher
class TVHuiKanController: BaseViewController {
    let huikanCellID:String = "huikanCellID"
    var requestURL:String = ""{
        didSet{
            
        }
    }
    var tvs:[CH3ProgramVideoModel] = []{
        didSet{
            mainTable.reloadData{
                self.mainTable.switchRefreshHeader(to: HeaderRefresherState.normal(.success, 0.5))
            }
        }
    }
    
    //MARK: - 懒加载
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
    
    lazy var mainTable: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: finalContentViewNoTabbarH), style: UITableView.Style.plain)
        table.contentInsetAdjustmentBehavior = .never
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        table.register(UINib(nibName: "DianshiCell", bundle: nil), forCellReuseIdentifier: huikanCellID)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
//MARK: - 设置ui
extension TVHuiKanController{
    override func setUI() {
        super.setUI()
//        self.navigationItem.title = "节目回看"
        self.view.addSubview(mainTable)
        mainTable.configRefreshHeader(with: header, container: self) {
            self.initData()
        }
        mainTable.configRefreshFooter(with: footer, container: self) {
            self.mainTable.switchRefreshFooter(to: FooterRefresherState.noMoreData)
        }
        mainTable.switchRefreshHeader(to: HeaderRefresherState.refreshing)
    }
    
    override func initData() {
        super.initData()
        if self.requestURL != ""{
            AppConfigViewModel.requestTVHuiKan(url: self.requestURL) { (tvs) in
                self.tvs = tvs
            }
        }
        
    }
}

//MARK: - 实现tableView的代理
extension TVHuiKanController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: huikanCellID, for: indexPath) as! DianshiCell
//        cell.removeSubviews()
        cell.backgroundColor = .white
        if tvs.count > 0{
            cell.imageV.kf.setImage(with: URL.init(string: "\(tvs[indexPath.row].totalImagePath)"), placeholder: UIImage.init(named: "loading"))
            cell.nameLabel.text = tvs[indexPath.row].title
            cell.updateTimeLabel.text = "发布时间： \(YTools.dateToString(date: Date.init(timeIntervalSince1970: Double(tvs[indexPath.row].newstime)!)))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
