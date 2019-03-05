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
//搜索框属性
private let searchBarW:CGFloat = 100
private let searchBarH:CGFloat = 100
///tableViewCell标识id
private let tableCellID:String = "tableCellID"
///顶部图片和广告栏高度
private let topBannerH:CGFloat = 200
private let bannerCellID = "bannerCellID"
private var banners:[UIImage] = []
//分类标签view属性
private let categoryViewH:CGFloat = 220
private let categoryCellID:String = "categoryCellID"
///header高度
private let headerViewH:CGFloat = 40
///今日推荐view高度
private let recommendViewH:CGFloat = 200
private let recommendCellID:String = "recommendCellID"

class RadioStationViewController: BaseViewController {
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
        
        btn.size = CGSize(width: 50, height: 50)
        btn.setImageForAllStates(#imageLiteral(resourceName: "store_cart"))
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .blue
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
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
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
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
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
//        coll.backgroundColor = .blue
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
        //        pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        //        pageControl.setImage(UIImage.init(named: "2"), for: .selected)
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
//        header.imageView.image = UIImage(named: "down_arrow", in: Bundle.init(for: DefaultRefreshHeader.self), compatibleWith: nil)
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
//        footer.textLabel.sizeToFit()
        footer.setText("加载中...", mode: .refreshing)
        footer.setText("点击加载更多", mode: .tapToRefresh)
        footer.textLabel.textColor  = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).lighten()
        footer.refreshMode = .scroll
        return footer
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setImage(#imageLiteral(resourceName: "fdj_icon"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
        bar.placeholder = "请输入商品名称，优惠内容"
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        //self.navigationController?.navigationBar.updateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //viewDidAppear方法内可以获取searchBar的高度
        //通过kvc获取到搜索框输入控件textField，然后获取到输入控件的提示label，修改搜索控件的圆角属性和提示label的字体
        let searchField = searchBar.value(forKey: "searchField") as! UITextField
        let placeHolderLabel = searchField.value(forKey: "placeholderLabel") as! UILabel
        searchField.layer.cornerRadius = searchField.frame.height / 2
        searchField.layer.masksToBounds = true
        placeHolderLabel.font = UIFont.systemFont(ofSize: 13)
        //将导航栏的透明度设置为0(需在viewDidAppear中设置)
        barImageView?.alpha = 0.0
    }

}

//MARK: - 设置UI
extension RadioStationViewController{
    override func initData() {
        super.initData()
        banners = [#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back")]
    }
    
    override func setUI() {
        super.setUI()
        self.view.backgroundColor = .white
        //0.设置导航栏
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        setNavigationBar()
        //1.设置搜索框
        setSearchBar()
        //2.设置主体tableView
        setTabelView()
        //3.设置s购物车按钮
        setCartButton()
    }
    
    private func setCartButton(){
        self.view.addSubview(cartButton)
        let bottomCon = NSLayoutConstraint(item: cartButton, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: UIDevice.current.isX() ? -finalTabBarH - IphonexHomeIndicatorH - 40 : -finalTabBarH - 40)
        let rightCon = NSLayoutConstraint(item: cartButton, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 40)
        self.view.addConstraints([bottomCon, rightCon])
    }
    
    private func setNavigationBar(){
//        self.navigationController?.delegate = self
        //navigationBar的第一个子控件就是背景View
        barImageView = self.navigationController?.navigationBar.subviews.first
        //设置导航栏透明才能让SB设置的tableView的frame.x变为0，否者会自动设置内边距使得显示内容移位到导航栏下面
        self.navigationController?.navigationBar.isTranslucent = true

    }
    
    private func setTabelView(){
//        self.mainTableView.frame.size = CGSize(width: finalScreenW, height: UIDevice.current.isX() ? finalScreenH - IphonexHomeIndicatorH : finalScreenH)
        //不需要自动设置内边距
        self.mainTableView.cellLayoutMarginsFollowReadableWidth = false
        self.mainTableView.contentInsetAdjustmentBehavior = .never
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellID)
        //为SB设置的tableView设置底部内边距，使其不被底部tabbar遮盖
        self.mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIDevice.current.isX() ? (finalTabBarH + IphonexHomeIndicatorH) : finalTabBarH , right: 0)
        //设置下拉刷新和上拉加载
        self.mainTableView.configRefreshHeader(with: header, container: self) {
            self.mainTableView.switchRefreshHeader(to: HeaderRefresherState.normal(.success, 0.3))
        }
        
        self.mainTableView.configRefreshFooter(with: footer, container: self) {
            self.mainTableView.switchRefreshFooter(to: FooterRefresherState.noMoreData)
        }
//        let topCon = NSLayoutConstraint(item: mainTableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: (0))
//        let leftCon = NSLayoutConstraint(item: mainTableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
//        let rightCon = NSLayoutConstraint(item: mainTableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
//        let bottomCon = NSLayoutConstraint(item: mainTableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: finalTabBarH + IphonexHomeIndicatorH)
//        self.view.addConstraints([topCon, leftCon, rightCon, bottomCon])
    }
    
    private func setSearchBar(){
        //设置搜索框的约束
        navigationController?.navigationBar.addSubview(searchBar)
        let leftCon = NSLayoutConstraint(item: searchBar, attribute: .left, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .left, multiplier: 1.0, constant: 20)
        let rightCon = NSLayoutConstraint(item: searchBar, attribute: .right, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .right, multiplier: 1.0, constant: -65)
        let topCon = NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .top, multiplier: 1.0, constant: 5)
        let bottomCon = NSLayoutConstraint(item: searchBar, attribute: .bottom, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .bottom, multiplier: 1.0, constant: -10)
        self.navigationController?.navigationBar.addConstraints([leftCon, rightCon, topCon, bottomCon])
        searchBar.alpha = 0.8
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
            return 50
        default:
            return 0
        }
    }
    ///cell内容代理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath)
        
        for childView in (cell?.subviews)!{
            childView.removeFromSuperview()
        }
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: tableCellID)
//        }else{
//            if cell?.subviews.last != nil {
//                cell?.subviews.last?.removeFromSuperview()
//            }
//        }
        cell!.backgroundColor = UIColor.random.lighten(by: 0.3)
        //总共分为3个section   第一个包含banner和分类，第二个是横向滑动的商品展示和header
        switch indexPath.section {
        case 0:
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
            switch indexPath.row {
            case 0:
                cell?.addSubview(recommendCollectionView)
            default:
                break
            }
        case 2:
            break
        default:
            break
        }
        
        
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
            return 50
        }
        
    }
    
    ///滑动事件代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ///通过监听滑动时scrollView页面外边距值来判断页面的滑动方向
        if scrollView.isMember(of: UITableView.self){
            let offsetY = scrollView.contentOffset.y
            
            //TODO:调整cartButton的y值，使其有固定于页面的效果
            cartButton.frame.origin.y = offsetY
            if offsetY < 0{
                //当外边距小于0时，页面处于下拉状态，通过视图动画展示导航栏透明效果,同时将状态栏字体设为黑色，增强可阅读性
                UIView.animate(withDuration: 0.2) {
                    self.navigationController?.navigationBar.alpha = 0
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
                }
            }else{
                //当外边距大于0时，页面处于上拉状态，通过视图动画展示导航栏由透明复原的效果，动画执行结束后将状态栏恢复白色
                UIView.animate(withDuration: 0.2, animations: {
                    self.navigationController?.navigationBar.alpha = 1
                }) { (result) in
                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
                }
            }
            ///定义页面外边距与页面滑动到顶部图片结束的比例
            var delta =  offsetY / (topBannerH - finalStatusBarH - finalNavigationBarH)
            ///通过取大值函数保证比例大于0，即只有上拉事件才会改变导航栏透明度
            delta = CGFloat.maximum(delta, 0)
            ///通过滑动比例改变导航栏背景的透明的，通过取小值函数保证比例不会大于1，即页面上拉超过顶部图片底部则停止改变导航栏透明度
            self.barImageView?.alpha = CGFloat.minimum(delta, 1)
            
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
        cell.imageView?.image = banners[index]
        cell.textLabel?.text = "Title\(index)"
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
}

//MARK: - 实现分类collectionView代理协议和数据源协议,301是分类模块，302是今日推荐
extension RadioStationViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 301{
            return 8
        }else {
            return 15
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 301{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellID", for: indexPath) as! CategoryCell
            cell.categoryName.text = "name\(indexPath.row)"
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCellID", for: indexPath) as! RecommendCell
            cell.goodsNameLabel.text = "name\(indexPath.row)namenamenamenamenamenamenamename"
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
    
    
}
