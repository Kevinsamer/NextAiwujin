//
//  GuangBoViewController.swift
//  NextAiwujin
//  广播vc
//  Created by DEV2018 on 2019/4/15.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class GuangBoViewController: ZhiBoBaseViewController {
    
    override var GuangBoData: CH4Model{
        didSet{
            secondCollView.reloadData()
            mainTable.reloadData{
                self.mainTable.switchRefreshHeader(to: .normal(.success, 0.5))
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
//MARK: - 设置UI
extension GuangBoViewController{
    override func setUI() {
        super.setUI()
        self.view.backgroundColor = .random
    }
    
    override func initData() {
        super.initData()
    }
}

//MARK: - collectionView代理
extension GuangBoViewController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(GuangBoData.Radio.count)
        return GuangBoData.Radio.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! SecondSectionCell
        cell.imageV.kf.setImage(with: URL.init(string: GuangBoData.Radio[indexPath.row].channel_logo), placeholder: UIImage(named: "loading"))
        cell.titleLabel.text = GuangBoData.Title
        cell.titleLabel.adjustsFontSizeToFitWidth = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = BaseAudioViewController()
        vc.videoIsLive = true
        vc.videoURLString = "\(GuangBoData.Radio[indexPath.row].channel_stream_ios)"
        vc.videoName = "\(GuangBoData.Radio[indexPath.row].channel_name)"
        vc.channelData = GuangBoData.Radio[indexPath.row]
        var tempList:[Date] = []
        for program in GuangBoData.Radio[indexPath.row].program {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
//            dateFormatter.timeZone = timeZone
            tempList.append(dateFormatter.date(from: program.start_time)!)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        //            dateFormatter.timeZone = timeZone
        //节目单时间数组中多传一个10:30，代表最后一个节目的结束时间为10:30
        tempList.append(dateFormatter.date(from: "22:30")!)
        vc.timeList = tempList
        self.show(vc, sender: self)
    }
}
//MARK: - tableView的代理
extension GuangBoViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2{
            if indexPath.row != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: guangboCellID, for: indexPath) as! GuangboCell
                if GuangBoData.Radio.count > 0 {
                    cell.guangboNameLabel.text = GuangBoData.Radio[0].program[indexPath.row - 1].program_name
                    cell.startTimeLabel.text = GuangBoData.Radio[0].program[indexPath.row - 1].start_time
                    cell.guangboImage.kf.setImage(with: URL(string: "\(GuangBoData.Radio[0].program[indexPath.row - 1].program_logo)"), placeholder: UIImage(named: "loading"))
                }
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
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            //该section第一个row用作header,所以需要+1
            if GuangBoData.Radio.count > 0{
                return GuangBoData.Radio[0].program.count + 1
            }
            
        }
        
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
}
