//
//  NewsViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
//定义局部变量、常量
private let titleLabelWidth:CGFloat = 50

class NewsViewController: BaseViewController {
    
    //MARK: - 懒加载
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: titleLabelWidth, height: finalNavigationBarH)))
        label.text = "天气:4℃/-1℃"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

}

extension NewsViewController{
    override func setUI() {
        super.setUI()
        //1.设置导航栏
        navigationItem.leftBarButtonItems = [UIBarButtonItem.init(imageName: "navigation_app_icon", size: CGSize(width: 40, height: 40)), UIBarButtonItem.init(customView: titleLabel)]
    }
}
