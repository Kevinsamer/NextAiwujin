//
//  BaseBaoLiaoViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/11/26.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SnapKit
private let picW:CGFloat = (finalScreenW - 20 - 10)/3
private let picCellID:String = "picCellID"
class BaoLiaoViewController: BaseViewController {
    //MARK: - 懒加载
        //报料内容
        lazy var inputField: UITextView = {
            let field = UITextView()
            field.placeholder = "请输入报料内容"
            
            field.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            return field
        }()
        //添加图片按钮
        lazy var addPicBtn: UIButton = {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            btn.setImageForAllStates(#imageLiteral(resourceName: "baoliao_add_pic"))
            btn.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            return btn
        }()
        //展示图片collectionView
        lazy var picCollView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: picW, height: picW)
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 5
            //layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
            let coll = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: picCellID)
            coll.backgroundColor = .white
            coll.delegate = self
            coll.dataSource = self
            return coll
        }()
        //lbs图标
        lazy var lbsImageView: UIImageView = {
            let img = UIImageView(image: UIImage(named: "address_icon_desel"))
    //        img.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            img.contentMode = .scaleAspectFit
            return img
        }()
        
        //位置信息label
        lazy var lbsLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            return label
        }()

        override func viewDidLoad() {
            super.viewDidLoad()

            
        }

}
//MARK: - 设置UI
extension BaoLiaoViewController {
    override func setUI() {
        super.setUI()
        //0.设置导航栏
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navi_bg"), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = false
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(r: 127, g: 125, b: 201, alpha: 1), size: (self.navigationController?.navigationBar.frame.size)!), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)

//                navBarTintColor = .white
//                navBarTitleColor = .white
                
        //1.设置报料输入框
        setInputField()
        //2.设置选择图片控件
        setPicChooseView()
        //3.设置lbs图标
        setLBSImage()
        //4.设置lbslabel
        setLBSLabel()
    }
    
    private func setLBSLabel(){
        self.view.addSubview(lbsLabel)
        lbsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lbsImageView.snp.top)
            make.left.equalTo(lbsImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(lbsImageView.snp.bottom)
        }
    }
    
    private func setLBSImage(){
        self.view.addSubview(lbsImageView)
        lbsImageView.snp.makeConstraints { (make) in
            make.top.equalTo(picCollView.snp.bottom).offset(10)
            make.left.equalTo(picCollView.snp.left)
            make.width.height.equalTo(30)
        }
    }
    
    private func setInputField(){
        self.view.addSubview(inputField)
        inputField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
    }
    
    private func setPicChooseView(){
        self.view.addSubview(picCollView)
        picCollView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(finalScreenW - 20)
            make.height.equalTo(picW * 3 + 10)
        }
    }
 
}

//MARK: - 设置UICollectionView的代理和数据源协议
extension BaoLiaoViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picCellID, for: indexPath)
        cell.backgroundColor = .random
        if indexPath.row == 0 {
            cell.addSubview(addPicBtn)
            addPicBtn.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        return cell
    }
    
    
}

