//
//  GuangBoViewController.swift
//  NextAiwujin
//  广播vc
//  Created by DEV2018 on 2019/4/15.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class GuangBoViewController: ZhiBoBaseViewController {
    let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    ///节目单播出时间数组
    var timeList:[Date] = [] {
        didSet{
            
        }
    }
    
    override var GuangBoData: CH4Model{
        didSet{
            timeList = []
            for program in GuangBoData.Radio[0].program {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.locale = Locale.current
                dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
  //            dateFormatter.timeZone = timeZone
                timeList.append(dateFormatter.date(from: program.start_time)!)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
            //加入最后一个节目的结束时间，便于比较
            timeList.append(dateFormatter.date(from: GuangBoData.Radio[0].program.last!.end_time)!)
            //打印当前播放节目的index
//            print(GuangBoData.Radio[0].program[YTools.nowPlayAudioIndex(timeList: timeList)].program_name)
            secondCollView.reloadData()
            mainTable.reloadData{
                self.mainTable.switchRefreshHeader(to: .normal(.success, 0.5))
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    deinit {
        timer.cancel()
        print("timer.cancel()")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if timer.isCancelled{
            print("timer.resume()")
            timer.resume()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.suspend()
    }

}
//MARK: - 设置UI
extension GuangBoViewController{
    override func setUI() {
        super.setUI()
//        self.view.backgroundColor = .random
        startTimer()
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
        vc.programInfo = GuangBoData.Radio[indexPath.row].program[YTools.nowPlayAudioIndex(timeList: timeList)]
        vc.playingIndex = YTools.nowPlayAudioIndex(timeList: timeList)
//        var tempList:[Date] = []
//        for program in GuangBoData.Radio[indexPath.row].program {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "HH:mm"
//            dateFormatter.locale = Locale.current
//            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
////            dateFormatter.timeZone = timeZone
//            tempList.append(dateFormatter.date(from: program.start_time)!)
//        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.locale = Locale.current
//        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
//        //            dateFormatter.timeZone = timeZone
//        //节目单时间数组中多传一个10:30，代表最后一个节目的结束时间为10:30
//        self.timeList.append(dateFormatter.date(from: "22:30")!)
        vc.timeList = self.timeList
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
                    cell.startTimeLabel.text = "\(GuangBoData.Radio[0].program[indexPath.row - 1].start_time)-\(GuangBoData.Radio[0].program[indexPath.row - 1].end_time)"
                    cell.guangboImage.kf.setImage(with: URL(string: "\(GuangBoData.Radio[0].program[indexPath.row - 1].program_logo)"), placeholder: UIImage(named: "loading"))
                }
                if (indexPath.row - 1) == YTools.nowPlayAudioIndex(timeList: timeList) {
                    cell.zhiBoTagLabel.isHidden = false
//                    cell.huiTingTagLabel.isHidden = true
                }else{
                    cell.zhiBoTagLabel.isHidden = true
//                    cell.huiTingTagLabel.isHidden = true
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BaseAudioViewController()
        if (indexPath.row-1) == YTools.nowPlayAudioIndex(timeList: self.timeList) {
            vc.videoIsLive = true
            vc.videoURLString = "\(GuangBoData.Radio[0].channel_stream_ios)"
        }else {
            vc.videoIsLive = false
            vc.videoURLString = "\(GuangBoData.Radio[0].program[indexPath.row-1].program_stream)"
        }
        vc.programInfo = GuangBoData.Radio[0].program[indexPath.row-1]
        vc.videoName = "\(GuangBoData.Radio[0].channel_name)"
        vc.channelData = GuangBoData.Radio[0]
        vc.playingIndex = indexPath.row - 1
        vc.timeList = self.timeList
        self.show(vc, sender: self)
    }
}

//MARK: - 自定义方法
extension GuangBoViewController {
    func startTimer() {
        // 定义需要计时的时间
        var timeCount = 60000
        // 在global线程里创建一个时间源
        
        // 设定这个时间源是每秒循环一次，立即开始
        timer.schedule(deadline: .now(), repeating: .seconds(2))
        // 设定时间源的触发事件
        timer.setEventHandler(handler: {
            // 每秒计时一次
            timeCount = timeCount - 1
            // 时间到了取消时间源
            if timeCount <= 0 {
                self.timer.cancel()
            }
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                self.mainTable.reloadData()
            }
        })
        // 启动时间源
        timer.resume()
    }
}
