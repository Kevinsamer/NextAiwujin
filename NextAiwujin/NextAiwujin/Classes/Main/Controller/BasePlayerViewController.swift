//
//  BasePlayerViewController.swift
//  NextAiwujin
//  播放器baseVC
//  Created by DEV2018 on 2019/4/23.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import AVKit
import GrowingTextView
class BasePlayerViewController: BaseViewController {
    ///播放来源
    var videoURLString:String = ""
    ///是否是.m3u8流媒体
    var videoIsLive:Bool = false
    ///播放名称
    var videoName:String = ""
    ///自制节目回看标志位,如果是true则不加载评论视图
    var isTVHuiKan:Bool = false
    
    //评论视图相关
    private var inputToolbar: UIView!
    private var textView: GrowingTextView!
    private var textViewBottomConstraint: NSLayoutConstraint!
    let commentVC = RedditCommentsViewController()
    
    //获取 AppDelegate 对象
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - 懒加载
    ///输入评论时的遮盖view
    lazy var inputAlphaView: UIControl = {
        let view = UIControl()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        view.addTarget(self, action: #selector(tapGestureHandler), for: UIControl.Event.touchUpInside)
        return view
    }()
    ///评论fatherView
    lazy var commentFatherView: UIView = {
        let view = UIView()
        //        view.backgroundColor = .random
        return view
    }()
    
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
        openSwipe()
    }
    
    fileprivate func openSwipe(){
        if self.navigationController != nil {
            self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        }
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
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        self.view.addSubview(fatherView)
        if UIDevice.current.isX(){
            self.view.addSubview(iphoneXPlayerTopTempView)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(popVC), name: PopVCWhenPlayerNotFullScreenNotificationName, object: nil)
//        self.playerView.avItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        if !isTVHuiKan {
            setCommentView()
        }
        
    }
    
    override func initData() {
        super.initData()
        playVideo()
    }
    
    ///设置评论view
    private func setCommentView(){
        self.view.addSubview(commentFatherView)
        commentFatherView.snp.makeConstraints { (make) in
            //添加1的空隙，使得返回手势可以被响应
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(fatherView.snp.bottom).offset(50)
            make.bottom.equalToSuperview().offset(UIDevice.current.isX() ? -IphonexHomeIndicatorH : 0)
        }
        
        // *** Create Toolbar
        inputToolbar = UIView()
        inputToolbar.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
        commentFatherView.addSubview(inputToolbar)
        
        // *** Create GrowingTextView ***
        textView = GrowingTextView()
        textView.delegate = self
        textView.layer.cornerRadius = 4.0
        textView.maxLength = 200
        textView.maxHeight = 70
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.attributedPlaceholder = NSAttributedString(string: "发表评论", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.8, alpha: 1.0)])
        //        textView.placeholderColor = UIColor(white: 0.8, alpha: 1.0)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        inputToolbar.addSubview(textView)
        textView.returnKeyType = .send
        ///设置输入框作为第一响应者时，如果无内容则返回键无法点击
        textView.enablesReturnKeyAutomatically = true
        // *** Autolayout ***
        let topConstraint = textView.topAnchor.constraint(equalTo: inputToolbar.topAnchor, constant: 8)
        topConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            inputToolbar.leadingAnchor.constraint(equalTo: commentFatherView.leadingAnchor),
            inputToolbar.trailingAnchor.constraint(equalTo: commentFatherView.trailingAnchor),
            inputToolbar.bottomAnchor.constraint(equalTo: commentFatherView.bottomAnchor),
            topConstraint
            ])
        
        if #available(iOS 11, *) {
            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.trailingAnchor, constant: -8),
                textViewBottomConstraint
                ])
        } else {
            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.bottomAnchor, constant: -8)
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: inputToolbar.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: inputToolbar.trailingAnchor, constant: -8),
                textViewBottomConstraint
                ])
        }
        
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
//        commentFatherView.addGestureRecognizer(tapGesture)
//
        
        
        self.addChild(commentVC)
        self.commentFatherView.addSubview(commentVC.view)
        commentVC.view.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.right.equalToSuperview()
            make.bottom.equalTo(inputToolbar.snp.top)
        }
        
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
    
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = -keyboardHeight - 8
            commentFatherView.layoutIfNeeded()
        }
    }
    
    @objc private func tapGestureHandler() {
        commentFatherView.endEditing(true)
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

extension BasePlayerViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.isMember(of: GrowingTextView.self) {
            if text == "\n" {
                AppConfigViewModel.requestPostComments(url: API_CommitComments, content: self.textView.text, imageURL: AiWuJinHeadIconUrl, rid: 8) {
                    self.commentVC.requestData()
                }
                textView.text = ""
                textView.resignFirstResponder()
                return false
            }
        }
        
        return true
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        print("即将开始输入")
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        print("已经开始输入")
        //开始输入时添加透明遮盖view
        self.view.addSubview(inputAlphaView)
        inputAlphaView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(inputToolbar.snp.top)
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        inputAlphaView.removeFromSuperview()
//        print("结束输入")
        return true
    }
}

//MARK: - 实现导航栏隐藏后的手势返回
extension BasePlayerViewController:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1{
            return false
        }
        return true
    }
    
    
}
