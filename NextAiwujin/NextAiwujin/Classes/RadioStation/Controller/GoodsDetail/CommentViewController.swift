//
//  CommentViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/18.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
private let bottomBarH:CGFloat = 60//底部购买view高度
private let topCellSpacing:CGFloat = 10
class CommentViewController: GoodDetailBaseViewController {
    var usableViewHeight:CGFloat?
    
    //MARK: - 懒加载
    
    lazy var noEvaluationLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW / 2 - 60, y: 85 + finalStatusBarH, width: 120, height: 60))
        label.text = "暂无评论"
        //        label.backgroundColor = .green
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var evaluationLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 40 + finalStatusBarH, width: finalScreenW, height: 1))
        view.backgroundColor = UIColor(named: "light_gray")!
        return view
    }()
    
    lazy var goodPercent: UILabel = {
        let label = UILabel(frame: CGRect(x: finalScreenW - 120 - topCellSpacing, y: finalStatusBarH, width: 120, height: 40))
        label.text = "好评度 100%"
        //        label.backgroundColor = .green
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .red
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    lazy var evaluationLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: topCellSpacing, y: finalStatusBarH, width: 120, height: 40))
        //        label.backgroundColor = .green
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "用户点评 (0)"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usableViewHeight = self.view.frame.height - finalStatusBarH - finalNavigationBarH - bottomBarH - (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0)
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//MARK: - 设置ui
extension CommentViewController {
    private func setUI(){
        self.view.addSubview(evaluationLine)
        self.view.addSubview(evaluationLabel)
        self.view.addSubview(noEvaluationLabel)
        self.view.addSubview(goodPercent)
    }
}
