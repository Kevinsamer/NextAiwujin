//
//  BaseAudioViewController.swift
//  NextAiwujin
//  音频播放
//  Created by DEV2018 on 2019/4/25.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import EFNavigationBar
import DrawerView
import AVKit
import MediaPlayer
import NVActivityIndicatorView
private let programCellID:String = "programCellID"
class BaseAudioViewController: BasePlayerViewController {
    ///广播频道信息
    var channelData:RadioModel = RadioModel(jsonData: "")
    ///节目播出时间数组
    var timeList:[Date] = []
    ///正在播放的节目数据
    var programInfo:CH4ProgramModel = CH4ProgramModel(jsonData: "")
    ///正在播放的节目index
    var playingIndex:Int = -1
    
    var mpVolumeSlider: UISlider?
    
    let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    //MARK: - 懒加载
    ///自定义的导航栏
    lazy var navBar = EFCustomNavigationBar.CustomNavigationBar()
    
    ///loading动画view
    lazy var loadingView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero, type: NVActivityIndicatorType.ballScaleRippleMultiple, color: .white, padding: nil)
        return view
    }()
    
    ///loading动画fatherView
    lazy var loadingFatherView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.454890839)
        return view
    }()
    
    ///背景View
    lazy var bgView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "music_background"))
        return view
    }()
    ///logoView
    lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = UIView.ContentMode.scaleAspectFill
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
    ///播放列表按钮
    lazy var audioListBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImageForAllStates(#imageLiteral(resourceName: "aduio_list"))
        btn.addTarget(self, action: #selector(toggleAudioList), for: UIControl.Event.touchUpInside)
        return btn
    }()
    ///播放列表fatherView
    lazy var drawerView: DrawerView = {
        let drawerView = DrawerView()
        drawerView.attachTo(view: self.view)
        drawerView.delegate = self
        drawerView.snapPositions = [.closed, DrawerPosition.open]
        drawerView.topMargin = self.view.height / 3
        drawerView.insetAdjustmentBehavior = .automatic
        drawerView.backgroundColor = .white
        return drawerView
    }()
    ///播放列表label
    lazy var listLabel: UILabel = {
        let label = UILabel()
//        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        label.text = "节目单"
//        label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return label
    }()
    ///播放列表分隔线
    lazy var alphaLine: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    ///节目列表tableView
    lazy var listTableView: UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "ProgramListCell", bundle: nil), forCellReuseIdentifier: programCellID)
        table.backgroundColor = .white
        table.tableFooterView = UIView(frame: .zero)
        return table
    }()
    ///音量调节(调用系统音量调节)
    
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
    ///logo旋转动画
    lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float.infinity
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        animation.duration = 4.0
        return animation
    }()
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        timer.cancel()
    }
    
    deinit {
        timer.resume()
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
                self.listPickerView.selectRow(self.timeBetweenDate(hour: Date.init(timeIntervalSinceNow: 0).hour, minute: Date.init(timeIntervalSinceNow: 0).minute), inComponent: 0, animated: true)
            }
        })
        // 启动时间源
        timer.resume()


    }
    
    
    /// 确认当前正在播放节目的方法
    ///
    /// - Parameters:
    ///   - hour: 当前的小时
    ///   - minute: 当前的分钟
    /// - Returns: 返回当前正在直播的节目的索引
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
//                print(timeList[i])
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
//MARK: - 设置UI
extension BaseAudioViewController{
    
    override func setUI() {
        super.setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(HideLoadingView), name: AudioPlayingNotificationName, object: nil)
        //进入页面后自动开始播放，隐藏
        self.playerView.isHidden = true
        playerView.isVideo = false
        //1.设置背景view
        setBGView()
        //2.设置自定义导航栏
        setupNavBar()
        //3.设置主体view
        setBodyView()
        //4.设置ui数据
        updatePlayingAudioUI()
        //5.设置抽屉视图
        //5.1将抽屉视图s设置为关闭状态
        drawerView.setPosition(DrawerPosition.closed, animated: false)
        //5.2设置抽屉视图的子视图
        setDrawView()
        //6.展示loading动画
        setLoadingView()
 
    }
    
    override func initData() {
        super.initData()
        
    }
    
    func setLoadingView(){
        self.view.addSubview(loadingFatherView)
        loadingFatherView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        loadingFatherView.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        loadingView.startAnimating()
    }
    
    ///设置ui数据
    func updatePlayingAudioUI(){
        logoView.kf.setImage(with: URL(string: "\(programInfo.program_jpg)"), placeholder: UIImage(named: "loading"))
        if programInfo.program_desc == "转播" {
            descLabel.text = "转播"
        }else {
            descLabel.text = "主持人：\(programInfo.program_desc)"
        }
        navBar.title = "\(programInfo.program_name)"
    }
    
    func setDrawView(){
        drawerView.addSubview(listLabel)
        listLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        drawerView.addSubview(alphaLine)
        alphaLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(listLabel.snp.bottom)
            make.height.equalTo(1)
        }
        drawerView.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(alphaLine.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view).offset(UIDevice.current.isX() ? -IphonexHomeIndicatorH : 0)
        }
    }
    
    func setBodyView(){
        //1.设置logo
        self.view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(self.view.snp.width).multipliedBy(0.8)
        }
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = finalScreenW * 0.4
        logoView.layer.add(animation, forKey: "")
        stopAnimation()
        
        //2.设置开始暂停按钮
        self.view.addSubview(startOrPauseButton)
        startOrPauseButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-30 - (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0))
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
//        startOrPauseButton.isSelected = false
        //2.1设置底部抽屉控制按钮
        self.view.addSubview(audioListBtn)
        audioListBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(startOrPauseButton)
            make.width.height.equalTo(25)
            make.right.equalToSuperview().offset(-20)
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
        
        
        self.view.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        //5.设置节目单控件
//        self.view.addSubview(listPickerView)
//        listPickerView.snp.makeConstraints { (make) in
//            make.width.equalToSuperview().multipliedBy(0.5)
//            make.top.equalTo(descLabel.snp.bottom).offset(20)
//            make.bottom.equalTo(mpVolumeSlider.snp.top).offset(-20)
//            make.centerX.equalToSuperview()
//        }
        
        //6.设置正在播出label
//        self.view.addSubview(nowPlayingLabel)
//        nowPlayingLabel.snp.makeConstraints { (make) in
//            make.width.equalTo(80)
//            make.height.equalTo(30)
//            make.centerY.equalTo(listPickerView.snp.centerY)
//            make.right.equalTo(listPickerView.snp.left)
//        }
        
        
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
//        navBar.title = "\(programInfo.program_name)"
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
        if startOrPauseButton.isSelected == true{
            playerView.playerStatu = PlayerStatus.Pause
            startOrPauseButton.isSelected = false
            animateView.stopAnimating()
            stopAnimation()
        }else{
            playerView.playerStatu = .Playing
            startOrPauseButton.isSelected = true
            animateView.startAnimating()
            startAnimation()
        }
    }
    
    @objc private func toggleAudioList(){
        if drawerView.position == DrawerPosition.closed {
            drawerView.setPosition(DrawerPosition.open, animated: true)
            listTableView.reloadData()
            listTableView.selectRow(at: IndexPath(row: self.playingIndex, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
        }else{
            drawerView.setPosition(DrawerPosition.closed, animated: true)
        }
    }
    
    private func startAnimation(){
        let layer = logoView.layer
        //获取暂停的时间差
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
//
    }
    
    private func stopAnimation(){
        let layer = logoView.layer
        //取出当前时间,转成动画暂停的时间
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        //设置动画运行速度为0
        layer.speed = 0.0
        //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        layer.timeOffset = pausedTime
    }
    
    @objc func HideLoadingView(){
        loadingView.stopAnimating()
        loadingFatherView.removeFromSuperview()
        playerView.playerStatu = .Playing
        startOrPauseButton.isSelected = true
        animateView.startAnimating()
        startAnimation()
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

//MARK: - 实现底部抽屉代理协议
extension BaseAudioViewController:DrawerViewDelegate {
    
}

//MARK: - 实现节目单tableView的代理协议
extension BaseAudioViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelData.program.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: programCellID, for: indexPath) as! ProgramListCell
//        cell.backgroundColor = .random
        cell.programNameLabel.text = "\(channelData.program[indexPath.row].program_name)"
        cell.startTimeLabel.text = "\(channelData.program[indexPath.row].start_time)"
        if indexPath.row == YTools.nowPlayAudioIndex(timeList: self.timeList){
            cell.liveTagLabel.isHidden = false
            
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //如果选中的不是直播中的节目
        if indexPath.row != YTools.nowPlayAudioIndex(timeList: self.timeList) {
            (tableView.cellForRow(at: IndexPath(row: YTools.nowPlayAudioIndex(timeList: self.timeList), section: 0)) as! ProgramListCell).liveTagLabel.isHidden = false
        }else{
            //选中了直播中的节目
        }
    }
    
}
