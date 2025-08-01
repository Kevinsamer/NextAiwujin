//
//  RegisterViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/3.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import EFNavigationBar
private let textFieldW : CGFloat = finalScreenW / 10 * 9
private let textFieldH : CGFloat = 40
private let viewSpace :CGFloat = 20

class ChangePasswordViewController: BaseViewController {
    private var centerViewModel:MycenterViewModel = MycenterViewModel()
    //MARK: - 懒加载
    lazy var oldPassword: MyTextField = {
        let old = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        name.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        name.layer.borderWidth = 1
        //old.textAlignment = NSTextAlignment.center
        old.placeholder = "请输入旧密码"
        old.font = UIFont.systemFont(ofSize: 20)
        old.delegate = self
        old.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        old.layer.borderWidth = 0.5
        //old.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return old
    }()
    
    lazy var newPassword: MyTextField = {
        let new = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH + viewSpace + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //new.textAlignment = NSTextAlignment.center
        new.placeholder = "请输入新密码"
        new.font = UIFont.systemFont(ofSize: 20)
        new.delegate = self
        new.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        new.layer.borderWidth = 0.5
        //new.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return new
    }()
    lazy var newPasswordAgain: MyTextField = {
        let newAgain = MyTextField(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 2 + viewSpace * 2 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH))
        //        password.layer.borderColor = UIColor(named: "dark_gray")?.cgColor
        //        password.layer.borderWidth = 1
        //newAgain.textAlignment = NSTextAlignment.center
        newAgain.placeholder = "请再次输入新密码"
        newAgain.font = UIFont.systemFont(ofSize: 20)
        newAgain.delegate = self
        newAgain.layer.borderColor = UIColor.gray.lighten(by: 0.4).cgColor
        newAgain.layer.borderWidth = 0.5
        //newAgain.backgroundColor = UIColor.blue.lighten(by: 0.9)
        return newAgain
    }()
//    lazy var dividerLineOldPW: UIView = {
//        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH, width: textFieldW, height: 1))
//        view.backgroundColor = UIColor(named: "dark_gray")
//        return view
//    }()
//    lazy var dividerLineNewPassword: UIView = {
//        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 2 + viewSpace, width: textFieldW, height: 1))
//        view.backgroundColor = UIColor(named: "dark_gray")
//        return view
//    }()
//    lazy var dividerLineNewPasswordAgain: UIView = {
//        let view = UIView(frame: CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 3 + viewSpace * 2, width: textFieldW, height: 1))
//        view.backgroundColor = UIColor(named: "dark_gray")
//        return view
//    }()
    lazy var changeButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.frame = CGRect(x: finalScreenW / 2 - textFieldW / 2, y: 100 + textFieldH * 3 + viewSpace * 3 + finalStatusBarH + finalNavigationBarH, width: textFieldW, height: textFieldH)
        button.setTitleForAllStates("确认修改")
        button.titleLabel?.textAlignment = .center
        button.setTitleColorForAllStates(.white)
        button.backgroundColor = UIColor(named: "global_orange")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.addTarget(self, action: #selector(changeButtonClicked), for: UIControl.Event.touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        1.setUI
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)

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
extension ChangePasswordViewController{
    override func setUI(){
        super.setUI()
        self.view.backgroundColor = .white
        //1.设置navigationBar tabBar
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "修改密码", navItem:self.navigationItem)
        //2.bodyContent
        setupBodyContent()
        
    }
    func setupBodyContent(){
        self.view.addSubview(oldPassword)
        self.view.addSubview(newPassword)
        self.view.addSubview(newPasswordAgain)
        self.view.addSubview(changeButton)
//        self.view.addSubview(dividerLineOldPW)
//        self.view.addSubview(dividerLineNewPassword)
//        self.view.addSubview(dividerLineNewPasswordAgain)
    }
}

//MARK: - textFieldDelegete
extension ChangePasswordViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPassword {
            print("oldPW")
            oldPassword.resignFirstResponder()
            newPassword.becomeFirstResponder()
        }else if textField == newPassword {
            print("newPW")
            newPassword.resignFirstResponder()
            newPasswordAgain.becomeFirstResponder()
        }else if textField == newPasswordAgain {
            newPasswordAgain.resignFirstResponder()
        }
        
        return true
    }
}

//MARK: - clickFunc
extension ChangePasswordViewController {
    @objc func changeButtonClicked(){
        if !(oldPassword.text?.isEmpty)! && !(newPassword.text?.isEmpty)! && !(newPasswordAgain.text?.isEmpty)!{
            centerViewModel.requestPasswordEdit(fpassword: oldPassword.text!, password: newPassword.text!, repassword: newPasswordAgain.text!, finishaCallback: { (resultString) in
                AppDelegate.appUser?.local_pd = self.newPassword.text
                YTools.showMyToast(rootView: self.view, message: resultString)
            })
        }else{
            YTools.showMyToast(rootView: self.view, message: "请将原密码和新密码填写完整~")
        }
    }
}
