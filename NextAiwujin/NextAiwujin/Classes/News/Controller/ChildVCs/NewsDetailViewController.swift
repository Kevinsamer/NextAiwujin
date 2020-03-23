//
//  NewsDetailViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/8.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher
import DrawerView
import SnapKit
class NewsDetailViewController: BaseViewController {
    
    var newsDetailURL:String = ""
    var sharePicURL:String = ""
    var textShare:String = ""
//    var news:CH1MenuItemModel?
    //MARK: - 懒加载
    
    
    /// 微信分享朋友圈按钮
    lazy var wx_pyqBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColorForAllStates(.black)
        btn.frame = CGRect(x: finalScreenW / 8, y: 50, width: finalScreenW / 4, height: finalScreenW / 3)
//        btn.contentMode = .scaleAspectFit
        btn.setImageForAllStates(#imageLiteral(resourceName: "wx_pyq"))
        btn.setTitle("朋友圈", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        btn.setTitleColorForAllStates(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
//        btn.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        btn.setButtonTitleImageStyle(padding: 10, style: TitleImageStyly.ButtonImageTitleStyleTop)
        btn.addTarget(self, action: #selector(WXpyqShare), for: .touchUpInside)
        return btn
    }()
    
    
    /// 微信分享至会话按钮
    lazy var wx_hhBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: finalScreenW * 3 / 8, y: 50, width: finalScreenW / 4, height: finalScreenW / 3)
//        btn.contentMode = .scaleAspectFit
        btn.setImageForAllStates(#imageLiteral(resourceName: "wx_hh"))
        btn.setTitleForAllStates("微信好友")
        btn.setTitleColorForAllStates(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
//        btn.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        btn.setButtonTitleImageStyle(padding: 10, style: TitleImageStyly.ButtonImageTitleStyleTop)
        btn.addTarget(self, action: #selector(WXhhShare), for: .touchUpInside)
        return btn
    }()
    
    /// 复制链接按钮
    lazy var copyLinkBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: finalScreenW * 5 / 8, y: 50, width: finalScreenW / 4, height: finalScreenW / 3)
        
        btn.setImageForAllStates(#imageLiteral(resourceName: "link"))
        btn.setTitleForAllStates("复制链接")
        btn.setTitleColorForAllStates(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
//        btn.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        
        btn.setButtonTitleImageStyle(padding: 10, style: TitleImageStyly.ButtonImageTitleStyleTop)
//        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        return btn
    }()
    
    ///分享视图
    lazy var drawerView: DrawerView = {
        let drawerView = DrawerView()
        drawerView.attachTo(view: self.view)
        drawerView.delegate = self
        drawerView.snapPositions = [.closed, DrawerPosition.open]
        drawerView.topMargin = self.view.height / 2
        drawerView.insetAdjustmentBehavior = .automatic
        drawerView.backgroundColor = .white
        return drawerView
    }()
    
    ///分享按钮父视图
    lazy var shareFatherView: UIView = {
        let view = UIView()
        view.frame = CGRect(origin: .zero, size: CGSize(width: 30, height: 32))
        return view
    }()
    ///分享按钮
    lazy var shareBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = shareFatherView.bounds
        btn.setImageForAllStates(#imageLiteral(resourceName: "new_share"))
        btn.addTarget(self, action: #selector(popShareView), for: UIControl.Event.touchUpInside)
        return btn
    }()
    ///主体webView
    lazy var wkWebView: WKWebView = {
        var config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: finalContentViewNoTabbarH), configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.white
//        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        return webView
    }()
    
    lazy var webProgressView: UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x: 0, y: 0, width: wkWebView.frame.width, height: 10))
        progress.progressViewStyle = UIProgressView.Style.bar
        return progress
    }()
    
    lazy var webAlphaView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: wkWebView.frame.width, height: wkWebView.frame.height))
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    lazy var activity: UIActivityIndicatorView = {[unowned self] in
        //webView加载提示
        let activity = UIActivityIndicatorView()
        activity.center = wkWebView.center
        activity.isHidden = true
        activity.style = .gray
        return activity
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //wkwebview全屏播放视频时会添加一个UIWindows，然后在这个UIWindows上添加播放器播放视频，此时状态栏会隐藏，需要监听这个UIWindows的出现和消失，在他消失的时候将状态栏复原
        NotificationCenter.default.addObserver(self, selector: #selector(beginFullScreen), name: UIWindow.didBecomeVisibleNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endFullScreen), name: UIWindow.didBecomeHiddenNotification, object: nil)
//        print("it's me!")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.wkWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.webProgressView.progress = Float(self.wkWebView.estimatedProgress)
//            if self.wkWebView.estimatedProgress == 0.5 {}
//            while self.wkWebView.estimatedProgress != 1.0{
//                wkJS()
//            }
            switch self.wkWebView.estimatedProgress{
            case 0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0:
                wkJS()
            default:
                break
            }
            if self.wkWebView.estimatedProgress == 1.0 {
                
                //预留出执行js语句的时间，js语句运行结束后延迟0.4s显示webview
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
//                                        self.wkWebView.isHidden = false
//                    self.activity.stopAnimating()
//                    self.webProgressView.removeFromSuperview()
//                    self.webAlphaView.removeFromSuperview()
//                })
            }
        }
    }

}

//MARK: - 设置UI
extension NewsDetailViewController{
    override func setUI() {
        super.setUI()
        self.navigationController?.navigationBar.isTranslucent = false
//        wkWebView.addSubview(activity)
//        wkWebView.addSubview(webAlphaView)
//        wkWebView.addSubview(webProgressView)
        //        self.view.addSubview(webView)
        self.title = "资讯详情"
        
        
        //设置分享按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareFatherView)
        shareFatherView.addSubview(shareBtn)
        self.view.addSubview(wkWebView)
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        //此处有显示图文详情的链接则直接使用，若没有提供链接，则使用注释的request来加载手机端商品详情页面，通过js隐藏不需要的元素来展示图文详情
        //let request = URLRequest(url: URL(string: BASE_URL + "site/products/id/\((self.goodsInfo?.goods_id) ?? 0)")!)
        let request = URLRequest(url: URL(string: self.newsDetailURL )!)
        self.wkWebView.load(request)
        //设置drawerview，并切换为关闭状态
        setDrawerView()
        drawerView.setPosition(DrawerPosition.closed, animated: false)
    }
    
    private func setDrawerView(){
        drawerView.addSubviews([wx_hhBtn,wx_pyqBtn,copyLinkBtn])
//        wx_hhBtn.snp.makeConstraints { (make) in
////            make.width.height.equalTo(40)
//            make.left.equalToSuperview().offset(20)
//            make.top.equalToSuperview().offset(15)
//        }
//        wx_pyqBtn.snp.makeConstraints { (make) in
////            make.width.height.equalTo(wx_hhBtn.snp.width)
//            make.left.equalTo(wx_hhBtn.snp.right).offset(finalScreenW / 7)
//            make.top.equalTo(wx_hhBtn.snp.top)
//        }
//        copyLinkBtn.snp.makeConstraints { (make) in
////            make.width.height.equalTo(wx_hhBtn.snp.width)
//            make.left.equalTo(wx_pyqBtn.snp.right).offset(finalScreenW / 7)
//            make.top.equalTo(wx_pyqBtn.snp.top)
//        }
    }
    
    override func initData() {
        super.initData()
    }
    
    
}

//MARK: - 点击事件
extension NewsDetailViewController {
    
    @objc func copyLink(){
        let paste = UIPasteboard.general
        paste.string = self.newsDetailURL
        YTools.showMyToast(rootView: self.view, message: "链接复制成功")
    }
    
    @objc func popShareView(){
//        print(drawerView.position)
//        if drawerView.position == .closed {
//            drawerView.setPosition(.open, animated: true)
//        }else {
//            drawerView.setPosition(.closed, animated: true)
//        }
        drawerView.setPosition(drawerView.position == .closed ? .open : .closed, animated: true)
    }
    
    ///wxsdk朋友圈分享
    @objc func WXpyqShare(){
//        let kfManager = KingfisherManager.shared
//        let downloader = kfManager.downloader
//        kfManager.defaultOptions = [.downloader(downloader), .forceRefresh, .backgroundDecode]
//        let resouce = ImageResource(downloadURL: URL(string: "\(self.sharePicURL )")!)
//        DispatchQueue.main.async {
//            let _ = kfManager.retrieveImage(with: resouce, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
//                if error == nil {
//                    //图片下载成功
//                    let imageShare = image!
//
//                    self.sendLinkURL(self.newsDetailURL, tagName: "tag", title: self.textShare, description: self.textShare, thumbImage: imageShare, in: WXSceneSession)
//
//                }else{
//                    print((error?.localizedFailureReason)!)
//                }
//            })
//        }
//        sendText(text: "WXShareTest", inScene: WXSceneTimeline)
        
        WXShareTools.WXShare(shareType: WXShareTools.WXShareType.朋友圈.rawValue, URL: self.newsDetailURL, shareTitle: self.textShare, shareDescription: "来自《爱武进》iOS客户端", sharePic: self.sharePicURL, shareTag: "tag")
    }
    
    /// 微信会话分享
    @objc func WXhhShare(){
        WXShareTools.WXShare(shareType: WXShareTools.WXShareType.会话.rawValue, URL: self.newsDetailURL, shareTitle: self.textShare, shareDescription: "来自《爱武进》iOS客户端", sharePic: self.sharePicURL, shareTag: "tag")
    }
    
//    + (void)sendLinkURL:(NSString *)urlString
//                TagName:(NSString *)tagName
//                  Title:(NSString *)title
//            Description:(NSString *)description
//             ThumbImage:(UIImage *)thumbImage
//                InScene:(enum WXScene)scene {
//        WXWebpageObject *ext = [WXWebpageObject object];
//        ext.webpageUrl = urlString;
//
//        WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
//                                                       Description:description
//                                                            Object:ext
//                                                        MessageExt:nil
//                                                     MessageAction:nil
//                                                        ThumbImage:thumbImage
//                                                          MediaTag:tagName];
//
//        SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                       OrMediaMessage:message
//                                                                bText:NO
//                                                              InScene:scene];
//        [WXApi sendReq:req completion:nil];
//    }
    
    /// 微信sdk分享链接
    /// - Parameters:
    ///   - urlString: 链接
    ///   - tagName: 分享标签
    ///   - title: 分享标题
    ///   - description: 分享描述
    ///   - thumbImage: 分享图片
    ///   - scene: 分享目标,会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
    func sendLinkURL(_ urlString: String, tagName: String, title: String, description: String, thumbImage: UIImage, in scene: WXScene){
        
        let ext = WXWebpageObject()
        ext.webpageUrl = urlString
        
        let message = WXMediaMessage()
        message.title = title
        message.description = description
        message.mediaObject = ext
        message.messageExt = nil
        message.messageAction = nil
        message.setThumbImage(thumbImage)
        message.mediaTagName = tagName
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.scene = Int32(scene.rawValue)
        req.message = message
        WXApi.send(req)
    }
    
//    + (void)sendText:(NSString *)text
//             InScene:(enum WXScene)scene {
//        SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:text
//                                                       OrMediaMessage:nil
//                                                                bText:YES
//                                                              InScene:scene];
//        [WXApi sendReq:req completion:nil];
//    }
    
    func sendText(text:String, inScene: WXScene){
        let req=SendMessageToWXReq()
        req.text=text
        req.bText=true
        req.scene=Int32(inScene.rawValue)
        WXApi.send(req)
    }
    
    //分享事件
    @objc func shareEvent(){
        let kfManager = KingfisherManager.shared
        let downloader = kfManager.downloader
        kfManager.defaultOptions = [.downloader(downloader), .forceRefresh, .backgroundDecode]
        let resouce = ImageResource(downloadURL: URL(string: "\(self.sharePicURL )")!)
        DispatchQueue.main.async {
            let _ = kfManager.retrieveImage(with: resouce, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if error == nil {
                    //图片下载成功
                    let textShare = self.textShare
                    let imageShare = image!
                    let urlShare = URL(string: "\(self.newsDetailURL)")
                    let activityItems = [textShare, imageShare, urlShare] as [Any]
                    let toVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                    self.navigationController?.present(toVC, animated: true, completion: nil)
                }else{
                    print((error?.localizedFailureReason)!)
                }
            })
        }
    }
}

//MARK: - 实现drawrview的代理协议
extension NewsDetailViewController:DrawerViewDelegate{
    
}

//MARK: - 实现webView的代理协议
extension NewsDetailViewController:WKUIDelegate,WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activity.isHidden = false
        self.activity.startAnimating()
        //开始加载时调用
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //即将完成加载
        //禁用长按功能
        self.wkWebView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: { (nullAble, errors) in
            //                        print(errors)
        })
        self.wkWebView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: { (nullAble, errors) in
            //                        print(errors)
        })
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //加载失败时调用
        self.activity.stopAnimating()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}
//MARK: - 点击事件
extension NewsDetailViewController{
    @objc private func beginFullScreen(){
//        print("进入全屏播放")
    }
    
    @objc private func endFullScreen(){
//        print("退出全屏播放")
//        self.prefersStatusBarHidden = false
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
    }
    
    private func wkJS(){
        wkWebView.evaluateJavaScript("document.getElementsByTagName('video')[0].setAttribute('playsinline','playsinline');") { (nullAble, errors) in
//            print("nullAble = \(nullAble)")
//            print("errors = \(errors )")
        }
    }
}
