//
//  ChildViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/13.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwifterSwift
import PullToRefreshKit
import Kingfisher
import WebKit
import SkeletonView
let newsCellID:String = "newsCellID"
let topBarH:CGFloat = 50.333333333333336
class ChildViewController: BaseViewController {
    ///当前页,共150条数据，每页10条，共15页
    var currentPage:Int = 1{
        didSet{
//            print(currentPage)
        }
    }
    ///请求地址
    var url:String = ""
    ///当前页数据
    var menu:CH1MenuModel?{
        didSet{
            
        }
    }
    ///news数组
    var news:[CH1MenuItemModel]? = []{
        didSet{
//            print(self.news?.count)
//            self.newsTabelView.hideSkeleton()
            newsTableView.reloadData{
                self.newsTableView.switchRefreshHeader(to: .normal(.success, 0.5))

            }
        }
    }
    //MARK: - 懒加载
    lazy var newsTableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: topBarH, width: finalScreenW, height: finalContentViewHaveTabbarH - topBarH), style: UITableView.Style.plain)
        table.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: newsCellID)
        //        table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: historyHeaderID)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.contentInsetAdjustmentBehavior = .never
        
//        table.isSkeletonable = false
//        table.backgroundView?.isSkeletonable = false
        return table
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
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //当前数据获取逻辑：进入页面时news数组为空，判断如果为空则延迟1s后请求news数据，刷新tableview
        if self.news?.count == 0 {
            newsTableView.switchRefreshHeader(to: HeaderRefresherState.refreshing)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.requestNews()
            }
        }
    }
    
}
//MARK: - 设置UI
extension ChildViewController{
    internal override func setUI(){
        super.setUI()
        self.view.backgroundColor = .random
        setTableView()

    }
    
    private func setTableView(){
        newsTableView.configRefreshHeader(with: header, container: self, action: {
            self.currentPage = 1
            self.requestNews()
            self.newsTableView.switchRefreshFooter(to: FooterRefresherState.normal)
        })
        newsTableView.configRefreshFooter(with: footer, container: self, action: {
            if self.currentPage < 15 {
                
                self.newsTableView.switchRefreshFooter(to: FooterRefresherState.normal)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//                    self.newsTableView.switchRefreshFooter(to: FooterRefresherState.refreshing)
//                })
                self.currentPage += 1
                self.newsTableView.reloadData()
                
            }else{
                self.newsTableView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
            }
        })
        self.view.addSubview(newsTableView)
    }
    
    override func initData(){
        super.initData()
        
    }
    
    private func requestNews(){
        
        AppConfigViewModel.requestCH1Items(url: url) { (news) in
            self.news = news
        }
    }
}

extension ChildViewController:SkeletonTableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count == 0 ? 10 : (currentPage * 10 > news?.count ? news?.count ?? 10 : currentPage * 10)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return newsCellID
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count == 0 ? 10 : (currentPage * 10 > news?.count ? news?.count ?? 10 : currentPage * 10)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellID, for: indexPath) as! NewsViewCell
//        cell.backgroundColor = .random
//        print(news?[indexPath.row].titleurl)
//        cell.newsImageView.showAnimatedSkeleton()
//        cell.newsImageView.stopSkeletonAnimation()
//        cell.showAnimatedGradientSkeleton()
        
//        ▇▇▇▇▇▇▇▇▇▇
//        if cell.newsTitle.text != "" || cell.newsTitle.text != " "{
//            cell.hideSkeleton()
//        }
        
//        print(cell.isSkeletonActive)
        if self.news?.count > 0 {
            cell.hideSkeleton()
            cell.newsImageView.kf.setImage(with: URL(string: self.news?[indexPath.row].titlepic ?? ""),options: [.transition(.fade(0.5))])
            //                    cell.newsImageView.kf.setImage(with: URL(string: self.news?[indexPath.row].titlepic ?? ""), placeholder: #imageLiteral(resourceName: "loading"))
            cell.newsTitle.text = "\(self.news?[indexPath.row].title ?? "")"
            cell.videoTag.isHidden = news?[indexPath.row].isVideo == "1" ? false : true
            cell.videoTag.layer.cornerRadius = 5
        }
        
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NewsDetailViewController()
        vc.newsDetailURL = news![indexPath.row].titleurl
        vc.sharePicURL = news![indexPath.row].titlepic
        vc.textShare = news![indexPath.row].title
//        vc.news = news?[indexPath.row]
        self.navigationController?.show(vc, sender: self)
    }
    
}
