//
//  ZhiBoViewController.swift
//  NextAiwujin
//  直播vc
//  Created by DEV2018 on 2019/4/15.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class ZhiBoViewController: ZhiBoBaseViewController {
    
    var zhiBoHistories:[ZhiBoHistoryModel] = [] {
        didSet{
            print(oldValue.count)
            print(zhiBoHistories.count)
//            mainTable.reloadData{
//                self.mainTable.switchRefreshHeader(to: .normal(.success, 0.5))
//            }
        }
    }
    
    override var ZhiBoData: CH2Model{
        didSet{
            secondCollView.reloadData()
            mainTable.reloadData{
                self.mainTable.switchRefreshHeader(to: .normal(.success, 0.5))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

extension ZhiBoViewController{
    override func setUI() {
        super.setUI()
//        self.view.backgroundColor = .random
    }
    
    override func initData() {
        
        super.initData()
        AppConfigViewModel.requestZhiBoHistory(url: API_ZhiBoHistory) { (histories) in
            self.zhiBoHistories = histories
        }
    }
}
//MARK: - collectionView代理
extension ZhiBoViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ZhiBoData.TV.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! SecondSectionCell
        cell.imageV.kf.setImage(with: URL.init(string: ZhiBoData.TV[indexPath.row].channel_logo), placeholder: UIImage.init(named: "loading"))
        cell.titleLabel.text = "\(ZhiBoData.TV[indexPath.row].channel_name)"
//        if indexPath.row < ZhiBoData.TV.count{}else{cell.titleLabel.text = "现场直播"}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < ZhiBoData.TV.count{
            if ZhiBoData.TV[indexPath.row].is_live == "1"{
                let vc = ZhiBoPlayerViewController()
                vc.currentIndex = -1
                vc.zhiboingModel = ZhiBoData.TV[indexPath.row]
                vc.zhiboHistories = self.zhiBoHistories
                vc.videoIsLive = true
                vc.videoURLString = "\(ZhiBoData.TV[indexPath.row].channel_stream_ios)"
                vc.navigationItem.title = "\(ZhiBoData.TV[indexPath.row].channel_name)"
                vc.videoName = "\(ZhiBoData.TV[indexPath.row].channel_name)"
                self.show(vc, sender: self)
            }else{
                let vc = TVPinDaoViewController()
                vc.TVInfo = ZhiBoData.TV[indexPath.row]
                vc.videoIsLive = true
                vc.videoURLString = "\(ZhiBoData.TV[indexPath.row].channel_stream_ios)"
                vc.navigationItem.title = "\(ZhiBoData.TV[indexPath.row].channel_name)"
                vc.videoName = "\(ZhiBoData.TV[indexPath.row].channel_name)"
                self.show(vc, sender: self)
            }
            
        }
        
    }
}
//MARK: - tableView的代理
extension ZhiBoViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2{
            if indexPath.row != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: zhiboCellID, for: indexPath) as! ZhiBoCell
                cell.huikan = false
                if ZhiBoData.TV.count > 0 {
//                    cell.guangboNameLabel.text = GuangBoData.Radio[0].program[indexPath.row - 1].program_name
//                    cell.startTimeLabel.text = GuangBoData.Radio[0].program[indexPath.row - 1].start_time
//                    cell.guangboImage.kf.setImage(with: URL(string: "\(GuangBoData.Radio[0].program[indexPath.row - 1].program_logo)"), placeholder: UIImage(named: "loading"))
//                    cell.imageV.kf
//                    , placeholder: UIImage(named: "loading")
                    cell.imageV.kf.setImage(with: URL(string: "\(ZhiBoData.TV[indexPath.row-1].channel_picture)"),options: [.forceRefresh, .transition(.fade(0.5))])
                    cell.descLabel.text = "\(ZhiBoData.TV[indexPath.row-1].channel_desc)"
                    cell.titleLabel.text = "\(ZhiBoData.TV[indexPath.row-1].channel_name)\n "
                    cell.titleLabel.sizeToFit()
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath)
                let imageV = UIImageView(frame: CGRect(x: 10, y: 20, width: 5, height: 20))
                imageV.image = #imageLiteral(resourceName: "redline")
                let label = UILabel(frame: CGRect(x: 20, y: 20, width: 100, height: 20))
                //                label.font = UIFont.systemFont(ofSize: 60)
                label.adjustsFontSizeToFitWidth = true
                label.backgroundColor = .white
                label.text = "往期直播"
                //                label.backgroundColor = .yellow
                cell.addSubview(label)
                cell.addSubview(imageV)
                cell.backgroundColor = .white
                let alphaView = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: 10))
                alphaView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                cell.addSubview(alphaView)
                cell.selectionStyle = .none
                return cell
                //                cell.backgroundColor = .red
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: zhiboCellID, for: indexPath) as! ZhiBoCell
                cell.huikan = true
                cell.imageV.kf.setImage(with: URL(string: "\(zhiBoHistories[indexPath.row - 1].titlepic)"), options: [.fromMemoryCacheOrRefresh, .transition(.fade(1))])
                cell.descLabel.text = "时间：\(zhiBoHistories[indexPath.row - 1].time)"
                cell.titleLabel.text = "\(zhiBoHistories[indexPath.row - 1].title)\n "
                cell.titleLabel.sizeToFit()
                cell.selectionStyle = .none
                return cell
            }
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 2 {
            if indexPath.row != 0 {
                return 100
            }
        }else if indexPath.section == 3 {
            if indexPath.row != 0 {
                return 100
            }
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            //该section第一个row用作header,所以需要+1
            if ZhiBoData.TV.count > 0{
                return ZhiBoData.TV.count + 1
            }
            
        }
        if section == 3{
            if self.zhiBoHistories.count > 0{
                return zhiBoHistories.count + 1
            }
        }
        
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            if indexPath.row > 0{
                //is_live=1时为直播,进入直播页
                if ZhiBoData.TV[indexPath.row-1].is_live == "1"{
                    let vc = ZhiBoPlayerViewController()
                    vc.currentIndex = -1
                    vc.zhiboingModel = ZhiBoData.TV[indexPath.row-1]
                    vc.zhiboHistories = self.zhiBoHistories
                    vc.videoIsLive = true
                    vc.videoURLString = "\(ZhiBoData.TV[indexPath.row-1].channel_stream_ios)"
                    vc.navigationItem.title = "\(ZhiBoData.TV[indexPath.row-1].channel_name)"
                    vc.videoName = "\(ZhiBoData.TV[indexPath.row-1].channel_name)"
                    self.show(vc, sender: self)
                }else{
                    let vc = TVPinDaoViewController()
                    vc.TVInfo = ZhiBoData.TV[indexPath.row-1]
                    vc.videoIsLive = true
                    vc.videoURLString = "\(ZhiBoData.TV[indexPath.row-1].channel_stream_ios)"
                    vc.navigationItem.title = "\(ZhiBoData.TV[indexPath.row-1].channel_name)"
                    vc.videoName = "\(ZhiBoData.TV[indexPath.row-1].channel_name)"
                    self.show(vc, sender: self)
                }
            }
        }else if indexPath.section == 3{
            if indexPath.row > 0{
                let vc = ZhiBoPlayerViewController()
                vc.currentIndex = indexPath.row-1
                vc.zhiboHistories = self.zhiBoHistories
                vc.zhiboModel = zhiBoHistories[indexPath.row-1]
                vc.videoIsLive = false
//                vc.currentHaveLive = isLive.yes.rawValue
                vc.videoURLString = "\(zhiBoHistories[indexPath.row-1].videofile)"
                vc.navigationItem.title = "\(zhiBoHistories[indexPath.row-1].title)"
                vc.videoName = "\(zhiBoHistories[indexPath.row-1].title)"
                self.show(vc, sender: self)
            }
        }
    }
}
