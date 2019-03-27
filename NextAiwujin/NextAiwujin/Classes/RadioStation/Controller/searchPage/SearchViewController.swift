//
//  SearchViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/8.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import CoreData
private let historyCellID:String = "historyCellID"
class SearchViewController:BaseViewController{
    ///导航栏的背景图片
    private var barImageView:UIView?
    ///搜索框存在标志位
    private var isSearchBarHere:Bool = false
    
    
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
        let table = UITableView(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalContentViewNoTabbarH), style: UITableView.Style.grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: historyCellID)
//        table.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: historyHeaderID)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setImage(#imageLiteral(resourceName: "fdj_icon"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
        bar.placeholder = "请输入商品名称，优惠内容"
        bar.delegate = self
        let searchField = bar.value(forKey: "searchField") as! UITextField
        let placeHolderLabel = searchField.value(forKey: "placeholderLabel") as! UILabel
        searchField.layer.cornerRadius = 18
        searchField.layer.masksToBounds = true
        searchField.tintColor = .blue
        placeHolderLabel.font = UIFont.systemFont(ofSize: 16)
        //添加单击手势识别
//        bar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickSearchBar)))
        return bar
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let cancelbtn = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonClicked))
        return cancelbtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //2.设置搜索框
        setSearchBar()
        setCancelButton()
        searchHistoryTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.removeFromSuperview()
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let searchField = searchBar.value(forKey: "searchField") as! UITextField
//        let placeHolderLabel = searchField.value(forKey: "placeholderLabel") as! UILabel
//        searchField.layer.cornerRadius = searchField.frame.height / 2
//        searchField.layer.masksToBounds = true
//        placeHolderLabel.font = UIFont.systemFont(ofSize: 13)
        //添加searchBar逐渐显示动画(先改变其属性，再用视图动画变回原值),动画效果不好，弃用
        //1.记录原值
//        let searchOriginWidth = searchBar.frame.width
        //2.将宽度改为较小的值
//        self.searchBar.frame.size = CGSize(width: 100, height: searchBar.frame.height)
        //3.通过视图动画改回已经记录的原值
//        UIView.animate(withDuration: 1) {[unowned self] in
//            self.searchBar.frame.size = CGSize(width: searchOriginWidth, height: self.searchBar.frame.height)
//        }
        //添加图层动画，先将其宽度缩小为0.8，然后通过CGAffineTransform.identity变回原值
        if !isSearchBarHere {
            UIView.animate(withDuration: 0.01, animations: {[unowned self] in
                self.searchBar.transform = CGAffineTransform(scaleX: 0.8, y: 1)
            }) {[unowned self] (finished) in
                if finished {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.searchBar.transform = CGAffineTransform.identity
                    }, completion: {[unowned self] (finished) in
                        if finished {
                            self.searchBar.becomeFirstResponder()
                            self.isSearchBarHere = true
                        }
                    })
                }
            }
        }else{
            self.searchBar.becomeFirstResponder()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
        searchBar.endEditing(true)
    }
}

//MARK: - 设置UI
extension SearchViewController{
    override func setUI() {
        super.setUI()
        //1.设置导航栏
        setNavigationBar()
        //2.设置搜索框
        setSearchBar()
        //3.设置取消按钮
        setCancelButton()
        //4.设置tableView
        setTableView()
    }
    
    private func setTableView(){
        self.view.addSubview(searchHistoryTable)
    }
    

    
    private func setCancelButton(){
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func setSearchBar(){
        //设置搜索框的约束
        navigationController?.navigationBar.addSubview(searchBar)
        let leftCon = NSLayoutConstraint(item: searchBar, attribute: .left, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .left, multiplier: 1.0, constant: 20)
        let rightCon = NSLayoutConstraint(item: searchBar, attribute: .right, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .right, multiplier: 1.0, constant: -65)
        let topCon = NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .top, multiplier: 1.0, constant: 5)
        let bottomCon = NSLayoutConstraint(item: searchBar, attribute: .bottom, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .bottom, multiplier: 1.0, constant: -10)
        self.navigationController?.navigationBar.addConstraints([leftCon, rightCon, topCon, bottomCon])
//        searchBar.alpha = 0.8
    }
    
    private func setNavigationBar(){
        //navigationBar的第一个子控件就是背景View
        barImageView = self.navigationController?.navigationBar.subviews.first
        //设置导航栏透明才能让SB设置的tableView的frame.x变为0，否者会自动设置内边距使得显示内容移位到导航栏下面
        self.navigationController?.navigationBar.isTranslucent = true
    }
}

//MARK: - 实现搜索框的代理协议
extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //记录搜索历史
        SearchHistoryCoreDataHelper.historyHelper.insertHistory(history: (searchBar.textField?.text)!)
        searchBar.resignFirstResponder()
        searchContent = (searchBar.textField?.text)!
//        let vc = SearchResultController(collectionViewLayout: UICollectionViewFlowLayout())
        let vc = SearchResultController()
        vc.keys = searchContent
        vc.hidesBottomBarWhenPushed = true
//        self.present(vc, animated: false, completion: nil)
        self.navigationController?.show(vc, sender: self)
    }
}


//MARK: - 点击事件
extension SearchViewController{
    @objc private func cancelButtonClicked(){
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func delAllHistory(){
        self.present(delAlert, animated: true, completion: nil)
    }
}


//MARK: - 搜索历史tableView的代理协议和数据源协议实现
extension SearchViewController:UITableViewDataSource, UITableViewDelegate{
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
        searchBar.endEditing(true)
        
        //记录搜索历史
        SearchHistoryCoreDataHelper.historyHelper.insertHistory(history: (tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
        searchBar.resignFirstResponder()
        searchContent = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        //        let vc = SearchResultController(collectionViewLayout: UICollectionViewFlowLayout())
        let vc = SearchResultController()
        vc.keys = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        vc.hidesBottomBarWhenPushed = true
        //        self.present(vc, animated: false, completion: nil)
        self.navigationController?.show(vc, sender: self)
        
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
