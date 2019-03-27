//
//  SearchResultController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/11.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwiftEventBus
import Kingfisher
import PullToRefreshKit
import SnapKit

private var collectionItemW = ( finalScreenW - 3 ) / 2
private var collectionItemH:CGFloat = 230
private var cellID = "cellID"
private let listCellID = "listCellID"
private let collCellID = "collCellID"
private let historyCellID:String = "historyCellID"

class SearchResultController: BaseViewController {

    ///搜索框存在标志位
    private var isSearchBarHere:Bool = false
    ///接收搜索结果
    var keys:String = ""{
        didSet{
            self.searchBar.text = keys
        }
    }
    ///分类类别id
    var category:ChannelInfo = ChannelInfo(){
        didSet{
            
        }
    }
    private var currentPage = 1//当前页
    private var maxNumPerPage = 21//每页数据最多条数
    private var searchResultViewModel : SearchResultViewModel = SearchResultViewModel()
    ///导航栏的背景图片
    private var barImageView:UIView?
    ///商城首页vc，用于控制其导航栏的透明度
    var shopHomeVC:RadioStationViewController?
    private var searchResults:[SearchResultModel]?{
        didSet{
            if searchResults != nil {
                noDataLabel.removeFromSuperview()
            }else{
                //nil展示无数据页
                self.collectionView.switchRefreshFooter(to: FooterRefresherState.removed)
                setNoDataView()
            }
            self.collectionView.reloadData()
        }
    }
    private var categoryResults:[SearchResultModel]?{
        didSet{
            if categoryResults != nil && categoryResults?.count != 0 {
                noDataLabel.removeFromSuperview()
                
            }else {
                //nil展示无数据页
                self.collectionView.switchRefreshFooter(to: FooterRefresherState.removed)
                setNoDataView()
            }
            self.collectionView.reloadData()
        }
    }
    
//    override init(collectionViewLayout layout: UICollectionViewLayout) {
//        super.init(collectionViewLayout: layout)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //MARK: - 懒加载
    lazy var delAlert: UIAlertController = {
        let alert = UIAlertController(title: nil, message: "确认清除历史搜索记录吗？", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: { (ok) in
            SearchHistoryCoreDataHelper.historyHelper.delAllHistory()
            self.searchHistoryTable.reloadData()
        })
        alert.addAction(okAction)
        alert.addAction(title: "取消", style: UIAlertAction.Style.cancel, isEnabled: true, handler: nil)
        return alert
    }()
    
    lazy var searchHistoryTable: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: finalContentViewNoTabbarH), style: UITableView.Style.grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: historyCellID)
        //        table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: historyHeaderID)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    lazy var collectionView: UICollectionView = {
        let coll = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y: finalStatusBarH + finalNavigationBarH), size: CGSize(width: finalScreenW, height: finalContentViewNoTabbarH)), collectionViewLayout: collLayout)
        
        //collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coll.register(UINib.init(nibName: "CollCell", bundle: nil), forCellWithReuseIdentifier: collCellID)
        coll.register(UINib.init(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: listCellID)
        coll.backgroundColor = UIColor(named: "line_gray")!
        coll.contentInsetAdjustmentBehavior = .never
        coll.delegate = self
        coll.dataSource = self
        
        coll.configRefreshHeader(with: header, container: self, action: {[unowned self] in
            if self.keys == "" {
                //keys=""时，未开始搜索，需请求分类搜索数据
                self.currentPage = 1
                self.requestCategoryResultData(cat: self.category.id, page: self.currentPage)
                coll.reloadData {
                    coll.switchRefreshHeader(to: HeaderRefresherState.normal(RefreshResult.success, 0.3))
                }
            }else {
                //keys有其他值时，请求搜索数据
                self.currentPage = 1
                self.requestSearchResultData(word: self.keys, page: self.currentPage)
                coll.reloadData {
                    coll.switchRefreshHeader(to: HeaderRefresherState.normal(RefreshResult.success, 0.3))
                }
            }
        })
        
        coll.configRefreshFooter(with: footer, container: self, action: {[unowned self] in
            if self.keys == "" {
                self.currentPage += 1
                self.requestCategoryResultData(cat: self.category.id, page: self.currentPage)
                coll.reloadData()
            }else {
                self.currentPage += 1
                self.requestSearchResultData(word: self.keys, page: self.currentPage)
                coll.reloadData()
            }
        })
        coll.switchRefreshHeader(to: HeaderRefresherState.refreshing)
        
        return coll
    }()
    
//    let searchBar = UISearchBar(frame: CGRect(x: 60, y: 5, width: 100, height: 36))
    
    lazy var titleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -2, width: finalScreenW - 100, height: 36))
//        view.backgroundColor = .black
        view.addSubview(searchBar)
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: finalScreenW - 100, height: 36))
//        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setImage(#imageLiteral(resourceName: "fdj_icon"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
        bar.placeholder = "请输入商品名称，优惠内容"
        bar.delegate = self
        bar.showsCancelButton = false
        let searchField = bar.value(forKey: "searchField") as! UITextField
        let placeHolderLabel = searchField.value(forKey: "placeholderLabel") as! UILabel
        searchField.layer.cornerRadius = 20
        searchField.layer.masksToBounds = true
        searchField.tintColor = .black
        placeHolderLabel.font = UIFont.systemFont(ofSize: 16)
        return bar
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
    
    lazy var noDataLabel: UILabel = {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: UIDevice.current.isX() ? finalScreenH - IphonexHomeIndicatorH : finalScreenH))
        let label = UILabel(frame: CGRect(origin: CGPoint.init(x: 0, y: 100), size: CGSize(width: finalScreenW, height: 60)))
        label.text = "抱歉，没有找到相关的商品"
        label.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
        label.textAlignment = NSTextAlignment.center
//        label.backgroundColor = .white
        return label
    }()
    
    
    private lazy var alphaView : UIControl = {
        //UISearchBar的蒙层
        let view = UIControl(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: UIDevice.current.isX() ? finalScreenH - IphonexHomeIndicatorH : finalScreenH))
        view.backgroundColor = .white
//        view.alpha = 0.3
        view.addTarget(self, action: #selector(dismissAlphaView), for: .touchUpInside)
        view.addSubview(searchHistoryTable)
        return view
    }()
    
    lazy var tableLayout: UICollectionViewFlowLayout = {
        //流式布局--selected
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: finalScreenW, height: finalScreenH / 6)
        layout.minimumLineSpacing = 3
        return layout
    }()
    
    lazy var collLayout: UICollectionViewFlowLayout = {
        //一行两个--normal
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionItemW, height: collectionItemH)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        //layout.headerReferenceSize = CGSize(width: finalScreenW, height: 40)
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        return layout
    }()
    
    lazy var imageButton: UIButton = {
        let imageButton = UIButton(type: UIButton.ButtonType.custom)
        imageButton.setImage(UIImage.init(named: "topBar_icon_09_01"), for: UIControl.State())
        
        imageButton.setImage(UIImage.init(named: "topBar_icon_10_01"), for: UIControl.State.selected)
        imageButton.addTarget(self, action: #selector(changeLayout), for: UIControl.Event.touchUpInside)
        return imageButton
    }()
    
    lazy var rightItem : UIBarButtonItem = {
        let item = UIBarButtonItem(customView: imageButton)
        return item
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: false)
        SwiftEventBus.unregister(self)
//        self.searchBar.removeFromSuperview()
        
//        barImageView?.alpha = 0.0
        //离开本页面开启侧滑返回
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        if let vc = shopHomeVC{
//            var delta =  (vc.mainTableView.contentOffset.y) / (topBannerH - finalStatusBarH - finalNavigationBarH)
//
//            ///通过取大值函数保证比例大于0，即只有上拉事件才会改变导航栏透明度
//            delta = CGFloat.maximum(delta, 0)
//            ///通过滑动比例改变导航栏背景的透明的，通过取小值函数保证比例不会大于1，即页面上拉超过顶部图片底部则停止改变导航栏透明度
//            vc.barImageView?.alpha = CGFloat.minimum(delta, 1)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //进入本页面禁止侧滑返回
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.alpha = 1
//        barImageView?.alpha = 1.0
//        for view in (self.navigationController?.navigationBar.subviews)! {
//            if view.isKind(of: NSClassFromString("_UIBarBackground")!){
//                view.subviews[1].isHidden = true
//            }
//        }
        
    }

}

//MARK: - 设置ui
extension SearchResultController{
     override func setUI(){
        super.setUI()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.navBarY = self.navigationController?.navigationBar.layer.position.y
        //0.初始化数据
//        initData()
        //1.设置navigationBar
        setNavigationBar()
        //2.设置collView
        setCollectionView()
//        //3.设置searchBar
        setSearchBar()
        //self.definesPresentationContext = true
    }
    
    private func setNoDataView(){
        self.collectionView.addSubview(noDataLabel)
    }
    
    override func initData(){
        super.initData()
        if keys == "" {
            //分类id初始化时赋值-111
            if category.id != -111{
//                print(category.id)
                requestCategoryResultData(cat: category.id, page: 1)
            }
        }else{
//            print(keys)
            requestSearchResultData(word: keys, page: 1)
        }
        
        
        
    }
    
    private func requestSearchResultData(word:String, page:Int){
        self.collectionView.switchRefreshHeader(to: HeaderRefresherState.refreshing)
        searchResultViewModel.requestSearchResult(word: word, page: page) {[unowned self] in
            if self.currentPage == 1 {
                self.searchResults = self.searchResultViewModel.searchResults
                if (self.searchResultViewModel.searchResults?.count) < self.maxNumPerPage {
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }else {
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.normal)
                }
                if self.searchResults != nil {
                    self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
                }
//                self.collectionView.reloadData()
            }else {
                if self.searchResultViewModel.searchResults?.count == self.maxNumPerPage && self.searchResults?.last?.id != self.searchResultViewModel.searchResults?.last?.id {
                    //如果请求到的数据条数=每页最大条数,且本页数据最后一个和请求的数据最后一个不相同，则未到最后一页
                    self.searchResults?.append(self.searchResultViewModel.searchResults!)
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.normal)
                }else if (self.searchResultViewModel.searchResults?.count)! < self.maxNumPerPage {
                    //如果请求到的数据条数<每页最大条数，则已经请求到最后一组分页数据，且该请求数据需添加至当前数据集合
                    self.searchResults?.append((self.searchResultViewModel.searchResults)!)
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }else {
                    //如果请求到的数据=每页最大条数且最后一条相同，则已请求到最后一组数据且该请求数据无需添加到当前数据集合
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }
            }
            
            //self.searchResults?.append(self.searchResultViewModel.searchResults!)
        }
    }
    
    private func requestCategoryResultData(cat:Int, page:Int){
        searchResultViewModel.requestCategoryResult(cat: cat, page: page) {[unowned self] in
            if self.currentPage == 1 {
                self.categoryResults = self.searchResultViewModel.categoryResults
                if self.searchResultViewModel.categoryResults?.count < self.maxNumPerPage {
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }else {
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.normal)
                }
                
                //                if self.categoryResults != nil {
                //                    self.collectionView?.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: false)
                //                }
//                self.collectionView.reloadData()
            }else {
                if self.searchResultViewModel.categoryResults?.count == self.maxNumPerPage {
                    //如果请求到的数据条数=每页最大条数，则未到最后一页
                    self.categoryResults?.append(self.searchResultViewModel.categoryResults!)
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.normal)
                }else if self.searchResultViewModel.categoryResults?.count < self.maxNumPerPage{
                    //如果请求到的数据条数<每页最大条数，则已经请求到最后一组分页数据,请求到的数据需添加到当前数据集合
                    self.categoryResults?.append(self.searchResultViewModel.categoryResults!)
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }else {
                    //剩余的情况是请求到的数据>=每页最大条数且最后的id相同，则表示已请求到最后一页且最后一页的数据正好是每页最大数据，请求到的数据已经重复不需要添加到当前数据集合
                    self.collectionView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
                }
            }
        }
    }
    
    private func setNavigationBar(){
        navigationItem.rightBarButtonItem = rightItem
        barImageView = self.navigationController?.navigationBar.subviews.first
    }
    
    private func setCollectionView(){
        self.view.addSubview(collectionView)
    }
    
    private func setSearchBar(){
//        navigationController?.navigationBar.addSubview(searchBar)
//        let leftCon = NSLayoutConstraint(item: searchBar, attribute: .left, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .left, multiplier: 1.0, constant: 20)
//        let rightCon = NSLayoutConstraint(item: searchBar, attribute: .right, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .right, multiplier: 1.0, constant: -65)
//        let topCon = NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .top, multiplier: 1.0, constant: 5)
//        let bottomCon = NSLayoutConstraint(item: searchBar, attribute: .bottom, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .bottom, multiplier: 1.0, constant: -10)
//        self.navigationController?.navigationBar.addConstraints([leftCon, rightCon, topCon, bottomCon])
        self.navigationItem.titleView = titleView
        
        
    }
}

extension SearchResultController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchHistoryCoreDataHelper.historyHelper.insertHistory(history: (searchBar.textField?.text)!)
        searchContent = (searchBar.textField?.text)!
        searchHistoryTable.reloadData()
        keys = searchBar.text ?? ""
        if keys != "" {
            currentPage = 1
//            searchBar.text = keys
//            searchBar.placeholder = keys
            requestSearchResultData(word: keys, page: currentPage)
        }
        dismissAlphaView()
//        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.view?.addSubview(alphaView)
        return true
    }
    
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        keys = searchText
    //    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        dismissAlphaView()
//    }
    
}

extension SearchResultController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if keys != ""  {
            if let results = searchResults{
                let vc = GoodDetailViewController(goodsID: results[indexPath.row].id)
                //            self.navigationBarLayer?.position.y = self.navBarY!
                //self.searchBarLayer?.position.y = self.searchBarY!
                self.navigationItem.hidesBackButton = false
                //            self.navigationItem.title = "搜索结果"
                self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
                navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if let results = categoryResults {
                let vc = GoodDetailViewController(goodsID: results[indexPath.row].id)
                //            self.navigationBarLayer?.position.y = self.navBarY!
                //self.searchBarLayer?.position.y = self.searchBarY!
                self.navigationItem.hidesBackButton = false
                //            self.navigationItem.title = "搜索结果"
                self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //动画隐藏显示导航栏
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        //        print(velocity.y)
//        //        print(scrollView.contentOffset.y)
//        if velocity.y > 0 {
//            //隐藏搜索框
//            //            navigationBarLayer?.add(naviMissAnimate, forKey: "missNavi")
//            //            searchBarLayer?.add(searchBarMissAnimate, forKey: "searchMiss")
//            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
//                self.navigationBarLayer?.position.y = self.navBarY! - finalNavigationBarH
//                //self.searchBarLayer?.position.y = self.searchBarY! - finalNavigationBarH
//                self.navigationItem.hidesBackButton = true
//                self.navigationItem.title = ""
//                self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
//            })
//            //navigationController?.setNavigationBarHidden(true, animated: true)
//        }else{
//            //显示
//
//            //            navigationBarLayer?.add(naviShowAnimate, forKey: "showNavi")
//            //            searchBarLayer?.add(searchBarShowAnimate, forKey: "searchShow")
//            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
//                self.navigationBarLayer?.position.y = self.navBarY!
//                //self.searchBarLayer?.position.y = self.searchBarY!
//                self.navigationItem.hidesBackButton = false
//                self.navigationItem.title = "搜索结果"
//                self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
//            })
//            //navigationController?.setNavigationBarHidden(false, animated: true)
//
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys == "" ? categoryResults?.count ?? 0 : searchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if imageButton.isSelected {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellID, for: indexPath) as! ListCell
            cell.backgroundColor = UIColor.white
            if keys == "" {
                if let results = categoryResults {
                    cell.ImageView.kf.setImage(with: URL.init(string: BASE_URL + "\(results[indexPath.row].img)"), placeholder: UIImage.init(named: "loading"))
                    cell.GoodsInfo.text = "\(results[indexPath.row].name)"
                    cell.NewPrice.text = "￥\(results[indexPath.row].sell_price)"
                    cell.OldPrice.attributedText = YTools.textAddMiddleLine(text: "￥\(results[indexPath.row].market_price)")
                }
            }else {
                if let results = searchResults {
                    cell.ImageView.kf.setImage(with: URL.init(string: BASE_URL + "\(results[indexPath.row].img)"), placeholder: UIImage.init(named: "loading"))
                    cell.GoodsInfo.text = "\(results[indexPath.row].name)"
                    cell.NewPrice.text = "￥\(results[indexPath.row].sell_price)"
                    cell.OldPrice.attributedText = YTools.textAddMiddleLine(text: "￥\(results[indexPath.row].market_price)")
                }
            }
            
            
            //print("\(indexPath.row)")
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCellID, for: indexPath) as! CollCell
            cell.backgroundColor = UIColor.white
            if keys == "" {
                if let results = categoryResults {
                    cell.ImageView.kf.setImage(with: URL.init(string: BASE_URL + "\(results[indexPath.row].img)"), placeholder: UIImage.init(named: "loading"))
                    cell.GoodsInfo.text = "\(results[indexPath.row].name)"
                    cell.NewPrice.text = "￥\(results[indexPath.row].sell_price)"
                    cell.OldPrice.attributedText = YTools.textAddMiddleLine(text: "￥\(results[indexPath.row].market_price)")
                }
            }else {
                if let results = searchResults {
                    cell.ImageView.kf.setImage(with: URL.init(string: BASE_URL + "\(results[indexPath.row].img)"), placeholder: UIImage.init(named: "loading"))
                    cell.GoodsInfo.text = "\(results[indexPath.row].name)"
                    cell.NewPrice.text = "￥\(results[indexPath.row].sell_price)"
                    cell.OldPrice.attributedText = YTools.textAddMiddleLine(text: "￥\(results[indexPath.row].market_price)")
                }
            }
            return cell
        }
    }
}
//MARK: - 响应事件
extension SearchResultController {
    @objc private func changeLayout(){
        imageButton.isSelected = !imageButton.isSelected
        if imageButton.isSelected {
            collectionView.collectionViewLayout = tableLayout
            collectionView.reloadData()
        }else{
            collectionView.collectionViewLayout = collLayout
            collectionView.reloadData()
        }
        
    }
    
    @objc private func dismissAlphaView(){
        self.searchBar.endEditing(true)
        alphaView.removeFromSuperview()
    }
    
    @objc private func delAllHistory(){
        self.present(delAlert, animated: true, completion: nil)
    }
}

//MARK: - 搜索历史tableView的代理协议和数据源协议
extension SearchResultController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 60))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 150, height: 40))
        label.text = "历史搜索"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        view.addSubview(label)
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: finalScreenW - 40, y: 20, width: 20, height: 20)
        btn.setImageForAllStates(#imageLiteral(resourceName: "delete_history_words"))
        btn.addTarget(self, action: #selector(delAllHistory), for: .touchUpInside)
        view.addSubview(btn)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchHistoryCoreDataHelper.historyHelper.getHistory().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //记录搜索历史
        SearchHistoryCoreDataHelper.historyHelper.insertHistory(history: (tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
        searchContent = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        keys = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        if keys != "" {
            currentPage = 1
            searchBar.text = keys
//            searchBar.placeholder = keys
            requestSearchResultData(word: keys, page: currentPage)
        }
        self.searchHistoryTable.reloadData()
        dismissAlphaView()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCellID, for: indexPath)
        cell.backgroundColor = .white
        cell.textLabel?.text = SearchHistoryCoreDataHelper.historyHelper.getHistory()[SearchHistoryCoreDataHelper.historyHelper.getHistory().count - indexPath.row - 1].history
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
}
