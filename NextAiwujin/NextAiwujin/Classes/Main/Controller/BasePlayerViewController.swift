//
//  BasePlayerViewController.swift
//  NextAiwujin
//  播放器baseVC
//  Created by DEV2018 on 2019/4/23.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import AVKit
class BasePlayerViewController: BaseViewController {
    ///播放来源
    var videoURLString:String = ""
    ///是否是.m3u8流媒体
    var videoIsLive:Bool = false
    ///播放名称
    var videoName:String = ""
    
    
    //获取 AppDelegate 对象
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - 懒加载
    ///播放器父视图
    lazy var fatherView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIDevice.current.isX() ? finalStatusBarH : 0, width: finalScreenW, height: finalScreenW * 9 / 16))
//        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return view
    }()
    ///播放器
    lazy var playerView: NicooPlayerView = {
        let player = NicooPlayerView(frame: fatherView.bounds, bothSidesTimelable: false)
        player.videoLayerGravity = .resizeAspect
        player.videoNameShowOnlyFullScreen = true
        player.delegate = self
        player.customViewDelegate = self
        return player
    }()
    
    ///刘海屏机型播放器顶部占位view
    lazy var iphoneXPlayerTopTempView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: finalStatusBarH))
        view.backgroundColor = .black
        return view
    }()
    
    ///播放器分享按钮
    lazy var playerShareButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImageForAllStates(#imageLiteral(resourceName: "share_bai"))
        btn.addTarget(self, action: #selector(shareEvent), for: UIControl.Event.touchUpInside)
        return btn
    }()

    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        let orirntation = UIApplication.shared.statusBarOrientation
        if  orirntation == UIInterfaceOrientation.landscapeLeft || orirntation == UIInterfaceOrientation.landscapeRight
        {
            return .lightContent
        }
        
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        // 如果当前播放器已经添加，支持横竖屏
        if self.fatherView.subviews.contains(playerView) {
            orientationSupport = NicooPlayerOrietation.orientationAll
        }
        //该页面显示时可以横竖屏切换(自己的方法)
//        appDelegate.interfaceOrientations = .allButUpsideDown
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //该页面显示时可以横竖屏切换(自己的方法)
//        appDelegate.interfaceOrientations = .portrait
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        /// 离开视频播放页面，只支持竖屏
        playerView.playerStatu = PlayerStatus.Pause
        orientationSupport = NicooPlayerOrietation.orientationPortrait
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
//        self.playerView.deinit()
//        self.playerView.avItem?.removeObserver(self, forKeyPath: "status", context: nil)
    }
    
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard let avItem = object as? AVPlayerItem else {
//            return
//        }
//        if keyPath == "status"{
//            if avItem.status == AVPlayerItem.Status.readyToPlay {
//                print("AVPlayerItem.Status.readyToPlay9999")
//                playerView.playerStatu = PlayerStatus.Playing // 初始状态为播放
//                //                print("AVPlayerItem.Status.readyToPlay8888")
//            }
//        }
//    }
    

}
//MARK: - 设置ui
extension BasePlayerViewController{
    override func setUI() {
        super.setUI()
        self.view.addSubview(fatherView)
        if UIDevice.current.isX(){
            self.view.addSubview(iphoneXPlayerTopTempView)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(popVC), name: PopVCWhenPlayerNotFullScreenNotificationName, object: nil)
//        self.playerView.avItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func initData() {
        super.initData()
        playVideo()
    }
    
    @objc func playVideo(){
        playerView.playVideo(URL(string: videoURLString), videoName, self.fatherView)
        playerView.isLive = self.videoIsLive
        playerView.isVideo = true
//        playerView.videoLayerGravity = .resize
        //保持返回按钮一直显示
        playerView.playControllViewEmbed.closeButton.isHidden = false
        playerView.playControllViewEmbed.closeButton.isEnabled = true
        playerView.playControllViewEmbed.closeButton.snp.updateConstraints { (make) in
            make.width.equalTo(40)
        }
        playerView.playControllViewEmbed.closeButton.setImage(NicooImgManager.foundImage(imageName: "back"), for: UIControl.State.normal)
    }
}

//MARK: - 播放器代理
extension BasePlayerViewController:NicooPlayerDelegate, NicooCustomMuneDelegate{
    func retryToPlayVideo(_ player: NicooPlayerView, _ videoModel: NicooVideoModel?, _ fatherView: UIView?) {
        print("网络不可用时调用")
        let url = URL(string: videoModel?.videoUrl ?? "")
        if  let sinceTime = videoModel?.videoPlaySinceTime, sinceTime > 0 {
            player.replayVideo(url, videoModel?.videoName, fatherView, sinceTime)
        }else {
            player.playVideo(url, videoModel?.videoName, fatherView)
        }
    }
    
    func customTopBarActions() -> [UIButton]? {
        return [playerShareButton]
    }
    
//    func showCustomMuneView() -> UIView? {
//
//        return CustomMuneView()
//    }
    
}

//MARK: - 点击事件
extension BasePlayerViewController{
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareEvent(){
        print("分享")
//        print(playerShareButton.frame.size)
    }
}
