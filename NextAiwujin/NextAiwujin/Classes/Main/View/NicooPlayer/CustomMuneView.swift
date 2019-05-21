//
//  CustomMuneView.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/5/20.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class CustomMuneView: UIView {

    var itemClick:(() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func loadUI() {
        let sideView = UIView()
        addSubview(sideView)
        sideView.backgroundColor = UIColor(white: 1, alpha: 1)
        sideView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(190)
        }
        
        
        let button = UIButton(type: .custom)
        button.setTitle("分享", for: .normal)
        button.setImage(UIImage(named: "share_white"), for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
//        button.tag = index + 33
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.titleEdgeInsets.left = 20
        button.addTarget(self, action: #selector(muneButtonClick(_:)), for: .touchUpInside)
        sideView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-20)
            make.top.equalTo(20)
            make.height.equalTo(40)
        }
        
    }
    
    @objc func muneButtonClick(_ sender: UIButton) {
        print("sender.title = \(String(describing: sender.titleLabel?.text))")
        itemClick?()
    }

}
