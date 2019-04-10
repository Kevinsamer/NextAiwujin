//
//  PicSayViewController.swift
//  NextAiwujin
//  改为直播模块
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwifterSwift
import FSPagerView
//定义私有常量变量
private let titleLabelWidth:CGFloat = 50
private let bannerH:CGFloat = 150
private let bigPicCellID = "bigPicCellID"
private let smallPicCellID = "smallPicCellID"
private let threePicsCellID = "threePicsCellID"
private let bannerCellID = "bannerCellID"
private var banners:[UIImage] = [#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back")]
class PicSayViewController: BaseViewController {
    
    var appConfigModel:AppConfigModel?{
        didSet{
            
        }
    }
    
    //MARK: - 懒加载
    ///天气label
    lazy var weatherLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: titleLabelWidth, height: finalNavigationBarH)))
        label.text = "天气:4℃/-1℃"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        return label
    }()
    
    ///今日推荐数据展示控件
    lazy var newsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: finalScreenW, height: 100)
        layout.estimatedItemSize = CGSize(width: finalScreenW, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        let collection = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: finalScreenW, height: finalContentViewHaveTabbarH), collectionViewLayout: layout)
        collection.alwaysBounceVertical = true
        collection.dataSource = self
        collection.delegate = self
        collection.showsVerticalScrollIndicator = false
        collection.register(UINib.init(nibName: "BigPicCell", bundle: nil), forCellWithReuseIdentifier: bigPicCellID)
        collection.register(UINib.init(nibName: "SmallPicCell", bundle: nil), forCellWithReuseIdentifier: smallPicCellID)
        collection.register(UINib.init(nibName: "ThreePicsCell", bundle: nil), forCellWithReuseIdentifier: threePicsCellID)
        collection.backgroundColor = UIColor.white
        collection.contentInset = UIEdgeInsets(top: bannerH, left: 0, bottom: 0, right: 0)
        return collection
    }()
    
    lazy var topBanner: FSPagerView = {
        let banner = FSPagerView(frame: CGRect(x: 0, y: 0 - bannerH, width: finalScreenW, height: bannerH))
        banner.dataSource = self
        banner.delegate = self
        banner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: bannerCellID)
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        banner.automaticSlidingInterval = 3.0
        //设置页面之间的间隔距离
        banner.interitemSpacing = 10.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        banner.isInfinite = true
        //设置转场的模式
//        banner.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.depth)
        //修改item大小
        banner.itemSize = CGSize(width: finalScreenW / 10 * 9, height: bannerH / 10 * 9)
        
        return banner
    }()
    
    lazy var topBannerControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect(x: -20, y: 115 - bannerH, width: finalScreenW - 5, height: 30))
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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
//MARK: - 设置UI
extension PicSayViewController{
    override func setUI() {
        super.setUI()
        //1.设置导航栏
//        navigationItem.leftBarButtonItems = [UIBarButtonItem.init(imageName: "navigation_app_icon", size: CGSize(width: 40, height: 40), clickAbled: false), UIBarButtonItem.init(customView: weatherLabel)] //此为金坛台方案
        navigationItem.title = "直播武进"
//        navigationController?.navigationBar.tintColor = .yellow
        //2.设置进入推荐数据展示空间UICollectionView
        self.view.addSubview(newsCollectionView)
        //3.设置banner(添加在collectionView上)和pageControl
        newsCollectionView.addSubview(topBanner)
        newsCollectionView.addSubview(topBannerControl)
        
    }
    
    override func initData() {
        super.initData()
        AppConfigViewModel.requestAppConfig { (config) in
            self.appConfigModel = config
        }
    }
    
}
//MARK: - 实现UICollectionView的数据源协议和代理协议
extension PicSayViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bigPicCell = collectionView.dequeueReusableCell(withReuseIdentifier: bigPicCellID, for: indexPath)
        let smallPicCell = collectionView.dequeueReusableCell(withReuseIdentifier: smallPicCellID, for: indexPath)
        let threePicsCell = collectionView.dequeueReusableCell(withReuseIdentifier: threePicsCellID, for: indexPath)
        
        if indexPath.row == 0 {
            return bigPicCell
        }else if indexPath.row == 1{
            return smallPicCell
        }else{
            return threePicsCell
        }
    }
    ///通过UICollectionViewDelegateFlowLayout中的sizeForItemAt修改item大小
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    }
    
    
}
//MARK: - 设置banner的数据源协议和代理协议
extension PicSayViewController:FSPagerViewDataSource,FSPagerViewDelegate{
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
        cell.tag = index + 10000
        cell.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickBannerCell(sender:))))
        return cell
    }
    
    ///取消点击高亮
//    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
//        return false
//    }
    ///cell点击事件
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        print(index)
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
        topBannerControl.currentPage = tempIndex
//        print("willDisplay\(tempIndex)")
    }
    
    
}
//MARK: - 点击事件绑定
extension PicSayViewController{
    ///bannerCell的s单击手势响应方法，为每个cell绑定tag，绑定规则为(index + 10000)，将获取的tag-10000则得到当前点击的cell的index，通过index来操作点击后的事件
    @objc private func clickBannerCell(sender: UITapGestureRecognizer){
        
        print((sender.view?.tag)!)
        
    }
}
