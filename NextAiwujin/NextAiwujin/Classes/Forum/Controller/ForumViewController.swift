//
//  ForumViewController.swift
//  NextAiwujin
//  报料VC
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import PullToRefreshKit
import SnapKit
import SwifterSwift
class ForumViewController: BaseViewController {
    private let baoLiaoCellID:String = "baoLiaoCellID"
    
    var newsList:[ReportListModel] = [] {
        didSet{
            self.baoliaoTable.reloadData{
                self.baoliaoTable.switchRefreshHeader(to: HeaderRefresherState.normal(.success, 0))
                
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
    
    lazy var baoliaoTable: UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.dataSource = self
        table.delegate = self
        //设置cell的分隔线
        //table.separatorStyle = .none
        //去除底部多余的cell
        table.tableFooterView = UIView()
        //table.register(UITableViewCell.self, forCellReuseIdentifier: baoLiaoCellID)
        table.register(UINib(nibName: "BaoLiaoTableCellTableViewCell", bundle: nil), forCellReuseIdentifier: baoLiaoCellID)
        return table
    }()
    
    lazy var addNewReportBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImageForAllStates(#imageLiteral(resourceName: "添加"))
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .white
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowRadius = 5.0
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
//        btn.addShadow()
        btn.addTarget(self, action: #selector(addNewReport), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的报料"
        self.navigationController?.navigationBar.isTranslucent = false
        
    }

}

//MARK: - 设置UI
extension ForumViewController {
   
    override func setUI() {
        super.setUI()
        //1.设置爆料列表
        setTableView()
        //2.设置新增报料按钮
        setAddNewReportButton()
    }
    
    private func setAddNewReportButton(){
        self.view.addSubview(addNewReportBtn)
        addNewReportBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(UIDevice.current.isX() ? -IphonexHomeIndicatorH - finalTabBarH - finalScreenH / 10 : -finalTabBarH - finalScreenH / 10)
            make.width.height.equalTo(50)
        }
    }
    
    private func setTableView(){
        self.view.addSubview(baoliaoTable)
        baoliaoTable.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        baoliaoTable.configRefreshHeader(with: header, container: self) {
                    self.initData()
//                    self.secondCollView.reloadData()
        //            self.topBanner.imageURLStringsGroup = []
        //            self.topBanner.imageURLStringsGroup = self.urls
        //            self.mainTable.switchRefreshHeader(to: HeaderRefresherState.refreshing)
                    
        }
        baoliaoTable.configRefreshFooter(with: footer, container: self) {
            self.baoliaoTable.switchRefreshFooter(to: FooterRefresherState.noMoreData)
        }
        self.baoliaoTable.switchRefreshHeader(to: HeaderRefresherState.refreshing)
        self.baoliaoTable.switchRefreshFooter(to: FooterRefresherState.noMoreData)
    }
    
    override func initData() {
        super.initData()
        BaoLiaoViewModel.requestNewsList { (newsList) in
            self.newsList = newsList
        }
    }
    
}

//MARK: - 报料Table的数据源协议和代理协议
extension ForumViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: baoLiaoCellID, for: indexPath) as! BaoLiaoTableCellTableViewCell
//        cell.backgroundColor = UIColor.random
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        zoomBtn(缩放比例: 0.01, 透明度: 0)
    }
    
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        //print("begin scroll")
//        zoomBtn(缩放比例: 0.01, 透明度: 0)
//
//    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //print("end scroll")
        zoomBtn(缩放比例: 1, 透明度: 1)
    }
    
    /// 缩放按钮
    /// - Parameters:
    ///   - scale: 缩放比例，缩小为0，放大为1
    ///   - alpha: 透明度
    private func zoomBtn(缩放比例 scale: CGFloat, 透明度 alpha: CGFloat){
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.addNewReportBtn.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.addNewReportBtn.alpha = alpha
        }
    }
}

//MARK: - 点击事件
extension ForumViewController {
    @objc func addNewReport(){
        let vc = BaoLiaoViewController()
        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: {
            self.initData()
        })
    }
}
