//
//  GoodDetailViewController.swift
//  NextAiwujin
//  商品详情页
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SnapKit
import XLPagerTabStrip
import SwiftEventBus
import EFNavigationBar

//底部bar高度
private let bottomBarH:CGFloat = 60
class GoodDetailViewController: ButtonBarPagerTabStripViewController {
    var usableViewHeight : CGFloat?
    var goodsViewModel : GoodsDetailViewModel = GoodsDetailViewModel()
    var goodsInfo:GoodInfo?
    var productSpecs:[[ProductSpec]]?//规格信息
    var goodsProducts:[GoodsProduct]?
    var goodsID:Int = 0//商品id初始化为0
    var goodVC:GoodViewController?
    var detailVC:DetailViewController?
    var commentVC:CommentViewController?
    var selectedProduct:SelectedProduct?//选择的货品
    var shopcartViewModel:ShopCartViewModel = ShopCartViewModel()
    var sendData:SendDataProtocol?
    var joinCartModel:JoinCartModel?{
        didSet{
            if let joinCart = joinCartModel {
                if joinCart.isError == false {
                    //添加成功
                    YTools.showMyToast(rootView: self.view, message: joinCart.message == "" ? "加入购物车成功" : joinCart.message)
                    addCartAnimationTarget = UIView(frame: CGRect(origin: addInToShopCartButton.center, size: CGSize(width: bottomBarH + 10, height: bottomBarH - 10)))
                    addCartAnimationTarget?.backgroundColor = .red
                    addCartAnimationTarget?.layer.cornerRadius = (bottomBarH - 10) / 2
                    self.bottomBar.addSubview(addCartAnimationTarget!)
                    addShopCartAnimate()
                }else{
                    YTools.showMyToast(rootView: self.view, message: joinCart.message)
                }
            }
        }
    }
    var addCartAnimationTarget:UIView?
    //MARK: - 懒加载
    lazy var bezierPath: UIBezierPath = {
        let path = UIBezierPath()
        path.move(to: addInToShopCartButton.center)
        path.addQuadCurve(to: shopCartButton.center, controlPoint: CGPoint(x: (addInToShopCartButton.center.x - shopCartButton.center.x) / 3 + shopCartButton.center.x, y: shopCartButton.center.y - 300))
        return path
    }()
    
    lazy var shopButton: UIButton = {
        //店铺
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: finalScreenW / 5, height: bottomBarH)
        button.setImageForAllStates(UIImage(named: "gd_shop_bottom")!)
        button.setTitleForAllStates("店铺")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColorForAllStates(.black)
        button.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        button.addTarget(self, action: #selector(shopClicked), for: UIControl.Event.touchUpInside)
        return button
    }()
    lazy var shopCartButton: UIButton = {
        //购物车   先往中间移动,添加店铺后再移回原位 原点数据finalScreenW / 5
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: finalScreenW / 9, y: 0, width: finalScreenW / 5, height: bottomBarH)
        button.setImageForAllStates(UIImage(named: "gd_cart_bottom")!)
        button.setTitleForAllStates("购物车")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColorForAllStates(.black)
        button.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        button.addTarget(self, action: #selector(shopCartClicked), for: UIControl.Event.touchUpInside)
        return button
    }()
    lazy var addInToShopCartButton: UIButton = {
        //加入购物车
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: finalScreenW / 5 * 2, y: 0, width: finalScreenW / 10 * 3, height: bottomBarH)
        button.backgroundColor = .red
        button.setTitleForAllStates("加入购物车")
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(addIntoShopcartClicked), for: UIControl.Event.touchUpInside)
        return button
    }()
    lazy var buyNowButton: UIButton = {
        //立即购买
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: finalScreenW / 10 * 7, y: 0, width: finalScreenW / 10 * 3, height: bottomBarH)
        button.backgroundColor = UIColor(named: "global_orange")
        button.setTitleForAllStates("立即购买")
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buyNowClicked), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var bottomBar: UIView = {
        //底部bar，显示首页、店铺、购物车、加入购物车
        let view = UIView(frame: CGRect(x: 0, y: usableViewHeight!, width: finalScreenW, height: bottomBarH))
        view.backgroundColor = .white
        view.layer.borderColor = UIColor(named: "light_gray")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    //MARK: - 重写构造方法获取当前商品的id
    init(goodsID id : Int) {
        super.init(nibName: nil, bundle: nil)
        self.goodsID = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemBackgroundColor = .clear
        //        settings.style.buttonBarLeftContentInset = 20
        //        settings.style.buttonBarRightContentInset = 20
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = -5
        settings.style.selectedBarHeight = 5
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 20)
        super.viewDidLoad()
        containerView.contentInsetAdjustmentBehavior = .never
        buttonBarView.removeFromSuperview()
        navigationController?.navigationBar.addSubview(buttonBarView)
        usableViewHeight = self.view.frame.height - bottomBarH - (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0)
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //guard let goodInfo = goodsInfo else { }
        //initData()
        goodVC = GoodViewController(itemInfo: "商品")
        goodVC?.sendData = self
        detailVC = DetailViewController(itemInfo: "详情")
        commentVC = CommentViewController(itemInfo: "评价")
        //        CommunicationTools.getCommunications(self, name: Communications.GoodsDetail) { (data) in
        //            let goodsInfo = data?.object as? GoodInfo
        //            goodVC.goodsInfo = goodsInfo
        //            detailVC.goodsInfo = goodsInfo
        //            commentVC.goodsInfo = goodsInfo
        //        }
        
        //commentVC.view.size = CGSize(width: finalScreenW, height: usableViewHeight!)
        
        return [goodVC!,detailVC!,commentVC!]
    }
    
    //    override func configureCell(_ cell: ButtonBarViewCell, indicatorInfo: IndicatorInfo) {
    //        super.configureCell(cell, indicatorInfo: indicatorInfo)
    //        cell.backgroundColor = .clear
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        navigationItem.titleView = nil
        super.viewWillDisappear(animated)
        buttonBarView.isHidden = true
        //self.tabBarController?.tabBar.isHidden = true
        SwiftEventBus.unregister(self, name: Communications.GoodsDetail.rawValue)
        if let sendData = self.sendData {
            sendData.SendData(data: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonBarView.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        guard buttonBarView != nil else {return}
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        //        buttonBarView.move(fromIndex: 0, toIndex: 1, progressPercentage: 1, pagerScroll: PagerScroll.yes)
        //        buttonBarView.move(fromIndex: 0, toIndex: 1, progressPercentage: 1, pagerScroll: PagerScroll.yes)
        //        buttonBarView.move(fromIndex: 0, toIndex: 1, progressPercentage: 1, pagerScroll: PagerScroll.yes)
    }
}

//MARK: - 设置界面
extension GoodDetailViewController{
    
    private func setUI(){
        //0.设置滑动栏buttonBarView
        setButtonBarView()
        //1.初始化数据
        initData()
        //2.设置navigationBar
        setNavigationBar()
        //3.设置主content
        setContentView()
        //4.设置底部bar
        setBottomBar()
    }
    
    private func setBottomBar(){
        //暂时下线店铺按钮，v2.0时添加店铺页后上线
        //bottomBar.addSubview(shopButton)
        bottomBar.addSubview(shopCartButton)
        bottomBar.addSubview(addInToShopCartButton)
        bottomBar.addSubview(buyNowButton)
        self.view.addSubview(bottomBar)
    }
    /// 加入购物车动画方法
    private func addShopCartAnimate(){
        ///绘制贝塞尔曲线路径
        let animationPath = CAKeyframeAnimation.init(keyPath: "position")
        animationPath.path = bezierPath.cgPath
        animationPath.rotationMode = CAAnimationRotationMode.rotateAuto
        //旋转
        let rotate = CABasicAnimation()
        rotate.keyPath = "transform.rotation"
        rotate.toValue = Double.pi
        //缩小图片至0
        let scale = CABasicAnimation()
        scale.keyPath = "transform.scale"
        scale.toValue = 0.0
        //组合动画
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animationPath,scale]
        animationGroup.duration = 0.5
        animationGroup.delegate = self
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.isRemovedOnCompletion = false
        addCartAnimationTarget?.layer.add(animationGroup, forKey: nil)
    }
    private func setButtonBarView(){
        
        //改变选择字体的样式，选中加粗
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
            newCell?.label.textColor = .white
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
        
        buttonBarView.frame = CGRect(x: finalScreenW / 4, y: 0, width: finalScreenW /  2, height: finalNavigationBarH)
        //buttonBarView.collectionViewLayout = UICollectionViewFlowLayout()
        //buttonBarView.centerX = (navigationController?.navigationBar.centerX)!
        buttonBarView.selectedBar.backgroundColor = .white
        buttonBarView.backgroundColor = .clear
        
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: true)
    }
    
    private func setContentView(){
        view.backgroundColor = .white
    }
    
    private func setNavigationBar(){
//        self.navBarTintColor = .white
//        self.navBarTitleColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
    }
    
    private func initData(){
        goodsViewModel.requestGoodsDetail(goodsID: goodsID) {
            self.goodsInfo = self.goodsViewModel.goodsInfo
            //CommunicationTools.post(duration: 0, name: Communications.GoodsDetail, data: self.goodsViewModel.goodsInfo)
            self.goodVC?.goodsInfo = self.goodsViewModel.goodsInfo
            self.detailVC?.goodsInfo = self.goodsViewModel.goodsInfo
            self.commentVC?.goodsInfo = self.goodsViewModel.goodsInfo
        }
        goodsViewModel.requestGoodsProducts(goodsID: goodsID) {
            if self.goodsViewModel.goodsProducts != nil {
                self.goodsProducts = self.goodsViewModel.goodsProducts
                self.goodVC?.goodsProducts = self.goodsViewModel.goodsProducts
            }
            self.goodVC?.productSpecs = self.goodsViewModel.productSpecs
            self.productSpecs = self.goodsViewModel.productSpecs
        }
    }
    
}

//MARK: - 事件响应
extension GoodDetailViewController {
    @objc private func shopClicked(){
        print("店铺")
    }
    
    @objc private func shopCartClicked(){
        //        print("购物车")
        if AppDelegate.appUser?.id == -1{
            YTools.presentToLoginOrNextControl(vc: self, itemTag: 666, completion: nil)
        }else{
            let vc = NextShopCartViewController()
            self.navigationController?.show(vc, sender: self)
        }
        
    }
    
    @objc private func buyNowClicked(){
        //print("立即购买")
        if self.selectedProduct == nil{
            YTools.showMyToast(rootView: self.view, message: "请选择商品规格")
        }else{
            if AppDelegate.appUser?.id == -1{
                YTools.presentToLoginOrNextControl(vc: self, itemTag: 0, completion: nil)
            }else{
                let vc = FillOrderViewController()
                vc.id = "\(self.selectedProduct?.productType == 0 ? (self.selectedProduct?.good_Id)! : (self.selectedProduct?.selectedProduct?.id)!)"
                vc.type = self.selectedProduct?.productType == 0 ? "goods" : "product"
                vc.num = "\((self.selectedProduct?.selectedNum)!)"
                self.navigationController?.show(vc, sender: self)
            }
        }
        
    }
    
    @objc private func addIntoShopcartClicked(){
        if selectedProduct == nil {
            YTools.showMyToast(rootView: self.view, message: "请选择商品规格")
        }else{
            
            if AppDelegate.appUser?.id == -1{
                YTools.presentToLoginOrNextControl(vc: self, itemTag: 0, completion: nil)
            }else{
                if selectedProduct?.productType == 0{
                    //                0无规格  1有规格
                    shopcartViewModel.requestJoinCart(id: (selectedProduct?.good_Id)!, num: (selectedProduct?.selectedNum)!, type: .goods) {
                        self.joinCartModel = self.shopcartViewModel.joinCartModel
                    }
                    
                }else {
                    shopcartViewModel.requestJoinCart(id: (selectedProduct?.selectedProduct?.id)!, num: (selectedProduct?.selectedNum)!, type: .product) {
                        self.joinCartModel = self.shopcartViewModel.joinCartModel
                    }
                }
            }
        }
    }
}

extension GoodDetailViewController:SendDataProtocol{
    func SendData(data: Any?) {
        self.selectedProduct = data as? SelectedProduct
    }
    
    
}

extension GoodDetailViewController:CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //购物车抖动
        let shakeAnimation = CABasicAnimation.init(keyPath: "transform.translation.y")
        shakeAnimation.duration = 0.1
        shakeAnimation.fromValue = NSNumber.init(value: -2)
        shakeAnimation.toValue = NSNumber.init(value: 2)
        shakeAnimation.autoreverses = true
        shakeAnimation.repeatCount = 2
        shopCartButton.layer.add(shakeAnimation, forKey: nil)
    }
}
