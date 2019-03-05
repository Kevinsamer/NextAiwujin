//
//  UIBarButtonItem-extension.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    convenience init(imageName:String, highLightedImageName:String = "", size:CGSize = CGSize.zero, clickAbled:Bool){
        let btn = UIButton(type: UIButton.ButtonType.custom)
//        btn.sizeToFit()
//        btn.contentMode = .scaleAspectFit
        if size == CGSize.zero {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: .zero, size: size)
            btn.imageView?.contentMode = .scaleAspectFit

        }
        
        //btn.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        if highLightedImageName != ""{
            btn.setImage(UIImage.init(named: highLightedImageName), for: .highlighted)
        }
        //在导航栏中添加UIButton时，如果需要改变UIButton的size，需要在UIButton外再添加一层UIView(frame=UIButton.frame)，
        let alphaView = UIView(frame: btn.frame)
        
        alphaView.addSubview(btn)
        btn.isUserInteractionEnabled = clickAbled
        self.init(customView: alphaView)
    }
}
