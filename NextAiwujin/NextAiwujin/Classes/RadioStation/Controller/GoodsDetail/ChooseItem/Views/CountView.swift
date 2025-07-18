//
//  CountView.swift
//  NextAiwujin
//  购物车加减控件
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SnapKit
class CountView: UIView {
    var label:UILabel!
    var reduceButton:UIButton!
    var countTextField:UITextField!
    var textFieldDownButton:UIButton!
    var addButton:UIButton! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel.init()
        label.text = "购买数量"
        label.font = UIFont.systemFont(ofSize: 14)
        addSubview(label)
        label.snp.makeConstraints { (mark) in
            mark.width.equalTo(kSize(width:100))
            mark.height.equalTo(kSize(width:30))
            mark.left.equalTo(kSize(width:15))
            mark.top.equalTo(kSize(width:10))
        }
        //加
        addButton = UIButton.init(type: UIButton.ButtonType.custom)
        addButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        addButton.setTitle("+", for: UIControl.State.normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addButton.backgroundColor = UIColor.white
        cutCorner(cornerRadius: 4, borderWidth: 1, borderColor: UIColor.lightGray, view: addButton)
        addSubview(addButton)
        addButton.snp.makeConstraints { (mark) in
            mark.width.equalTo(kSize(width:30))
            mark.height.equalTo(kSize(width:30))
            mark.right.equalTo(kSize(width:-15))
            mark.centerY.equalTo(self)
        }
        //输入框
        countTextField = UITextField.init()
        countTextField.font = UIFont.systemFont(ofSize: 15)
        countTextField.text = "1"
        countTextField.textAlignment = NSTextAlignment.center
        countTextField.keyboardType = UIKeyboardType.numberPad
        cutCorner(cornerRadius: 4, borderWidth: 1, borderColor: UIColor.lightGray, view: countTextField)
        addSubview(countTextField)
        countTextField.snp.makeConstraints { (mark) in
            mark.width.equalTo(kSize(width:60))
            mark.height.equalTo(kSize(width:30))
            mark.right.equalTo(addButton.snp.left).offset(kSize(width:-5))
            mark.centerY.equalTo(self)
        }
        //添加让键盘下去的按钮
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 40))
        view.backgroundColor = UIColor.white
        textFieldDownButton = UIButton.init(type: UIButton.ButtonType.custom)
        textFieldDownButton.setImage(UIImage.init(named: "jiantou_down"), for: UIControl.State.normal)
        textFieldDownButton.frame = CGRect(x: kWidth-50, y: 0, width: 50, height: 40)
        view.addSubview(textFieldDownButton)
        countTextField.inputAccessoryView = view
        
        //减
        reduceButton = UIButton.init(type: UIButton.ButtonType.custom)
        reduceButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        reduceButton.setTitle("-", for: UIControl.State.normal)
        reduceButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        reduceButton.backgroundColor = UIColor.white
        cutCorner(cornerRadius: 4, borderWidth: 1, borderColor: UIColor.lightGray, view: reduceButton)
        addSubview(reduceButton)
        reduceButton.snp.makeConstraints { (mark) in
            mark.width.equalTo(kSize(width:30))
            mark.height.equalTo(kSize(width:30))
            mark.right.equalTo(countTextField.snp.left).offset(kSize(width:-5))
            mark.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
