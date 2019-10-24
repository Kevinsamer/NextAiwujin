//
//  RegistViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/4.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Toast_Swift
import Kingfisher
import WebKit
private let textFieldW : CGFloat = finalScreenW / 10 * 9
private let textFieldH : CGFloat = 40
private let viewSpace :CGFloat = 20

class RegistViewController: BaseViewController {
    var sendData:SendDataProtocol?
    private let myCenterViewModel:MycenterViewModel = MycenterViewModel()
    private var registerData:UserMemberModel?{
        didSet{
            if let reg = registerData {
                //非空判断
                if let send = sendData {
                    //将注册用户名传递至登录页
                    send.SendData(data: reg.username)
                    self.navigationController?.popViewController()
                }
                
            }
        }
    }
    private var regErrorInfo:String?{
        didSet{
            if let error = regErrorInfo {
                YTools.showMyToast(rootView: self.view, message: error)
            }
            
        }
    }
//    private var usernameHasText:Bool = false
//    private var passwordHasText:Bool = false
//    private var repasswordHasText:Bool = false
//    private var captchaHasText:Bool = false
    
    //MARK: - 懒加载
    lazy var regUsername: MyTextField = {
        let old = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        name.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        name.layer.borderWidth = 1
        //old.textAlignment = NSTextAlignment.center
        old.placeholder(text: "请输入用户名", color: UIColor.init(r: 255, g: 255, b: 255, alpha: 0.5))
        old.font = UIFont.systemFont(ofSize: 20)
        old.delegate = self
//        old.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
//        old.layer.borderWidth = 0.5
        old.clearButtonMode = UITextField.ViewMode.always
        old.backgroundColor = UIColor.init(r: 255, g: 255, b: 255, alpha: 0.2)
        old.textColor =  .white
//        old.placeholder(text: "请输入用户名", color: UIColor.init(r: 255, g: 255, b: 255, alpha: 0.5))
//        old.addTarget(self, action: #selector(nameChanged(textField:)), for: UIControlEvents.editingChanged)
        return old
    }()
    
    lazy var regPassword: MyTextField = {
        let new = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH + viewSpace + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //new.textAlignment = NSTextAlignment.center
        
        new.font = UIFont.systemFont(ofSize: 20)
        new.delegate = self
        new.textType = UITextField.TextType.password
//        new.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
//        new.layer.borderWidth = 0.5
        new.clearButtonMode = UITextField.ViewMode.always
        new.backgroundColor = UIColor.init(r: 255, g: 255, b: 255, alpha: 0.2)
        new.textColor =  .white
        new.placeholder(text: "请输入密码", color: UIColor.init(r: 255, g: 255, b: 255, alpha: 0.5))
        //new.backgroundColor = UIColor.blue.lighten(by: 0.9)
//        new.addTarget(self, action: #selector(passwordChanged(textField:)), for: UIControlEvents.editingChanged)
        return new
    }()
    lazy var regPasswordAgain: MyTextField = {
        let newAgain = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 2 + viewSpace * 2 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //newAgain.textAlignment = NSTextAlignment.center
        
        newAgain.font = UIFont.systemFont(ofSize: 20)
        newAgain.delegate = self
        newAgain.textType = UITextField.TextType.password
//        newAgain.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
//        newAgain.layer.borderWidth = 0.5
        newAgain.clearButtonMode = UITextField.ViewMode.always
        newAgain.backgroundColor = UIColor.init(r: 255, g: 255, b: 255, alpha: 0.2)
        newAgain.textColor =  .white
        newAgain.placeholder(text: "请再次输入密码", color: UIColor.init(r: 255, g: 255, b: 255, alpha: 0.5))
//        newAgain.addTarget(self, action: #selector(repasswordChanged(textField:)), for: UIControlEvents.editingChanged)
        //newAgain.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return newAgain
    }()
    lazy var authCodeInput: MyTextField = {
        let authCode = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: textFieldW * 3 / 5, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //authCode.textAlignment = NSTextAlignment.center
        authCode.placeholder(text: "请输入验证码", color: UIColor.init(r: 255, g: 255, b: 255, alpha: 0.5))
        authCode.font = UIFont.systemFont(ofSize: 20)
        authCode.delegate = self
//        authCode.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
//        authCode.layer.borderWidth = 0.5
        authCode.clearButtonMode = UITextField.ViewMode.always
        authCode.backgroundColor = UIColor.init(r: 255, g: 255, b: 255, alpha: 0.2)
        authCode.textColor =  .white
        //authCode.backgroundColor = UIColor.blue.lighten(by: 0.9)
//        authCode.addTarget(self, action: #selector(captchaChanged(textField:)), for: UIControlEvents.editingChanged)
        return authCode
    }()
    
//  二维码控件
//    lazy var authCodePic: AuthCodeView = {
//        let viewFrame = CGRect(x: finalScreenW / 2 + textFieldW / 10 + viewSpace, y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: textFieldW * 2 / 5 - viewSpace, height: textFieldH)
//        let auth = AuthCodeView(frame: viewFrame, with: IdentifyingCodeType.defaultType)
//        auth.kCharCount = 5
//        auth.kLineCount = 9
//        auth.isRotation = true
//        return auth
//    }()
    
//    //UIImageView直接显示图片二维码
    lazy var authCodePic: UIImageView = {
        let viewFrame = CGRect(x: finalScreenW / 2 + textFieldW / 10 + viewSpace, y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: textFieldW * 2 / 5 - viewSpace, height: textFieldH)
        let auth = UIImageView(frame: viewFrame)
        ImageCache.default.clearDiskCache()
        ImageCache.default.clearMemoryCache()
        self.myCenterViewModel.requestCaptchaData(finishCallback: { (response) in
            auth.image = UIImage(data: response!)
        })
        //auth.kf.setImage(with: URL.init(string: AUTHCODE_URL), placeholder: UIImage.init(named: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
        auth.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeAuthCode))
        auth.addGestureRecognizer(tap)
        return auth
    }()
    
    //wkwebview直接显示图片二维码
//    lazy var authCodePic: WKWebView = {
//        let viewFrame = CGRect(x: finalScreenW / 2 + textFieldW / 10 + viewSpace, y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: textFieldW * 2 / 5 - viewSpace, height: textFieldH)
//        let configuration = WKWebViewConfiguration()
//
//        let auth = WKWebView(frame: viewFrame, configuration: configuration)
//        auth.uiDelegate = self
//        auth.navigationDelegate = self
//        auth.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        auth.load(URLRequest.init(url: URL.init(string: AUTHCODE_URL)!))
////        ImageCache.default.clearDiskCache()
////        ImageCache.default.clearMemoryCache()
////
////        auth.kf.setImage(with: URL.init(string: AUTHCODE_URL), placeholder: UIImage.init(named: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
////        auth.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(changeAuthCode))
//        auth.addGestureRecognizer(tap)
//        return auth
//    }()
    
    
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 4 + viewSpace * 4 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH)
        button.setTitleForAllStates("立即注册")
        button.titleLabel?.textAlignment = .center
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = UIColor.init(r: 36, g: 147, b: 115, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(registerButtonClicked), for: UIControl.Event.touchUpInside)
        button.isEnabled = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //1.setUI
//        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bgImg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: finalScreenH))
        bgImg.image = #imageLiteral(resourceName: "music_background")
        self.view.addSubview(bgImg)
        self.view.sendSubviewToBack(bgImg)
        //        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "music_background"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(r: 15, g: 15, b: 15, alpha: 1), size: (self.navigationController?.navigationBar.frame.size)!), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        
        self.navigationController?.navigationBar.setColors(background: .yellow, text: .white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews {
            view.resignFirstResponder()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - setUI
extension RegistViewController{
    override func setUI(){
        super.setUI()
        self.view.backgroundColor = .white
//        print(self.navigationController)
//        print(self.tabBarController)
        //1.设置navigationBar tabBar
//        if let navi = self.navigationController{
//            if let tab = self.tabBarController{
//                YTools.setNavigationBarAndTabBar(navCT: navi, tabbarCT: tab, titleName: "用户注册", navItem:self.navigationItem)
//            }
//        }
        navigationItem.title = "用户注册"
        //2.bodyContent
        setupBodyContent()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(notification:)), name: UITextField.textDidChangeNotification, object: regUsername)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(notification:)), name: UITextField.textDidChangeNotification, object: regPassword)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(notification:)), name: UITextField.textDidChangeNotification, object: regPasswordAgain)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(notification:)), name: UITextField.textDidChangeNotification, object: authCodeInput)
    }
    func setupBodyContent(){
        self.view.addSubview(regUsername)
        self.view.addSubview(regPassword)
        self.view.addSubview(regPasswordAgain)
        self.view.addSubview(authCodeInput)
        self.view.addSubview(authCodePic)
        self.view.addSubview(registerButton)
        
    }
}

//MARK: - textFieldDelegete
extension RegistViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == regUsername {
//            print("username")
            regUsername.resignFirstResponder()
            regPassword.becomeFirstResponder()
        }else if textField == regPassword {
//            print("password")
            regPassword.resignFirstResponder()
            regPasswordAgain.becomeFirstResponder()
        }else if textField == regPasswordAgain {
//            print("passwordAgain")
            regPasswordAgain.resignFirstResponder()
            authCodeInput.becomeFirstResponder()
        }else if textField == authCodeInput {
//            print("authCode")
            authCodeInput.resignFirstResponder()
        }
        
        return true
    }
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if regUsername.hasText && regPassword.hasText && regPasswordAgain.hasText && authCodeInput.hasText{
//            registerButton.backgroundColor = UIColor(named: "global_orange")
//            textField.returnKeyType = UIReturnKeyType.go
//        }else {
//            registerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            textField.returnKeyType = .done
//        }
//    }
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print(usernameHasText)
//        print(passwordHasText)
//        print(repasswordHasText)
//        print(captchaHasText)
//
//
//        return true
//    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print(usernameHasText)
//        print(passwordHasText)
//        print(repasswordHasText)
//        print(captchaHasText)
//        return true
//    }
    
}

//MARK: - clickFunc
extension RegistViewController {
    @objc func registerButtonClicked(){
        print(authCodeInput.text!)
        myCenterViewModel.requestResisterData(username: regUsername.text!, password: regPassword.text!, repassword: regPasswordAgain.text!, captcha: authCodeInput.text!) {
            self.regErrorInfo = self.myCenterViewModel.errorInfo
            self.registerData = self.myCenterViewModel.userMember
        }
    }
    
    @objc func changeAuthCode(){
//        ImageCache.default.clearDiskCache()
//        ImageCache.default.clearMemoryCache()
//        authCodePic.kf.setImage(with: URL.init(string: AUTHCODE_URL), placeholder: UIImage.init(named: "loading"), options: nil, progressBlock: nil, completionHandler: nil)
//        authCodePic.reload()
        self.myCenterViewModel.requestCaptchaData(finishCallback: { (response) in
            self.authCodePic.image = UIImage(data: response!)
        })
    }
    
//    @objc func nameChanged(textField:UITextField){
//        usernameHasText = textField.hasText
//    }
//
//    @objc func passwordChanged(textField:UITextField){
//        passwordHasText = textField.hasText
//    }
//
//    @objc func repasswordChanged(textField:UITextField){
//        repasswordHasText = textField.hasText
//    }
//
//    @objc func captchaChanged(textField:UITextField){
//        captchaHasText = textField.hasText
//    }
    //监听输入框文本改变的通知
    @objc func textChanged(notification:Notification){
        
        let textField = notification.object as! UITextField
        if regUsername.hasText && regPassword.hasText && regPasswordAgain.hasText && authCodeInput.hasText{
            registerButton.backgroundColor = UIColor.init(r: 36, g: 147, b: 115, alpha: 1)
            textField.returnKeyType = UIReturnKeyType.go
            registerButton.isEnabled = true
        }else {
            registerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            textField.returnKeyType = .next
            registerButton.isEnabled = false
        }
    }
}

extension RegistViewController:WKUIDelegate,WKNavigationDelegate{
    
}
