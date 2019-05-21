//
//  BaseAudioViewController.swift
//  NextAiwujin
//  音频播放
//  Created by DEV2018 on 2019/4/25.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import EFNavigationBar
import FRadioPlayer
import AVKit
import MediaPlayer
class BaseAudioViewController: BasePlayerViewController {
    ///广播频道信息
    var channelData:RadioModel = RadioModel(jsonData: "")
    ///节目播出时间数组
    var timeList:[Date] = []
    
    var mpVolumeSlider: UISlider?
    
    let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    //MARK: - 懒加载
    ///自定义的导航栏
    lazy var navBar = EFCustomNavigationBar.CustomNavigationBar()
    
    ///背景View
    lazy var bgView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "music_background"))
        return view
    }()
    ///logoView
    lazy var logoView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    ///动画
    lazy var animateView: UIImageView = {
        let barsAnim = UIImageView()
        barsAnim.image = #imageLiteral(resourceName: "NowPlayingBars-3")
        barsAnim.animationImages = NSArray() as [AnyObject] as? [UIImage];
        barsAnim.animationImages?.append(UIImage(named: "NowPlayingBars-0")!);
        barsAnim.animationImages?.append(UIImage(named: "NowPlayingBars-1")!);
        barsAnim.animationImages?.append(UIImage(named: "NowPlayingBars-2")!);
        barsAnim.animationImages?.append(UIImage(named: "NowPlayingBars-3")!);
        barsAnim.animationDuration = 0.5;
        barsAnim.animationRepeatCount = 0;
        barsAnim.stopAnimating()
        return barsAnim
    }()
    ///开始暂停按钮
    lazy var startOrPauseButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage(#imageLiteral(resourceName: "btn-play"), for: UIControl.State.normal)
        btn.setImage(#imageLiteral(resourceName: "btn-pause"), for: UIControl.State.selected)
        btn.addTarget(self, action: #selector(startOrPauseAudio), for: UIControl.Event.touchUpInside)
        return btn
    }()
    ///音量调节
    
    ///音量减
    lazy var voiMinus:UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "vol-min"))
        return image
    }()
    
    ///音量加
    lazy var voiPlus:UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "vol-max"))
        return image
    }()
    ///简介label
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    ///节目单选择显示控件
    lazy var listPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tintColor = .white
        picker.showsSelectionIndicator = true
        picker.isUserInteractionEnabled = true
        return picker
    }()
    ///正在播放label
    lazy var nowPlayingLabel: UILabel = {
        let label = UILabel(text: "正在播放")
        label.textColor = #colorLiteral(red: 1, green: 0.5018206924, blue: 0.3972025379, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.cancel()
    }
    
    func startTimer() {
        // 定义需要计时的时间
        var timeCount = 60000
        // 在global线程里创建一个时间源
        
        // 设定这个时间源是每秒循环一次，立即开始
        timer.schedule(deadline: .now(), repeating: .seconds(5))
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
//                print("-------%d",timeCount);
//                print(YTools.stringToDate(str: YTools.dateToString(date: Date(timeIntervalSinceNow: 0))))
//                print(Date.init(timeIntervalSinceNow: 0).hour)
                
                self.listPickerView.selectRow(self.timeBetweenDate(hour: Date.init(timeIntervalSinceNow: 0).hour, minute: Date.init(timeIntervalSinceNow: 0).minute), inComponent: 0, animated: true)
            }
        })
        // 启动时间源
        timer.resume()
        
        
    }
    ///确认当前b正在播放节目的方法
    func timeBetweenDate(hour:Int, minute:Int) -> Int{
//        print(hour)
//        print(minute)
        //先将当前时间转换为和上一页面传过来的时间数组成员一样的格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        var nowtimeStr = ""
        if hour<10{
            //增加占位符0
            nowtimeStr = "0\(hour)"
        }else{
            nowtimeStr = "\(hour)"
        }
        if minute<10 && minute > 0{
            //增加占位符0
            nowtimeStr += ":0\(minute)"
        }else if minute % 10 == 0{
            //处于整数分钟数时自动+1分钟，便于计算更新正在播出的节目
            nowtimeStr += ":\(minute + 1)"
        }else{
            nowtimeStr += ":\(minute)"
        }
        //判断节目是否在播出
        if hour<7{
            self.nowPlayingLabel.text = "等待播出"
        }else if hour==22{
            if minute>29{
                self.nowPlayingLabel.text = "等待播出"
            }else{
                self.nowPlayingLabel.text = "正在播放"
            }
        }else if hour > 22{
            self.nowPlayingLabel.text = "等待播出"
        }else {
            self.nowPlayingLabel.text = "正在播放"
        }
//        print(nowtimeStr)
        let nowDate = dateFormatter.date(from: nowtimeStr)!
//        print(nowDate)
        for i in 0..<timeList.count {
            if i==(timeList.count-1){
                break
            }
            if nowDate.isBetween(timeList[i], timeList[i+1]){
                print(timeList[i])
                return i
            }
            
        }
        return 0
    }
//    deinit {
//        self.playerView.avItem?.removeObserver(self, forKeyPath: "status", context: nil)
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard let avItem = object as? AVPlayerItem else {
//            return
//        }
//        if keyPath == "status"{
//            if avItem.status == AVPlayerItem.Status.readyToPlay {
//                                print("AVPlayerItem.Status.readyToPlay9999")
//                playerView.playerStatu = PlayerStatus.Pause // 初始状态为播放
//                //                print("AVPlayerItem.Status.readyToPlay8888")
//            }
//        }
//    }
}

extension BaseAudioViewController{
    
    override func setUI() {
        super.setUI()
        //进入页面后自动开始播放，隐藏
        self.playerView.isHidden = true
        playerView.isVideo = false
//        self.playerView.avItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
//        self.playerView.addObserver(self, forKeyPath: "playerStatu", options: NSKeyValueObservingOptions.new, context: nil)
        //1.设置背景view
        setBGView()
        //2.设置自定义导航栏
        setupNavBar()
        //3.设置主体view
        setBodyView()
        
        
        
        
    }
    
    override func initData() {
        super.initData()
        
    }
    
    func updatePlayingAudio(){
        
    }
    
    func setBodyView(){
        //1.设置logo
        logoView.kf.setImage(with: URL(string: "\(channelData.channel_logo)"), placeholder: UIImage(named: "loading"))
        self.view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(180)
        }
        //2.设置开始暂停按钮
        self.view.addSubview(startOrPauseButton)
        startOrPauseButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-30 - (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0))
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        //3.设置音量控件
        //MARK: - 从系统音频控件中取出音量调节滑动控件，添加到主视图中(模拟器中无效)
        for subview in MPVolumeView().subviews {
            guard let volumeSlider = subview as? UISlider else { continue }
            mpVolumeSlider = volumeSlider
        }
        guard let mpVolumeSlider = mpVolumeSlider else { return }
        self.view.addSubview(mpVolumeSlider)
        mpVolumeSlider.snp.makeConstraints { (make) in
            make.bottom.equalTo(startOrPauseButton.snp.top).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(40)
        }
        mpVolumeSlider.setThumbImage(#imageLiteral(resourceName: "slider-ball"), for: UIControl.State.normal)
        self.view.addSubview(voiMinus)
        self.view.addSubview(voiPlus)
        voiMinus.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.centerY.equalTo(mpVolumeSlider.snp.centerY)
            make.right.equalTo(mpVolumeSlider.snp.left).offset(-10)
        }
        voiPlus.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.centerY.equalTo(mpVolumeSlider.snp.centerY)
            make.left.equalTo(mpVolumeSlider.snp.right).offset(10)
        }
        //4.设置简介label
        descLabel.text = "\(channelData.channel_desc)"
        self.view.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        //5.设置节目单控件
        self.view.addSubview(listPickerView)
        listPickerView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.top.equalTo(descLabel.snp.bottom).offset(20)
            make.bottom.equalTo(mpVolumeSlider.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        //6.设置正在播出label
        self.view.addSubview(nowPlayingLabel)
        nowPlayingLabel.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.centerY.equalTo(listPickerView.snp.centerY)
            make.right.equalTo(listPickerView.snp.left)
        }
        
        
    }
    
    func setBGView(){
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavBar() {
        view.addSubview(navBar)
        
        // 设置自定义导航栏背景图片
//        navBar.barBackgroundImage = #imageLiteral(resourceName: "navi_bg")
        // 设置自定义导航栏标题颜色
//        navBar.titleLabelColor = .white
        
        // 设置自定义导航栏左右按钮字体颜色
        navBar.setTintColor(color: .white)
        navBar.setBottomLineHidden(hidden: true)
        
        navBarTintColor = .white
        navBarTitleColor = .white
//        navBar.leftButton = backButton
        navBar.leftButton.isHidden = false
        navBar.rightButton.isHidden = false
        navBar.leftButton.setImageForAllStates(#imageLiteral(resourceName: "login_back"))
        navBar.title = "\(channelData.channel_name)"
        // 设置自定义导航栏背景颜色
//        navBar.backgroundColor = .red
        navBar.barBackgroundColor = .clear
        
        navBar.rightButton.addSubview(animateView)
        animateView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview().dividedBy(2)
            make.center.equalToSuperview()
        }
        
    }
}

//MARK: - 点击事件
extension BaseAudioViewController{
    @objc func startOrPauseAudio(){
        if playerView.playerStatu == PlayerStatus.Playing{
            playerView.playerStatu = PlayerStatus.Pause
            startOrPauseButton.isSelected = false
            animateView.stopAnimating()
        }else{
            playerView.playerStatu = .Playing
            startOrPauseButton.isSelected = true
            animateView.startAnimating()
        }
    }
}

//MARK: - 实现节目单选择控件的代理
extension BaseAudioViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return channelData.program.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return channelData.program[row].program_name
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "\(channelData.program[row].program_name) \(channelData.program[row].start_time)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        
    }
    
}
