//
//  LoginViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/4/28.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
private let textFieldW : CGFloat = finalScreenW / 10 * 9
private let textFieldH : CGFloat = 40
private let viewSpace :CGFloat = 20
private let buttonW: CGFloat = (finalScreenW - 80) / 3
private var usernameString = ""
private var passwordString = ""
class LoginViewController: BaseViewController {
    private let myCenterViewModel:MycenterViewModel = MycenterViewModel()
    private var loginErrorInfo:String?{
        didSet{
            if loginErrorInfo != nil && AppDelegate.appUser?.id == -1{
                YTools.showMyToast(rootView: self.view, message: loginErrorInfo ?? "系统错误")
            }
        }
    }
    var userMember:UserMemberModel?{
        didSet{
            if let user = userMember {
                AppDelegate.appUser?.id = Int32(user.id)
                AppDelegate.appUser?.username = user.username
                AppDelegate.appUser?.password = user.password
                AppDelegate.appUser?.head_ico = user.head_ico
                AppDelegate.appUser?.user_id = Int32(user.user_id)
                AppDelegate.appUser?.true_name = user.true_name
                AppDelegate.appUser?.telephone = user.telephone
                AppDelegate.appUser?.mobile = user.mobile
                AppDelegate.appUser?.area = user.area
                AppDelegate.appUser?.contact_addr = user.contact_addr
                AppDelegate.appUser?.qq = user.qq
                AppDelegate.appUser?.sex = Int32(user.sex)
                AppDelegate.appUser?.birthday = user.birthday
                AppDelegate.appUser?.group_id = Int32(user.group_id)
                AppDelegate.appUser?.exp = Int32(user.exp)
                AppDelegate.appUser?.point = Int32(user.point)
                AppDelegate.appUser?.message_ids = user.message_ids
                AppDelegate.appUser?.time = user.time
                AppDelegate.appUser?.zip = user.zip
                AppDelegate.appUser?.status = Int32(user.status)
                AppDelegate.appUser?.prop = user.prop
                AppDelegate.appUser?.balance = user.balance
                AppDelegate.appUser?.last_login = user.last_login
                AppDelegate.appUser?.custom = user.custom
                AppDelegate.appUser?.email = user.email
                AppDelegate.appUser?.local_pd = user.local_pd
                AppUserCoreDataHelper.AppUserHelper.modifyAppUser(appUser: AppDelegate.appUser!)
//                if self.presentToShow{
//
//                }else{
//                    self.navigationController?.popViewController(animated: true)
//                }
                
                self.username.resignFirstResponder()
                self.password.resignFirstResponder()
                self.dismiss(animated: true, completion: {
                    if self.itemTag == 555{
                        YTools.showMyToast(rootView: (self.parentVC?.view)!, message: "登录成功")
                        //self.mainVC?.selectedIndex = 3
                        //跳转至首页我的
                        (self.parentVC as? UITabBarController)?.selectedIndex = tabIndex.我的.rawValue
                    }else if self.itemTag == 666{
                        //商品详情页跳转至购物车
                        YTools.showMyToast(rootView: (self.parentVC?.view)!, message: "登录成功")
                        let vc = NextShopCartViewController()
                        self.parentVC?.navigationController?.show(vc, sender: self.parentVC)
                        //self.navigationController?.show(vc, sender: self)
                    }else{
                        YTools.showMyToast(rootView: (self.parentVC?.view)!, message: "登录成功")
                    }
                })
                
            }
        }
    }
    ///是否present弹出的标志位
    var presentToShow:Bool = false
    ///需要跳转的item的tag,底部4个tabBarItem设置了tag，首页：111，购物车：222，分类：333，我的：444
    var itemTag:Int = 0
    ///MainViewController
    var parentVC:UIViewController?
    //MARK: - 懒加载
    lazy var username: MyTextField = {
        let name = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
//        name.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
//        name.layer.borderWidth = 1
        //name.textAlignment = NSTextAlignment.center
//        name.placeholder = "请输入用户名"
        name.font = UIFont.systemFont(ofSize: 20)
        name.delegate = self
//        name.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
//        name.layer.borderWidth = 0.5
        name.clearButtonMode = UITextField.ViewMode.always
        name.backgroundColor = UIColor.init(r: 255, g: 255, b: 255, alpha: 0.2)
        name.textColor =  .white
        name.placeholder(text: "请输入用户名", color: UIColor.init(r: 255, g: 255, b: 255, alpha: 0.5))
        return name
    }()
    
    lazy var password: MyTextField = {
        let password = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH + viewSpace + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
//        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
//        password.layer.borderWidth = 1
        //password.textAlignment = NSTextAlignment.center
//        password.placeholder = "请输入密码"
        password.font = UIFont.systemFont(ofSize: 20)
        password.delegate = self
        password.textType = .password
//        password.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
//        password.layer.borderWidth = 0.5
        password.backgroundColor = UIColor.init(r: 255, g: 255, b: 255, alpha: 0.2)
        password.clearButtonMode = UITextField.ViewMode.always
        password.textColor = .white
        password.placeholder(text: "请输入密码", color: UIColor.init(r: 255, g: 255, b: 255, alpha: 0.5))
        return password
    }()
//    lazy var dividerLineUsername: UIView = {
//        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH, width: textFieldW, height: 1))
//        view.backgroundColor = UIColor(named: "dark_gray")
//        return view
//    }()
//    lazy var dividerLinePassword: UIView = {
//        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 2 + viewSpace, width: textFieldW, height: 1))
//        view.backgroundColor = UIColor(named: "dark_gray")
//        return view
//    }()
    lazy var loginButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 2 + viewSpace * 2 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH)
        button.setTitleForAllStates("登录")
        button.titleLabel?.textAlignment = .center
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = UIColor.init(r: 36, g: 147, b: 115, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(loginButtonClicked), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: finalScreenW / 5, height: textFieldH)
//        button.backgroundColor = .orange
//        button.setTitleColorForAllStates(.white)
        button.setTitleForAllStates("注册")
        button.setTitleColorForAllStates(UIColor(named: "dark_gray")!)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.addTarget(self, action: #selector(registerClicked), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var forgetPasswordButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 + (textFieldW / 2 - finalScreenW / 5), y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: finalScreenW / 5, height: textFieldH)
//        button.backgroundColor = .orange
//        button.setTitleColorForAllStates(.white)
        button.setTitleForAllStates("忘记密码")
        button.setTitleColorForAllStates(UIColor(named: "dark_gray")!)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        button.addTarget(self, action: #selector(forgetPasswordClicked), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var signInWithLabel: UILabel = {
        //第三方账号登录promptLabel
        let label = UILabel(frame: CGRect(x: finalScreenW / 2 - finalScreenW / 3 / 2, y: 100 + textFieldH * 4 + viewSpace * 4 + finalStatusBarH + finalNavigationBarH, width: finalScreenW / 3, height: textFieldH))
        label.text = "第三方账号登录"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "dark_gray")
        label.backgroundColor = .white
        return label
    }()
    //分隔线
    lazy var dividerLine: UIView = {
        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 4 + viewSpace * 4 + 19.5 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: 1))
        view.backgroundColor = UIColor(named: "dark_gray")
        return view
    }()
    
    lazy var loginByQQ: UIButton = {
        let qq = UIButton(type: UIButton.ButtonType.custom)
        qq.frame = CGRect(x: 20, y: 100 + textFieldH * 5 + viewSpace * 5 + finalStatusBarH + finalNavigationBarH, width: buttonW, height: buttonW)
        //qq.setTitleForAllStates("QQ登录")
        qq.setImageForAllStates(UIImage(named: "ic_qq_70")!)
        qq.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        qq.addTarget(self, action: #selector(loginByQQClicked), for: UIControl.Event.touchUpInside)
        return qq
    }()
    lazy var loginByWX: UIButton = {
        let wx = UIButton(type: UIButton.ButtonType.custom)
        wx.frame = CGRect(x: 40 + buttonW, y: 100 + textFieldH * 5 + viewSpace * 5 + finalStatusBarH + finalNavigationBarH, width: buttonW, height: buttonW)
        //wx.setTitleForAllStates("微信登录")
        wx.setImageForAllStates(UIImage(named: "ic_wx_70")!)
        wx.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        wx.addTarget(self, action: #selector(loginByWXClicked), for: UIControl.Event.touchUpInside)
        return wx
    }()
    lazy var loginByWB: UIButton = {
        let wb = UIButton(type: UIButton.ButtonType.custom)
        wb.frame = CGRect(x: 60 + buttonW * 2, y: 100 + textFieldH * 5 + viewSpace * 5 + finalStatusBarH + finalNavigationBarH, width: buttonW, height: buttonW)
        //wb.setTitleForAllStates("微博登录")
        wb.setImageForAllStates(UIImage(named: "ic_sina_70")!)
        wb.setButtonTitleImageStyle(padding: 5, style: TitleImageStyly.ButtonImageTitleStyleTop)
        wb.addTarget(self, action: #selector(loginByWBClicked), for: UIControl.Event.touchUpInside)
        return wb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //1.setUI
//        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in self.view.subviews {
            view.resignFirstResponder()
            
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.backgroundColor = .clear
//        self.navBarTintColor = .clear
        
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
extension LoginViewController{
    override func setUI(){
        super.setUI()
        self.view.backgroundColor = .white
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .clear, size: .zero), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        navBarBarTintColor = .white
        //1.设置navigationBar tabBar
        if self.navigationController != nil{
//            if let tabbar = self.tabBarController{
//                YTools.setNavigationBarAndTabBar(navCT: navi, tabbarCT: tabbar, titleName: "登录", navItem:self.navigationItem)
//            }
//            navigationItem.title = "登录"
            let closeBtn = UIButton(type: UIButton.ButtonType.custom)
            closeBtn.frame = CGRect(x: 20, y:finalStatusBarH + 20, width: 30, height: 30)
            closeBtn.setImageForAllStates(#imageLiteral(resourceName: "login_close"))
            
            closeBtn.addTarget(self, action: #selector(closeSelf), for: UIControl.Event.touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: closeBtn)
        }else{
            if presentToShow{
                let imageV = UIImageView(frame: CGRect(x: finalScreenW / 2 - 40, y: finalStatusBarH + 20, width: 80, height: 80))
                imageV.image = UIImage(named: "topIcon")
                imageV.clipsToBounds = true
                imageV.layer.cornerRadius = 40
                imageV.contentMode = .scaleAspectFit
//                imageV.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                self.view.addSubview(imageV)
                
                let closeBtn = UIButton(type: UIButton.ButtonType.custom)
                closeBtn.frame = CGRect(x: 20, y:finalStatusBarH + 20, width: 30, height: 30)
                closeBtn.setImageForAllStates(#imageLiteral(resourceName: "hadUpvte"))
                closeBtn.addTarget(self, action: #selector(closeSelf), for: UIControl.Event.touchUpInside)
                self.view.addSubview(closeBtn)
            }
        }
        //TODO:设置present出来的界面
        
        //2.bodyContent
        setupBodyContent()
    }
    func setupBodyContent(){
        self.view.addSubview(username)
        self.view.addSubview(password)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        //暂时下线忘记密码，v2,0时再添加
        //self.view.addSubview(forgetPasswordButton)
        //暂时下线第三方登录，v2.0时再添加
//        self.view.addSubview(dividerLine)
//        self.view.addSubview(signInWithLabel)
//        self.view.addSubview(loginByQQ)
//        self.view.addSubview(loginByWX)
//        self.view.addSubview(loginByWB)
        
//        self.view.addSubview(dividerLinePassword)
//        self.view.addSubview(dividerLineUsername)
    }
    
}
//MARK: - UITextFieldDelegete
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username {
            print("username")
            username.resignFirstResponder()
            password.becomeFirstResponder()
        }else if textField == password {
            print("password")
            password.resignFirstResponder()
        }
        
        return true
    }
}
//MARK: - clickFunc
extension LoginViewController {
    @objc private func closeSelf(){
        self.username.resignFirstResponder()
        self.password.resignFirstResponder()
        self.dismiss(animated: true)
    }
    
    @objc func registerClicked(){
        print("register")
        let vc = RegistViewController()
        vc.sendData = self
//        self.present(vc, animated: true, completion: nil)
        //self.parentVC?.navigationController?.show(vc, sender: self)
        self.navigationController?.show(vc, sender: self)
    }
    
    @objc func forgetPasswordClicked(){
        print("changePassword")
        let vc = FindPasswordViewController()
//        self.navigationController?.show(vc, sender: self)
        self.navigationController?.show(vc, sender: self)
//        self.present(vc, animated: true, completion: nil)
    }
    @objc func loginButtonClicked(){
        //1.输入框验证
        if let usernameText = self.username.text {
            if let passwordText = self.password.text {
                let matcher = MyRegex(usernameRegex)
                if matcher.match(input: usernameText){
                    //匹配成功
                    if passwordText.count >= 6 && passwordText.count <= 32{
                        //密码正确
                        myCenterViewModel.requestLoginData(username: usernameText, password: passwordText) {
                            self.userMember = self.myCenterViewModel.userMember
                            self.loginErrorInfo = self.myCenterViewModel.errorInfo
                        }
                    }else {
                        YTools.showMyToast(rootView: self.view, message: "密码长度为6-32个字符")
                    }
                }else{
                    YTools.showMyToast(rootView: self.view, message: "用户名长度不能少于2个字符，可以为字母、数字、下划线、中文")
                }
            }else {
                YTools.showMyToast(rootView: self.view, message: "请填写密码")
            }
        }else {
            YTools.showMyToast(rootView: self.view, message: "请填写用户名/邮箱/手机号")
        }
        
    }
    @objc func loginByQQClicked(){
        //YTools.showMyToast(rootView: self.view, message: "QQ登录")
    }
    @objc func loginByWXClicked(){
        //YTools.showMyToast(rootView: self.view, message: "WX登录")
    }
    @objc func loginByWBClicked(){
        //YTools.showMyToast(rootView: self.view, message: "WB登录")
    }
    
}

extension LoginViewController:SendDataProtocol {
    func SendData(data: Any?) {
        if let username = data {
            self.username.text = username as? String
        }
    }
    
    
}
