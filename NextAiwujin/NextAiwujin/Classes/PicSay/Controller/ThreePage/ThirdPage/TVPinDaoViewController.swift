//
//  TVPinDaoViewController.swift
//  NextAiwujin
//  电视频道播放vc
//  Created by DEV2018 on 2019/5/14.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import Kingfisher
import GrowingTextView
class TVPinDaoViewController: BasePlayerViewController {
    var TVInfo:CH2TVModel = CH2TVModel(jsonData: "")
//    private var inputToolbar: UIView!
//    private var textView: GrowingTextView!
//    private var textViewBottomConstraint: NSLayoutConstraint!
    
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
    
//    ///评论fatherView
//    lazy var commentFatherView: UIView = {
//        let view = UIView()
//        //        view.backgroundColor = .random
//        return view
//    }()
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

//MARK: - 设置UI
extension TVPinDaoViewController {
    override func setUI() {
        super.setUI()
        setTitleView()
//        setCommentView()
    }
    
    override func initData() {
        super.initData()
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
    
//    ///设置评论view
//    private func setCommentView(){
//        self.view.addSubview(commentFatherView)
//        commentFatherView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(titleView.snp.bottom)
//            make.bottom.equalToSuperview().offset(UIDevice.current.isX() ? -IphonexHomeIndicatorH : 0)
//        }
//        
//        // *** Create Toolbar
//        inputToolbar = UIView()
//        inputToolbar.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
//        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
//        commentFatherView.addSubview(inputToolbar)
//        
//        // *** Create GrowingTextView ***
//        textView = GrowingTextView()
//        textView.delegate = self
//        textView.layer.cornerRadius = 4.0
//        textView.maxLength = 200
//        textView.maxHeight = 70
//        textView.trimWhiteSpaceWhenEndEditing = true
//        textView.attributedPlaceholder = NSAttributedString(string: "发表评论", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.8, alpha: 1.0)])
////        textView.placeholderColor = UIColor(white: 0.8, alpha: 1.0)
//        textView.font = UIFont.systemFont(ofSize: 15)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        
//        inputToolbar.addSubview(textView)
//        textView.returnKeyType = .send
//        ///设置输入框作为第一响应者时，如果无内容则返回键无法点击
//        textView.enablesReturnKeyAutomatically = true
//        // *** Autolayout ***
//        let topConstraint = textView.topAnchor.constraint(equalTo: inputToolbar.topAnchor, constant: 8)
//        topConstraint.priority = UILayoutPriority(999)
//        NSLayoutConstraint.activate([
//            inputToolbar.leadingAnchor.constraint(equalTo: commentFatherView.leadingAnchor),
//            inputToolbar.trailingAnchor.constraint(equalTo: commentFatherView.trailingAnchor),
//            inputToolbar.bottomAnchor.constraint(equalTo: commentFatherView.bottomAnchor),
//            topConstraint
//            ])
//        
//        if #available(iOS 11, *) {
//            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.bottomAnchor, constant: -8)
//            NSLayoutConstraint.activate([
//                textView.leadingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.leadingAnchor, constant: 8),
//                textView.trailingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//                textViewBottomConstraint
//                ])
//        } else {
//            textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.bottomAnchor, constant: -8)
//            NSLayoutConstraint.activate([
//                textView.leadingAnchor.constraint(equalTo: inputToolbar.leadingAnchor, constant: 8),
//                textView.trailingAnchor.constraint(equalTo: inputToolbar.trailingAnchor, constant: -8),
//                textViewBottomConstraint
//                ])
//        }
//        
//        // *** Listen to keyboard show / hide ***
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        
//        // *** Hide keyboard when tapping outside ***
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
//        commentFatherView.addGestureRecognizer(tapGesture)
//        
//        let vc = RedditCommentsViewController()
//        self.addChild(vc)
//        self.commentFatherView.addSubview(vc.view)
//        vc.view.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.bottom.equalTo(inputToolbar.snp.top)
//        }
//        
//    }
}

//MARK: - 点击事件
extension TVPinDaoViewController{
//    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
//        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
//            if #available(iOS 11, *) {
//                if keyboardHeight > 0 {
//                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
//                }
//            }
//            textViewBottomConstraint.constant = -keyboardHeight - 8
//            commentFatherView.layoutIfNeeded()
//        }
//    }
//    
//    @objc private func tapGestureHandler() {
//        commentFatherView.endEditing(true)
//    }
    
    override func shareEvent() {
        let kfManager = KingfisherManager.shared
        let downloader = kfManager.downloader
        kfManager.defaultOptions = [.downloader(downloader), .forceRefresh, .backgroundDecode]
        let resouce = ImageResource(downloadURL: URL(string: "\(TVInfo.channel_logo)")!)
        DispatchQueue.main.async {
            let _ = kfManager.retrieveImage(with: resouce, options: nil, progressBlock: nil) { (image, error, cacheType, imageUrl) in
                if error == nil {
                    //success
                    let textShare = self.TVInfo.channel_desc
                    //        let contentShare = "分享的内容。"
                    let imageShare:UIImage = image!
//                    print(imageShare.bytesSize)
                    let urlShare = URL(string: self.TVInfo.channel_url)
                    let activityItems = [textShare,imageShare,urlShare!] as [Any]
                    let toVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                    
                    self.navigationController?.present(toVC, animated: true, completion: nil)
                }else{
                    print((error?.localizedFailureReason)!)
                }
            }
        }
        
    }
}

//extension TVPinDaoViewController: GrowingTextViewDelegate {
//    
//    // *** Call layoutIfNeeded on superview for animation when changing height ***
//    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if textView.isMember(of: GrowingTextView.self) {
//            if text == "\n" {
//                textView.text = ""
//                textView.resignFirstResponder()
//                return false
//            }
//        }
//        
//        return true
//    }
//    
//    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
//        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
//}
