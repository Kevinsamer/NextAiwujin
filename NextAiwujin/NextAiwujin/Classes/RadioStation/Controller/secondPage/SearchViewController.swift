//
//  SearchViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/8.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class SearchViewController:BaseViewController{
    ///导航栏的背景图片
    private var barImageView:UIView?
    
    //MARK: - 懒加载
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setImage(#imageLiteral(resourceName: "fdj_icon"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
        bar.placeholder = "请输入商品名称，优惠内容"
        bar.delegate = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let searchField = searchBar.value(forKey: "searchField") as! UITextField
        let placeHolderLabel = searchField.value(forKey: "placeholderLabel") as! UILabel
        searchField.layer.cornerRadius = searchField.frame.height / 2
        searchField.layer.masksToBounds = true
        placeHolderLabel.font = UIFont.systemFont(ofSize: 13)
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
        UIView.animate(withDuration: 0.01, animations: {[unowned self] in
            self.searchBar.transform = CGAffineTransform(scaleX: 0.8, y: 1)
        }) {[unowned self] (finished) in
            if finished {
                UIView.animate(withDuration: 0.1, animations: {
                    self.searchBar.transform = CGAffineTransform.identity
                }, completion: {[unowned self] (finished) in
                    if finished {
                        self.searchBar.becomeFirstResponder()
                    }
                })
//                UIView.animate(withDuration: 0.1, animations: {
//                    self.searchBar.transform = CGAffineTransform.identity
//                })
            }
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
        searchBar.resignFirstResponder()
    }
}


//MARK: - 点击事件
extension SearchViewController{
    @objc private func cancelButtonClicked(){
        self.dismiss(animated: false, completion: nil)
    }
}
