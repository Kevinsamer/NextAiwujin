//
//  TVHuiKanPlayerController.swift
//  NextAiwujin
//  视频回看播放页面
//  Created by DEV2018 on 2019/5/8.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
private let programCellID:String = "programCellID"
private let cellHeight:CGFloat = 120
class TVHuiKanPlayerController: BasePlayerViewController {
    //节目单信息
    var tvs:[CH3ProgramVideoModel] = []{
        didSet{
            programListTable.reloadData{[unowned self] in
                for index in 0..<self.tvs.count {
                    if self.tvs[index].title == self.tvInfo.title{
                        self.programListTable.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.top)
                    }
                }
                
            }
        }
    }
    ///正在播放的节目
    var tvInfo:CH3ProgramVideoModel = CH3ProgramVideoModel(jsonData: "")
    var tvLogo:String = ""
    var tvName:String = ""
    //MARK: - 懒加载
    ///当前视频标题view
    lazy var titleView: UIView = {
        let view = UIView()
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
    ///标题view的分隔线
    lazy var titleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    ///节目信息view
    lazy var programInfoView: UIView = {
        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return view
    }()
    ///节目logo
    lazy var programLogo: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    ///节目名称label
    lazy var programNameLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        return label
    }()
    ///节目信息view分隔线
    lazy var programInfoLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    ///节目列表tableview
    lazy var programListTable: UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        table.contentInsetAdjustmentBehavior = .never
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
//        table.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        table.register(UINib(nibName: "DianshiCell", bundle: nil), forCellReuseIdentifier: programCellID)
        return table
    }()
    
    
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

    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

//MARK: - 设置ui
extension TVHuiKanPlayerController{
    override func setUI() {
        super.setUI()
        
        self.view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        //1.设置标题view
        setTitleView()
        //2.设置节目信息view
//        setProgramInfoView()
        //2.设置节目列表tableview
        setProgramList()
    }
    ///设置节目列表tableview
    private func setProgramList(){
        self.view.addSubview(programListTable)
        programListTable.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.equalToSuperview().offset(UIDevice.current.isX() ? -IphonexHomeIndicatorH : 0)
            make.left.right.equalToSuperview()
        }
    }
    ///设置节目信息view(弃用)
    private func setProgramInfoView(){
        self.view.addSubview(programInfoView)
        programInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        programInfoView.addSubview(programLogo)
        programLogo.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(programInfoView.snp.height)
            make.height.equalToSuperview().multipliedBy(0.9)
            make.left.equalToSuperview().offset(20)
        }
        programLogo.kf.setImage(with: URL(string: "\(tvLogo)"), placeholder: UIImage.init(named: "loading"))
//        programLogo.clipsToBounds = true
//        programLogo.layer.masksToBounds = true
//        programLogo.layer.cornerRadius = 32
        programInfoView.addSubview(programNameLabel)
        programNameLabel.text = "\(tvName)"
        programNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(programLogo.snp.right).offset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview()
        }
        programNameLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        programInfoView.addSubview(programInfoLineView)
        programInfoLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    ///设置标题view
    private func setTitleView(){
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(fatherView.snp.bottom)
            make.height.equalTo(50)
        }
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview()
        }
        titleLabel.text = "\(videoName)"
//        titleView.addSubview(titleLineView)
//        titleLineView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalToSuperview()
//            make.height.equalTo(1)
//        }
        titleView.addSubview(titleShareButton)
    }
    
    override func initData() {
        super.initData()
    }
}

//MARK: - tableView的代理协议
extension TVHuiKanPlayerController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: programCellID, for: indexPath) as! DianshiCell
        //        cell.removeSubviews()
        cell.cellHeight = cellHeight
        cell.isPlayer = true
//        cell.backgroundColor = .white
//        if tvInfo.title == tvs[indexPath.row].title {
//            print(tvs[indexPath.row].title)
//            cell.setSelected(true, animated: true)
//        }
        if tvs.count > 0{
            cell.imageV.kf.setImage(with: URL.init(string: "\(tvs[indexPath.row].totalImagePath)"), placeholder: UIImage.init(named: "loading"))
            cell.nameLabel.text = "\(tvs[indexPath.row].title)\n"
            cell.updateTimeLabel.text = "发布时间:\(YTools.dateToString(date: Date.init(timeIntervalSince1970: Double(tvs[indexPath.row].newstime)!)))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(tvs[indexPath.row].title)
        if tvs[indexPath.row].title != self.tvInfo.title {
            //选中cell的视频标题与正在播放的不同，需要换源播放
            self.playerView.playVideo(URL(string: "\(tvs[indexPath.row].totalVideoPath)"), "\(tvs[indexPath.row].title)", self.fatherView)
            self.tvInfo = tvs[indexPath.row]
            self.videoURLString = tvs[indexPath.row].totalVideoPath
            self.navigationItem.title = tvs[indexPath.row].title
            self.videoName = tvs[indexPath.row].title
            self.titleLabel.text = tvs[indexPath.row].title
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.top)
        }
    }
    
}


//MARK: - 点击事件
extension TVHuiKanPlayerController {
    override func shareEvent() {
        let kfManager = KingfisherManager.shared
        let downloader = kfManager.downloader
        kfManager.defaultOptions = [.downloader(downloader), .forceRefresh, .backgroundDecode]
        let resouce = ImageResource(downloadURL: URL(string: "\(tvInfo.totalImagePath)")!)
        DispatchQueue.main.async {
            let _ = kfManager.retrieveImage(with: resouce, options: nil, progressBlock: nil) { (image, error, cacheType, imageUrl) in
                if error == nil {
                    //success
                    let textShare = self.tvInfo.title
                    //let contentShare = "分享的内容。"
                    let imageShare:UIImage = image!
                    //                    print(imageShare.bytesSize)
                    let urlShare = URL(string: YTools.jointShareUrl(img: self.tvInfo.totalImagePath, url: self.tvInfo.totalVideoPath, title: self.tvInfo.title, body: self.tvInfo.title))
                    let activityItems = [textShare,imageShare,urlShare!] as [Any]
                    let toVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                    
                    self.navigationController?.present(toVC, animated: true, completion: nil)
                }else{
                    print("failed")
                }
            }
        }
    }
}
