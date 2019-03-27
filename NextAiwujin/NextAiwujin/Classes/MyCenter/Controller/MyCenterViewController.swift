//
//  MyCenterViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwifterSwift
import SnapKit
import EFNavigationBar
private let mainTableCellID:String = "mainTableCellID"
private let headerViewH:CGFloat = finalContentViewHaveTabbarH / 11 * 4
class MyCenterViewController: BaseTrunclentViewController {
    private var barImageView:UIView?
    //lazy var navBar = EFCustomNavigationBar.CustomNavigationBar()
    //MARK: - 懒加载
    
    lazy var headNameLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .random
        label.textAlignment = .center
        label.textColor = .white
        label.text = "username"
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickHeadImage)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var headImageView: UIImageView = {
        let image = UIImageView()
//        image.frame.size = CGSize(width: 60, height: 60)
        image.image = #imageLiteral(resourceName: "personalhome_head_image_back")
        image.backgroundColor = UIColor.red
        image.layer.cornerRadius = 30
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickHeadImage)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var leftHeadImage: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.setImageForAllStates(#imageLiteral(resourceName: "my_head"))
        btn.backgroundColor = .random
        btn.addTarget(self, action: #selector(clickHeadImage), for: .touchUpInside)
        return btn
    }()
    
    lazy var headView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: -headerViewH, width: finalScreenW, height: headerViewH))
        view.image = #imageLiteral(resourceName: "me_background")
        view.contentMode = UIView.ContentMode.scaleAspectFill
        //如果要点击的View的父控件默认不消费点击事件，此时需要开启其父控件的点击事件接收机制
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var mainTableView: UITableView = {
        let table =  UITableView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: UIDevice.current.isX() ? finalScreenH - finalTabBarH - IphonexHomeIndicatorH : finalScreenH - finalTabBarH), style: UITableView.Style.plain)
        table.register(UINib(nibName: "CenterHomeCell", bundle: nil), forCellReuseIdentifier: mainTableCellID)
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = true
        table.contentInsetAdjustmentBehavior = .never
        table.showsVerticalScrollIndicator = false
        table.contentInset = UIEdgeInsets(top: headerViewH, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        navBarBackgroundAlpha = 0
        // Do any additional setup after loading the view.
//        setUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initData()
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    deinit {
        mainTableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset"{
            let offsetY = mainTableView.contentOffset.y
//            print(offsetY)
            ///定义页面外边距与页面滑动到顶部图片结束的比例
            var delta =  (offsetY + headerViewH) / (headerViewH - finalStatusBarH - finalNavigationBarH)
            //        ///通过取大值函数保证比例大于0，即只有上拉事件才会改变导航栏透明度
            delta = CGFloat.maximum(delta, 0)
            //        ///通过滑动比例改变导航栏背景的透明的，通过取小值函数保证比例不会大于1，即页面上拉超过顶部图片底部则停止改变导航栏透明度
            if delta > 0.7 {
                self.navBar.title = "我的"
                UIView.animate(withDuration: 0.2 ,animations: {[unowned self] in
                    self.navBar.leftButton.alpha = 1.0
                })
            }else{
                self.navBar.title = ""
                UIView.animate(withDuration: 0.2, animations: {[unowned self] in
                    //因为在首次进入我的页面时会有leftButton消失的动画，所以设定在offSetY>-150时才会生效
                    self.navBar.leftButton.alpha = 0
                    
                })
                
            }
            //TODO:调整左上角headImage的位置和显示方式，跳转到MyInfoVC（修复进入订单预览时地址为空则crash的bug）
            if offsetY < -headerViewH {
                UIView.animate(withDuration: 0.2, animations: {[unowned self] in
                    //因为在首次进入我的页面时会有leftButton消失的动画，所以设定在offSetY>-150时才会生效
                    if offsetY > -150 {
                        self.navBar.leftButton.alpha = 0
                    }
                    
                })
                self.headView.frame = CGRect(x: 0, y: offsetY, width: finalScreenW,
                                             height: headerViewH - offsetY - headerViewH)
            }
            navBar.setBackgroundAlpha(alpha: CGFloat.minimum(delta, 1))
            
        }
    }

}
//MARK: - 设置ui
extension MyCenterViewController{
    override func setUI() {
        //0.设置tableView
        setTableView()
        super.setUI()
        //1.设置导航栏
        setNavigatianBar()
//        ZZWWaveViewFunc()
    }
    
    override func initData() {
        super.initData()
        if AppDelegate.appUser?.id == -1 {
//            headImageView.image = UIImage(named: "user_ico")
            headNameLabel.text = "登录/注册"
        }else {
            headImageView.kf.setImage(with: URL.init(string: BASE_URL + (AppDelegate.appUser?.head_ico)!), placeholder: UIImage.init(named: "personalhome_head_image_back"))
            headNameLabel.text = AppDelegate.appUser?.username
        }
    }
    
    private func setTableView(){
        headView.addSubview(headNameLabel)
        
        headView.addSubview(headImageView)
        headImageView.snp.makeConstraints { (con) in
            con.centerX.centerY.equalToSuperview()
            con.width.height.equalTo(60)
        }
        headNameLabel.snp.makeConstraints { (con) in
            con.width.equalTo(100)
            con.height.equalTo(30)
            con.top.equalTo(headImageView.snp.bottom).offset(5)
            con.centerX.equalToSuperview()
        }

        self.view.addSubview(mainTableView)
        self.mainTableView.addSubview(headView)
        mainTableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    private func setNavigatianBar(){
        self.navigationController?.navigationBar.isTranslucent = true
        //初始化导航栏头像并隐藏
        navBar.leftButton.imageView?.contentMode = .scaleAspectFit
        
        navBar.setLeftButton(image: #imageLiteral(resourceName: "personalhome_head_image_back"))
        navBar.leftButton.snp.makeConstraints { (make) in
            make.left.equalTo(navBar.snp.left).offset(10)
            make.width.height.equalTo(navBar.snp.height).multipliedBy(0.4)
            make.bottom.equalTo(navBar.snp.bottom).offset(-10)
        }
        
        navBar.onClickLeftButton = {
            let myInfoVC = MyInfoViewController()
            self.pushToVC(vc: myInfoVC)
        }
        //alpha=0时UIButton不可点击
        navBar.leftButton.alpha = 0
    }
    
    func ZZWWaveViewFunc()  {
        let colors1 = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6).cgColor]
        let sColors1 = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.45).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.45).cgColor]
        let waveView1 = ZZWWaveView.init(frame: CGRect(x: -30.0, y: headerViewH - 100, width: finalScreenW + 60, height: 100.0))
        self.headView.addSubview(waveView1)
        waveView1.waveSpeed = CGFloat(0.1 / .pi)
        waveView1.waveViewType = .OvalType
        waveView1.colors = colors1
        waveView1.sColors = sColors1
        waveView1.percent = 0.4
        waveView1.waveGrowth = 10
        waveView1.startWave()
        let colors2 = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.35).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.35).cgColor]
        let sColors2 = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor,#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2).cgColor]
        let waveView2 = ZZWWaveView.init(frame: CGRect(x: -30.0, y: headerViewH - 200, width: finalScreenW + 60, height: 200.0))
        self.headView.addSubview(waveView2)
        waveView2.waveSpeed = CGFloat(0.04 / .pi)
        waveView2.waveViewType = .OvalType
        waveView2.colors = colors2
        waveView2.sColors = sColors2
        waveView2.percent = 0.4
        waveView2.waveGrowth = 10
        waveView2.startWave()
    }
}

//MARK: - tableView的数据源协议和代理协议
extension MyCenterViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return finalContentViewHaveTabbarH / 3 * 2 / 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: mainTableCellID, for: indexPath) as? CenterHomeCell
//        cell?.backgroundColor = .random
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: mainTableCellID) as? CenterHomeCell
        }else{
            cell?.name.text = ""
            cell?.iconImage.image = nil
        }
        switch indexPath.row {
        case 0:
            cell?.name.text = "商品订单"
            cell?.iconImage?.image = #imageLiteral(resourceName: "订单")
        case 1:
            cell?.name.text = "地址管理"
            cell?.iconImage?.image = #imageLiteral(resourceName: "地址")
        case 2:
            cell?.name.text = "个人资料"
            cell?.iconImage?.image = #imageLiteral(resourceName: "个人资料")
        case 3:
            cell?.name.text = "修改密码"
            cell?.iconImage?.image = #imageLiteral(resourceName: "修改密码")
        default:
            break
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //print("我的订单")
            let orderVC = MyOrdersViewController()
            pushToVC(vc: orderVC)
            break
        case 1:
            //print("地址管理")
            let addressVC = MyAddressViewController()
            pushToVC(vc: addressVC)
            break
        case 2:
            //print("个人资料")
            let myInfoVC = MyInfoViewController()
            pushToVC(vc: myInfoVC)
            break
        case 3:
            //print("修改密码")
            let changePasswordVC = ChangePasswordViewController()
            pushToVC(vc: changePasswordVC)
            break
        default:
            break
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
    
}

//MARK: - 点击事件
extension MyCenterViewController{
    private func pushToVC(vc: UIViewController){
        //vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
//        self.navigationController?.show(vc, sender: self)
    }
    
    @objc private func clickHeadImage(){
        let myInfoVC = MyInfoViewController()
        self.pushToVC(vc: myInfoVC)
    }
}
