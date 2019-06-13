//
//  ZhiBoPlayerViewController.swift
//  NextAiwujin
//  直播视频播放vc
//  Created by DEV2018 on 2019/5/13.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import Kingfisher
enum isLive:String {
    case yes = "1"
    case no = "0"
}
private let zhiboHistoryCellID:String = "zhiboHistoryCellID"
private let zhiboIngCellID:String = "zhiboIngCellID"
private let cellHeight:CGFloat = 120
class ZhiBoPlayerViewController: BasePlayerViewController {
    ///正在直播的数据model
    var zhiboingModel:CH2TVModel = CH2TVModel(jsonData: "")
    ///正在播放的往期直播model
    var zhiboModel:ZhiBoHistoryModel = ZhiBoHistoryModel(jsonData: "")
    ///所有往期直播数据
    var zhiboHistories:[ZhiBoHistoryModel] = [] {
        didSet{

        }
    }
    ///当前播放的直播视频索引(如果正在播放直播流则置为-1)
    var currentIndex:Int = -1
    ///是否有正在直播的活动标志位,"0"表示没有正在直播的活动，"1"表示有
    var currentHaveLive:String = isLive.no.rawValue{
        didSet{
            self.pushTableView.reloadData{[unowned self] in
                if self.currentIndex == -1 {
                    self.pushTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                }else{
                    self.pushTableView.selectRow(at: IndexPath(row: self.currentIndex, section: 1), animated: true, scrollPosition: .top)
//                    for index in 0..<self.zhiboHistories.count {
//                        if self.zhiboHistories[index].title == self.zhiboModel.title {
//                            print(index)
//                            self.pushTableView.selectRow(at: IndexPath(row: index, section: 1), animated: true, scrollPosition: .top)
////                            self.pushTableView.scrollToRow(at: IndexPath(row: index, section: 1), at: .top, animated: true)
//                        }
//                    }
                }
            }
        }
    }
    
    //MARK: - 懒加载
    ///当前视频标题view
    lazy var titleView: UIControl = {
        let view = UIControl()
//        view.size = CGSize(width: finalScreenW, height: 50)
        view.addTarget(self, action: #selector(toggleTable), for: UIControl.Event.touchUpInside)
        view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        return view
    }()
    ///当前视频标题label
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        //        label.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        label.textColor = .white
        return label
    }()
    ///旋转箭头
    lazy var downArrowImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "downArrow"))
        return image
    }()
    ///标题view的分隔线
    lazy var titleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    ///titleView的分享按钮
    lazy var titleShareButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: finalScreenW - 40, y: 15, width: 20, height: 20)
        btn.setImageForAllStates(#imageLiteral(resourceName: "share_hui"))
//        btn.setTitleForAllStates("分享")
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        btn.setTitleColorForAllStates(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
//        btn.setButtonTitleImageStyle(padding: 0, style: TitleImageStyly.ButtonImageTitleStyleTop)
        btn.addTarget(self, action: #selector(shareEvent), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    ///弹出的历史tableView
    lazy var pushTableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 0), style: UITableView.Style.plain)
        table.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        table.contentInsetAdjustmentBehavior = .never
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        //        table.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        table.register(UINib(nibName: "DianshiCell", bundle: nil), forCellReuseIdentifier: zhiboHistoryCellID)
        table.register(UINib(nibName: "ZhiBoIngCell", bundle: nil), forCellReuseIdentifier: zhiboIngCellID)
        return table
    }()
    
    ///评论fatherView
//    lazy var commentFatherView: UIView = {
//        let view = UIView()
////        view.backgroundColor = .random
//        return view
//    }()
    
    ///正在直播的播放器
    lazy var zhiBoIngPlayerView: NicooPlayerView = {
        let player = NicooPlayerView(frame: fatherView.bounds, bothSidesTimelable: false)
        player.videoLayerGravity = .resizeAspect
        player.videoNameShowOnlyFullScreen = true
        player.delegate = self
        player.isLive = true
        player.customViewDelegate = self
        player.isVideo = true
        //        playerView.videoLayerGravity = .resize
        //保持返回按钮一直显示
        player.playControllViewEmbed.closeButton.isHidden = false
        player.playControllViewEmbed.closeButton.isEnabled = true
        player.playControllViewEmbed.closeButton.snp.updateConstraints { (make) in
            make.width.equalTo(40)
        }
        player.playControllViewEmbed.closeButton.setImage(NicooImgManager.foundImage(imageName: "back"), for: UIControl.State.normal)
        return player
    }()
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

//MARK: - 设置ui
extension ZhiBoPlayerViewController {
    override func setUI() {
        super.setUI()
        //1.添加标题view
        setTitleView()
        //2.添加评论view
//        setCommentView()
        //3.向评论view添加下拉表视图
        setToggleTable()
        
    }
    //重写播放func，是直播的话调用直播播放器，不是直播调用
    override func playVideo() {
        //播放前先判断是否是流媒体，同时暂停另一个播放器的播放，将要调用的播放器的播放状态设置为playing
        if self.videoIsLive {
            playerView.playerStatu = PlayerStatus.Pause
            playerView.destroyPlayer()
            zhiBoIngPlayerView.playerStatu = PlayerStatus.Playing
            zhiBoIngPlayerView.playVideo(URL(string: self.videoURLString), self.videoName, self.fatherView)
        }else{
            zhiBoIngPlayerView.playerStatu = PlayerStatus.Pause
            zhiBoIngPlayerView.destroyPlayer()
            playerView.playerStatu = PlayerStatus.Playing
            super.playVideo()
        }
    }
    
    ///设置下拉表视图
    private func setToggleTable(){
        self.commentFatherView.addSubview(pushTableView)
    }
    
    ///设置评论view
    private func setCommentView(){
        self.view.addSubview(commentFatherView)
        commentFatherView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.equalToSuperview().offset(UIDevice.current.isX() ? -IphonexHomeIndicatorH : 0)
        }
        let vc = RedditCommentsViewController()
        self.addChild(vc)
        self.commentFatherView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func setTitleView(){
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(fatherView.snp.bottom)
            make.height.equalTo(50)
        }
        titleView.addSubview(titleShareButton)
        titleView.addSubview(downArrowImage)
        downArrowImage.snp.makeConstraints { (make) in
            make.right.equalTo(titleShareButton.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(downArrowImage.snp.left).offset(-10)
            make.height.equalToSuperview()
        }
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = "\(videoName)"
        //        titleView.addSubview(titleLineView)
        //        titleLineView.snp.makeConstraints { (make) in
        //            make.left.right.bottom.equalToSuperview()
        //            make.height.equalTo(1)
        //        }
        
    }
    
    override func initData() {
        super.initData()
        AppConfigViewModel.requestAppConfig { (appConfigModel) in
            for tvInfo in appConfigModel.CH2.TV {
                if tvInfo.is_live == "1"{
                    //进入页面初始化数据时遍历所有电视直播信息，如果存在is_live==1的则表示存在直播活动,跳出循环
                    self.currentHaveLive = tvInfo.is_live
                    self.zhiboingModel = tvInfo
                    break
                }else {
                    self.currentHaveLive = tvInfo.is_live
                }
            }
            //如果遍历所有直播节目信息发现没有直播活动，则将直播活动标志位置0
        }
    }
}

//MARK: - tableView的代理协议
extension ZhiBoPlayerViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
         }
        return zhiboHistories.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: zhiboHistoryCellID, for: indexPath) as! DianshiCell
            cell.cellHeight = cellHeight
            cell.isPlayer = true
            
            if zhiboHistories.count > 0{
                cell.imageV.kf.setImage(with: URL.init(string: "\(zhiboHistories[indexPath.row].titlepic)"), placeholder: UIImage.init(named: "loading"))
                cell.nameLabel.text = "\(zhiboHistories[indexPath.row].title)\n"
                cell.updateTimeLabel.text = "发布时间:\(zhiboHistories[indexPath.row].time)"
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: zhiboIngCellID, for: indexPath) as! ZhiBoIngCell
            if self.currentHaveLive == isLive.yes.rawValue {
                cell.imageV.kf.setImage(with: URL.init(string: "\(zhiboingModel.channel_picture)"),options: [.forceRefresh])
                cell.nameLabel.text = "\(zhiboingModel.channel_name)"
            }else {
                cell.imageV.removeFromSuperview()
                cell.nameLabel.removeFromSuperview()
                cell.noZhiBoLabel.isHidden = false
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.currentHaveLive == isLive.no.rawValue ? cellHeight/2 : finalScreenW / 16 * 9
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "正在直播"
        }else{
            return "往期回顾"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if self.currentHaveLive == isLive.yes.rawValue {
                self.videoIsLive = true
                self.videoURLString = "\(zhiboingModel.channel_stream_ios)"
                //            self.playerView.playVideo(URL(string: "\(zhiboingModel.channel_stream_ios)"), "\(zhiboingModel.channel_name)", self.fatherView)
                self.playVideo()
                self.currentIndex = -1
                self.zhiboModel = ZhiBoHistoryModel(jsonData: "")
                self.currentHaveLive = isLive.yes.rawValue
                
                self.navigationItem.title = "\(zhiboingModel.channel_name)"
                self.videoName = "\(zhiboingModel.channel_name)"
                self.pushTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            }
            
            
        }else{
            self.videoIsLive = false
            self.videoURLString = "\(zhiboHistories[indexPath.row].videofile)"
//            self.playerView.isLive = self.videoIsLive
//            self.playerView.playVideo(URL(string: "\(zhiboHistories[indexPath.row].videofile)"), "\(zhiboHistories[indexPath.row].title)", self.fatherView)
            self.playVideo()
            self.currentIndex = indexPath.row
            self.zhiboModel = zhiboHistories[indexPath.row]
            self.currentHaveLive = globalAppConfig.CH2.TV.count == 3 ? isLive.yes.rawValue : isLive.no.rawValue
            
            self.navigationItem.title = "\(zhiboHistories[indexPath.row].title)"
            self.videoName = "\(zhiboHistories[indexPath.row].title)"
            self.titleLabel.text = "\(zhiboHistories[indexPath.row].title)"
            self.pushTableView.selectRow(at: IndexPath(row: self.currentIndex, section: 1), animated: true, scrollPosition: .top)
        }
    }
    
    
}

//MARK: - 点击事件
extension ZhiBoPlayerViewController {
    @objc private func toggleTable(){
        self.toggleArrow()
        UIView.animate(withDuration: 0.2) {
            if self.pushTableView.frame.size.height == 0 {
                self.view.backgroundColor = .black
                self.commentFatherView.backgroundColor = .black
                self.pushTableView.frame.size.height = self.commentFatherView.frame.size.height
            } else {
                self.view.backgroundColor = .white
                self.commentFatherView.backgroundColor = .white
                self.pushTableView.frame.size.height = 0
            }
        }
        //弹出历史直播时让tableView滑动到正在播放的节目
        if self.currentIndex == -1 {
            self.pushTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }else{
            self.pushTableView.selectRow(at: IndexPath(row: self.currentIndex, section: 1), animated: true, scrollPosition: .top)
        }
    }
    ///标题view的箭头旋转动画
    @objc private func toggleArrow(){
        //创建动画
        let anim = CABasicAnimation()
        //一个重要的设置:就是keyPath
        //旋转动画一定要设置为transform.rotation,不能写错
        anim.keyPath = "transform.rotation"
        //目标值
        if self.pushTableView.frame.size.height != 0 {
            anim.toValue = 0
        }else {
            anim.toValue = Double.pi
        }
        //动画时长
        anim.duration = 0.2
        //以下两句可以设置动画结束时 layer停在toValue这里
        anim.isRemovedOnCompletion = false
        anim.fillMode = CAMediaTimingFillMode.forwards
        //添加动画到layer层上
        downArrowImage.layer.add(anim, forKey: nil)
    }
    
    override func shareEvent() {
        //加载分享图片
        let kfManager = KingfisherManager.shared
        let downloader = kfManager.downloader
        kfManager.defaultOptions = [.downloader(downloader), .forceRefresh, .backgroundDecode, .downloadPriority(1.0)]
        let resouce = ((currentIndex == -1) ? ImageResource(downloadURL: URL(string: "\(zhiboingModel.channel_picture)")!) : ImageResource(downloadURL: URL(string: "\(zhiboModel.titlepic)")!))
        DispatchQueue.main.async {
            let _ = kfManager.retrieveImage(with: resouce, options: nil, progressBlock: nil) { (image, error, cacheType, imageUrl) in
                if error == nil {
                    //success
                    let textShare = ((self.currentIndex == -1) ? self.zhiboingModel.channel_desc : self.zhiboModel.title)
                    //        let contentShare = "分享的内容。"
                    let imageShare:UIImage = image!
//                    let imageShare:UIImage = UIImage(data: YTools.resetImgSize(sourceImage: image!, maxImageLenght: 200, maxSizeKB: 280))!
//                    print(imageShare.kilobytesSize)
                    
//                    http://1.videoshare.applinzi.com/share.php?img=http://www.wjyanghu.com/API/Logo/channel/TV_CH1.png&url=http://www.wjyanghu.com/ZbFiles/tv/wjxw/201906/wjxw_20190607_010.mp4&title=%E7%94%9F%E6%B4%BB%E8%BF%9E%E7%BA%BF20190606&body=%E7%94%9F%E6%B4%BB%E8%BF%9E%E7%BA%BF20190606
                    let urlShare = ((self.currentIndex == -1) ? URL(string: self.zhiboingModel.channel_url) : URL(string:YTools.jointShareUrl(img: self.zhiboModel.titlepic, url: self.zhiboModel.videofile, title: self.zhiboModel.title, body: self.zhiboModel.title)))
//                    print(YTools.jointShareUrl(img: self.zhiboModel.titlepic, url: self.zhiboModel.videofile, title: self.zhiboModel.title, body: self.zhiboModel.title))
//                    print(urlShare)
                    let activityItems = [textShare,imageShare,urlShare] as [Any]
                    let toVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                    self.present(toVC, animated: true, completion: nil)
                }else{
                    print("failed")
                }
            }
        }
        
    }
}
