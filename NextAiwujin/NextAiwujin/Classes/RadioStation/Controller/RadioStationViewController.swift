//
//  RadioStationViewController.swift
//  NextAiwujin
//  更改为商城模块
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import PullToRefreshKit
import FSPagerView
import Kingfisher

//搜索框属性
private let searchBarW:CGFloat = 100
private let searchBarH:CGFloat = 100
///tableViewCell标识id
private let tableCellID:String = "tableCellID"
///顶部图片和广告栏高度
let topBannerH:CGFloat = 200
private let bannerCellID = "bannerCellID"
//private var banners:[UIImage] = []
//分类标签view属性
private let categoryViewH:CGFloat = 220
private let categoryCellID:String = "categoryCellID"
///header高度
private let headerViewH:CGFloat = 40
///今日推荐view高度
private let recommendViewH:CGFloat = 200
private let recommendCellID:String = "recommendCellID"
///热门推荐行高
private let hotCellH:CGFloat = finalScreenH / 6
private let hotCellID:String = "hotCellID"
//购物车按钮属性
///购物车按钮的宽高
private let cartBtnWH:CGFloat = 50
///购物车按钮相对屏幕右边和tabbar的距离
private let cartBtnOriginXY:CGFloat = 20

private var banners:[BannerInfo] = [BannerInfo]()//banner数组
private var recommends:[RecommendInfo] = [RecommendInfo]()//推荐商品数组
private var hots:[HotInfo] = [HotInfo]()//热门商品数组
private var channels:[ChannelInfo] = [ChannelInfo]()//分类数组
private let channelsIcons:[UIImage] = [#imageLiteral(resourceName: "Porridge"),#imageLiteral(resourceName: "Cocktail"),#imageLiteral(resourceName: "Nut"),#imageLiteral(resourceName: "Lettuce"),#imageLiteral(resourceName: "三色堇"),#imageLiteral(resourceName: "Crab"),#imageLiteral(resourceName: "Sugar"),#imageLiteral(resourceName: "Thanksgiving"),#imageLiteral(resourceName: "Peas"),#imageLiteral(resourceName: "Cupcake")]


class RadioStationViewController: BaseTrunclentViewController {
    private var shopViewModel:ShopViewModel = ShopViewModel()
//    private var isBackFresh:Bool = false
    
    ///导航栏的背景图片
    var barImageView:UIView?
    ///主体tableView
    @IBOutlet var mainTableView: UITableView!
    ///右上角消息按钮
    @IBOutlet var messageBtn: UIBarButtonItem!
    ///消息按钮点击事件监听
    @IBAction func messageBtnClicked(_ sender: UIBarButtonItem) {
        print("click message button")
    }
    //MARK: - 懒加载
    
    lazy var cartButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x:finalScreenW - cartBtnOriginXY - cartBtnWH , y: UIDevice.current.isX() ? finalScreenH - finalTabBarH - IphonexHomeIndicatorH - cartBtnWH - cartBtnOriginXY : finalScreenH - finalTabBarH - cartBtnWH - cartBtnOriginXY, width: cartBtnWH, height: cartBtnWH)
//        btn.frame = CGRect(x: 100, y: 300, width: 50, height: 50)
//        btn.frame = CGRect(origin: CGPoint(x: UIDevice.current.isX() ? finalScreenH - finalTabBarH - IphonexHomeIndicatorH - 50 - 40 : finalScreenH - finalTabBarH - 50 - 40, y: finalScreenW - 40 - 50), size: CGSize(width: 50, height: 50))
//        btn.size = CGSize(width: 50, height: 50)
        btn.setImageForAllStates(#imageLiteral(resourceName: "store_cart"))
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .white
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowRadius = 5.0
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
//        btn.addShadow()
        btn.addTarget(self, action: #selector(showCart), for: .touchUpInside)
        return btn
    }()
    
    ///推荐商品header
    lazy var recommendHeader: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: headerViewH))
        let imageBG = UIView(frame: CGRect(x: 0, y: 5, width: finalScreenW, height: 30))
        let image = UIImageView(frame: CGRect(x: 20, y: 0, width: 100, height: 30))
        image.contentMode = .left
        image.image = #imageLiteral(resourceName: "today_recommend")
        imageBG.backgroundColor = .white
        imageBG.addSubview(image)
        view.addSubview(imageBG)
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        return view
    }()
    ///最热商品header
    lazy var hotHeader: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: headerViewH))
        let image = UIImageView(frame: CGRect(x: 20, y: 10, width: 100, height: 25))
        image.image = #imageLiteral(resourceName: "hot_recommend")
        image.contentMode = UIView.ContentMode.scaleAspectFit
//        image.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        view.addSubview(image)
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        return view
    }()
    
    ///分类板块的分页指示器，待添加
    lazy var pageControl: UIPageControl = {
        let page = UIPageControl(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
        page.pageIndicatorTintColor = .white
        page.currentPageIndicatorTintColor = .red
        page.numberOfPages = 3
        return page
    }()
    ///今日推荐模块
    lazy var recommendCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: finalScreenW / 3, height: recommendViewH)
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: recommendViewH), collectionViewLayout: layout)
        coll.tag = 302
        coll.register(UINib.init(nibName: "RecommendCell", bundle: nil), forCellWithReuseIdentifier: recommendCellID)
        coll.delegate = self
        coll.dataSource = self
        coll.isPagingEnabled = false
        coll.alwaysBounceHorizontal = true
        coll.backgroundColor = .white
        coll.contentInsetAdjustmentBehavior = .never
        coll.alwaysBounceVertical = false
        coll.showsHorizontalScrollIndicator = false
        return coll
    }()
    
    ///分类模块
    lazy var categoryCollectionView: UICollectionView = {
        let layout = HorizontallyPageableFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.sectionHeadersPinToVisibleBounds = false
//        layout.sectionFootersPinToVisibleBounds = false
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: finalScreenW / 5, height: finalScreenW / 5)
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: categoryViewH), collectionViewLayout: layout)
        coll.tag = 301
        coll.register(UINib.init(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: categoryCellID)
        coll.delegate = self
        coll.dataSource = self
        coll.isPagingEnabled = true
        coll.alwaysBounceHorizontal = true
        coll.backgroundColor = .white
        coll.contentInsetAdjustmentBehavior = .never
        coll.alwaysBounceVertical = false
        return coll
    }()
    
    ///顶部广告栏
    lazy var topBanner: FSPagerView = {
        let banner = FSPagerView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: topBannerH))
        banner.dataSource = self
        banner.delegate = self
        banner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: bannerCellID)
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        banner.automaticSlidingInterval = 3.0
        //设置页面之间的间隔距离
        banner.interitemSpacing = 0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        banner.isInfinite = true
        //设置转场的模式
        //        banner.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.depth)
        //修改item大小
//        banner.itemSize = CGSize(width: finalScreenW / 10 * 9, height: topBannerH / 10 * 9)
        
        return banner
    }()
    
    lazy var topBannerControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect(x: 0, y: topBannerH - 27, width: finalScreenW - 5, height: 30))
        //设置下标的个数
        pageControl.numberOfPages = banners.count
        //设置下标位置
        pageControl.contentHorizontalAlignment = .right
        //设置下标指示器图片（选中状态和普通状态）
        //pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        //pageControl.setImage(UIImage.init(named: "2"), for: .selected)
        //绘制下标指示器的形状
        //pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 5, height: 5), cornerRadius: 4.0), for: .normal)
        //pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 5, height: 5)), for: .normal)
        //pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 5)), for: .selected)
        //pageControl.setPath(UIBezierPath?.init(UIBezierPath.init(arcCenter: CGPoint.init(x: 10, y: 10), radius: 3, startAngle: 3, endAngle: 2, clockwise: true)), for: UIControlState.selected)
        //设置下标指示器边框颜色（选中状态和普通状态）
        pageControl.setStrokeColor(.white, for: .normal)
        pageControl.setStrokeColor(UIColor.init(hexString: "E22F38"), for: .selected)
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(UIColor.init(hexString: "E22F38"), for: .selected)
        //TODO:实现点击某个下标跳转到相应page的功能
        return pageControl
    }()
    
    
    ///顶部图片(改为展示banner)
    lazy var topImageView: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: topBannerH))
        imageV.image = #imageLiteral(resourceName: "individual_header_back")
        return imageV
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

    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        barImageView = self.navigationController?.navigationBar.subviews.first
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .topAttached, barMetrics: .default)
        //        定义页面外边距与页面滑动到顶部图片结束的比例
//        var delta =  (self.mainTableView.contentOffset.y) / (topBannerH - finalStatusBarH - finalNavigationBarH)
//        ///通过取大值函数保证比例大于0，即只有上拉事件才会改变导航栏透明度
//        //        delta = CGFloat.maximum(delta, 0)
//        if delta < 0 { delta = 0 }
//        if delta > 1 { delta = 1 }
//        ///通过滑动比例改变导航栏背景的透明的，通过取小值函数保证比例不会大于1，即页面上拉超过顶部图片底部则停止改变导航栏透明度
//        self.barImageView = self.navigationController?.navigationBar.subviews.first?.subviews.first
//        //        self.navigationController?.navigationBar.alpha = delta
//        self.barImageView?.alpha = delta
        super.viewWillAppear(animated)
        searchBar.isHidden = false
//        if self.mainTableView.contentOffset.y < (topBannerH - finalStatusBarH - finalNavigationBarH) && isBackFresh {
//            self.mainTableView.switchRefreshHeader(to: .refreshing)
//            self.isBackFresh = false
//        }
        //使用通知中心或者协议向本页面发送刷新标志位，只在二级页面返回的时候刷新，其他时候不刷新
        
//        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    

}

//MARK: - 设置UI
extension RadioStationViewController{
    //MARK: - 初始化数据
    override func initData() {
        super.initData()
//        header.didBeginRefreshingState()
        initHomeData()
        
//        banners = [#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back")]
    }
    
    private func initHomeData(){
        banners.removeAll()
        recommends.removeAll()
        channels.removeAll()
        hots.removeAll()
        shopViewModel.requestHomeData {
            
            for banner in (self.shopViewModel.homeDataGroup?.banners)! {
                banners.append(banner)
            }
            for recommend in (self.shopViewModel.homeDataGroup?.recommends)! {
                recommends.append(recommend)
            }
            for hot in (self.shopViewModel.homeDataGroup?.hots)! {
                hots.append(hot)
            }
            for channel in (self.shopViewModel.homeDataGroup?.channels)!{
//                print(channel.name)
                channels.append(channel)
            }
            
            DispatchQueue.main.async(execute: {
//                self.collections.reloadData()
                self.topBannerControl.numberOfPages = banners.count
                self.topBanner.reloadData()
                self.categoryCollectionView.reloadData()
                self.recommendCollectionView.reloadData()
                self.mainTableView.reloadData()
//                self.tipInfoView.frame = CGRect(x: 20, y: 20 + self.collections.collectionViewLayout.collectionViewContentSize.height, width: finalScreenW - 40, height: tipInfoViewH)
                self.mainTableView.switchRefreshHeader(to: HeaderRefresherState.normal(.success, 0.3))
            })
        }
    }
    
    override func setUI() {
        //0.设置导航栏
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        setNavigationBar()
        //1.设置搜索框（bug出在这里）
        setSearchBar()
        //2.设置主体tableView
        setTabelView()
        //3.设置s购物车按钮
        setCartButton()
        super.setUI()
        self.view.backgroundColor = .white
        
    }
    
    private func setCartButton(){
        self.view.addSubview(cartButton)
        self.view.bringSubviewToFront(cartButton)
//        let bottomCon = NSLayoutConstraint(item: cartButton, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: UIDevice.current.isX() ? -finalTabBarH - IphonexHomeIndicatorH - 40 : -finalTabBarH - 40)
//        let rightCon = NSLayoutConstraint(item: cartButton, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 40)
//        self.view.addConstraints([bottomCon, rightCon])
    }
    
    private func setNavigationBar(){
//        self.navigationController?.delegate = self
        //navigationBar的第一个子控件就是背景View
//        barImageView = self.navigationController?.navigationBar.subviews.first
        //设置导航栏透明才能让SB设置的tableView的frame.x变为0，否者会自动设置内边距使得显示内容移位到导航栏下面
        self.navBar.alpha = 0
        self.navigationController?.navigationBar.isTranslucent = true
//        self.navBarTintColor = .white
//        self.navBarTitleColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)

    }
    
    private func setTabelView(){
//        self.mainTableView.frame.size = CGSize(width: finalScreenW, height: UIDevice.current.isX() ? finalScreenH - IphonexHomeIndicatorH : finalScreenH)
        //不需要自动设置内边距
        self.mainTableView.cellLayoutMarginsFollowReadableWidth = false
        self.mainTableView.contentInsetAdjustmentBehavior = .never
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellID)
        self.mainTableView.register(UINib(nibName: "HotCell", bundle: nil), forCellReuseIdentifier: "hotCellID")
        self.mainTableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        //为SB设置的tableView设置底部内边距，使其不被底部tabbar遮盖
        self.mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIDevice.current.isX() ? (finalTabBarH + IphonexHomeIndicatorH) : finalTabBarH , right: 0)
        //设置下拉刷新和上拉加载
        self.mainTableView.configRefreshHeader(with: header, container: self) {
            self.initData()
        }
        
        self.mainTableView.configRefreshFooter(with: footer, container: self) {
            self.mainTableView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
        }
        //进入页面初始化TableView时自动刷新一次
        self.mainTableView.switchRefreshHeader(to: .refreshing)
//        self.mainTableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
//        let topCon = NSLayoutConstraint(item: mainTableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: (0))
//        let leftCon = NSLayoutConstraint(item: mainTableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
//        let rightCon = NSLayoutConstraint(item: mainTableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
//        let bottomCon = NSLayoutConstraint(item: mainTableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: finalTabBarH + IphonexHomeIndicatorH)
//        self.view.addConstraints([topCon, leftCon, rightCon, bottomCon])
    }
    
    private func setSearchBar(){
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
    
    
}

//extension RadioStationViewController:UINavigationControllerDelegate{
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        //判断是商城页的时候隐藏导航栏
//
//        if viewController == self{
////            print("yes")
//
//        }else{
//
////            self.navigationController?.navigationBar.isTranslucent = false
//            self.navigationController?.navigationBar.alpha = 1.0
//        }
//    }
//}

//MARK: - 实现UITableView的代理协议和数据源协议
extension RadioStationViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            let vc = GoodDetailViewController(goodsID: hots[indexPath.row].id)
            vc.sendData = self
            self.navigationController?.show(vc, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //tableView的sectionHeader遮住了添加在tableView上的子控件，通过改变sectionHeader的zPosition值来调整其在页面中的层级顺序
        view.layer.zPosition = cartButton.layer.zPosition - 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            return recommendHeader
        case 2:
            return hotHeader
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //当tableView的style设置为group时，header和footer不会悬停，但是没有header和footer的section之间会有较大空隙，此时将有空隙的section的headerHeight和footerHeight设置为0.01即可（设置为0无效果 ）
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        case 1:
            return headerViewH
        case 2:
            return headerViewH
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    ///tableView行数代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return hots.count
        default:
            return 0
        }
    }
    ///cell内容代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
//        for childView in (cell?.subviews)!{
//            childView.removeFromSuperview()
//        }
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: tableCellID)
//        }else{
//            if cell?.subviews.last != nil {
//                cell?.subviews.last?.removeFromSuperview()
//            }
//        }
        
        //总共分为3个section   第一个包含banner和分类，第二个是横向滑动的商品展示和header
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath)
            switch indexPath.row {
            case 0:
                cell?.addSubview(topBanner)
                cell?.addSubview(topBannerControl)
            case 1:
                cell?.addSubview(categoryCollectionView)
            //            cell?.addSubview(pageControl)
            default: break
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath)
            switch indexPath.row {
            case 0:
                cell?.addSubview(recommendCollectionView)
            default:
                break
            }
        case 2:
//            tableView.separatorStyle = .singleLine
            cell = tableView.dequeueReusableCell(withIdentifier: "hotCellID", for: indexPath) as! HotCell
//            print(hots.count)
//            print(indexPath.row)
//            cell?.separatorInset = UIEdgeInsets(top: 0, left: 110, bottom: 0, right: 0)
            cell!.selectionStyle = .none
            if hots.count > 0{
                (cell as! HotCell).goodsImageView.kf.setImage(with: URL(string: BASE_URL + hots[indexPath.row].img), placeholder: #imageLiteral(resourceName: "loading"))
                (cell as! HotCell).goodsNameLabel.text = hots[indexPath.row].name
                (cell as! HotCell).marketPriceLabel.attributedText = YTools.textAddMiddleLine(text: "￥\(hots[indexPath.row].market_price)")
                (cell as! HotCell).sellPriceLabel.text = "￥\(hots[indexPath.row].sell_price)"
            }
            
            if indexPath.row == (tableView.numberOfRows(inSection: 2) - 1) {
//                cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (cell?.bounds.size.width)!)
//                tableView.separatorColor = .white
//                cell?.backgroundColor = .red
                (cell as! HotCell).bottomLine.isHidden = true
            }else{
//                tableView.separatorColor = .gray
                (cell as! HotCell).bottomLine.isHidden = false
            }
            break
        default:
            break
        }
        
//        cell?.backgroundColor = UIColor.random.lighten(by: 0.3)
        return cell!
    }
    ///行高代理
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return topBannerH
            case 1:
                return categoryViewH
            default:
                return 0
            }
        case 1:
            return recommendViewH
        default:
            return hotCellH
        }
        
    }
    
    //开始滑动,隐藏购物车按钮
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.isMember(of: UITableView.self){
            UIView.animate(withDuration: 0.5) {
                self.cartButton.frame.origin.x += (cartBtnWH + cartBtnOriginXY + 20)
            }
            
        }
    }
    
    //结束滑动，显示购物车按钮
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.isMember(of: UITableView.self){
            UIView.animate(withDuration: 0.5, delay: 1, animations: {
                self.cartButton.frame.origin.x -= (cartBtnWH + cartBtnOriginXY + 20)
            }, completion: nil)
        }
    }
    
    
    
    ///滑动事件代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ///通过监听滑动时scrollView页面外边距值来判断页面的滑动方向
        if scrollView.isMember(of: UITableView.self){
            let offsetY = scrollView.contentOffset.y
            
            self.navBar.frame.origin.y = offsetY
            cartButton.frame.origin.y = offsetY + (UIDevice.current.isX() ? finalScreenH - finalTabBarH - IphonexHomeIndicatorH - cartBtnWH - cartBtnOriginXY : finalScreenH - finalTabBarH - cartBtnWH - cartBtnOriginXY)
            if offsetY < 0{
                //当外边距小于0时，页面处于下拉状态，通过视图动画展示导航栏透明效果,同时将状态栏字体设为黑色，增强可阅读性
                UIView.animate(withDuration: 0.2) {
                    self.navBar.alpha = 0
//                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
                }
            }else{
                //当外边距大于0时，页面处于上拉状态，通过视图动画展示导航栏由透明复原的效果，动画执行结束后将状态栏恢复白色
                UIView.animate(withDuration: 0.2, animations: {
                    self.navBar.alpha = 1
                }) { (result) in
//                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                }
            }
            ///定义页面外边距与页面滑动到顶部图片结束的比例
            var delta =  offsetY / (topBannerH - finalStatusBarH - finalNavigationBarH)
//            ///通过取大值函数保证比例大于0，即只有上拉事件才会改变导航栏透明度
            delta = CGFloat.maximum(delta, 0)
//            ///通过滑动比例改变导航栏背景的透明的，通过取小值函数保证比例不会大于1，即页面上拉超过顶部图片底部则停止改变导航栏透明度
            self.navBar.setBackgroundAlpha(alpha: CGFloat.minimum(delta, 1))
            self.searchBar.alpha = CGFloat.maximum(delta, 0.8)
//            self.barImageView?.alpha = CGFloat.minimum(delta, 1)
//            navBarBgAlpha = delta
//            navBarTintColor = .white
//            if scrollView.contentOffset.y > 200 {
//                navBarBgAlpha = 1
//                navBarTintColor = UIColor.white
//            } else {
//                navBarBgAlpha = 0
//                navBarTintColor = .white
//            }
            
        }
    }
        
    
}

//MARK: - 实现banner的数据源协议和代理协议
extension RadioStationViewController:FSPagerViewDelegate, FSPagerViewDataSource{
    ///item数量
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banners.count
    }
    
    ///数据填充回调
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: bannerCellID, at: index)
        //        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.kf.setImage(with: URL(string: BASE_URL + banners[index].img))
        cell.textLabel?.text = banners[index].name
        cell.isHighlighted = false
        cell.tag = index + 20000
        cell.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickBannerCell(sender:))))
        return cell
    }
    
    ///取消点击高亮
    //    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
    //        return false
    //    }
    ///cell点击事件
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        print(index)
        //        topBanner.cellForItem(at: index)?.isHighlighted = false
        //        topBanner.cellForItem(at: index)?.selectedBackgroundView?.backgroundColor = .clear
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        
    }
    
    //下标同步
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        var tempIndex = index - 1
        if tempIndex == -1{
            tempIndex = banners.count - 1
        }
        topBannerControl.currentPage = index
        //        print("willDisplay\(tempIndex)")
    }
}

//MARK: - 点击事件监听
extension RadioStationViewController{
    @objc private func clickBannerCell(sender: UITapGestureRecognizer){
        
        print((sender.view?.tag)!)
        
    }
    
    @objc private func showCart(){
        if AppDelegate.appUser?.id == -1{
            YTools.presentToLoginOrNextControl(vc: self, itemTag: 666, completion: nil)
        }else{
            let vc = NextShopCartViewController()
            self.navigationController?.show(vc, sender: self)
        }
    }
    
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

//MARK: - 实现分类collectionView代理协议和数据源协议,301是分类模块，302是今日推荐
extension RadioStationViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 301{
            return channels.count
        }else {
            return recommends.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 301{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellID", for: indexPath) as! CategoryCell
            cell.categoryName.text = "\(channels[indexPath.row].name)"
            cell.categoryPic.image = channelsIcons[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCellID", for: indexPath) as! RecommendCell
            cell.goodsNameLabel.text = recommends[indexPath.row].name
            cell.goodsImageView.kf.setImage(with: URL(string: BASE_URL + recommends[indexPath.row].img), placeholder: UIImage(named: "loading"))
            cell.marketPriceLabel.attributedText = YTools.textAddMiddleLine(text: "￥" + recommends[indexPath.row].market_price)
            cell.sellPriceLabel.text = "￥" + recommends[indexPath.row].sell_price
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 301{
            let page = indexPath.row / 10
            pageControl.currentPage = page
        }
        
//        print(indexPath.row)
//        print(page)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 301{
            let vc = SearchResultController()
            vc.category = channels[indexPath.row]
//            vc.hidesBottomBarWhenPushed = true
            //        self.present(vc, animated: false, completion: nil)
            vc.shopHomeVC = self
            self.navigationController?.pushViewController(vc, animated: true)
//            self.navigationController?.show(vc, sender: self)
            
        }else{
            let vc = GoodDetailViewController(goodsID: recommends[indexPath.row].id)
            vc.sendData = self
            self.navigationController?.show(vc, sender: self)
            
        }
    }
    
    
}
//MARK: - 实现搜索框的代理协议
extension RadioStationViewController:UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return false
    }
}

//MARK: - 实现数据传递协议
extension RadioStationViewController:SendDataProtocol{
    func SendData(data: Any?) {
//        self.isBackFresh = data as! Bool
    }
    
    
}
