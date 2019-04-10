//
//  NewsDetailViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/8.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import WebKit
class NewsDetailViewController: BaseViewController {
    
    var newsDetailURL:String? = ""
    
    //MARK: - 懒加载
    
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

extension NewsDetailViewController{
    override func setUI() {
        super.setUI()
//        wkWebView.addSubview(activity)
//        wkWebView.addSubview(webAlphaView)
//        wkWebView.addSubview(webProgressView)
        //        self.view.addSubview(webView)
        self.title = "资讯详情"
        self.view.addSubview(wkWebView)
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        //此处有显示图文详情的链接则直接使用，若没有提供链接，则使用注释的request来加载手机端商品详情页面，通过js隐藏不需要的元素来展示图文详情
        //let request = URLRequest(url: URL(string: BASE_URL + "site/products/id/\((self.goodsInfo?.goods_id) ?? 0)")!)
        let request = URLRequest(url: URL(string: newsDetailURL ?? "www.wjyanghu.com")!)
        self.wkWebView.load(request)
    }
    
    override func initData() {
        super.initData()
    }
    
    
}

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
