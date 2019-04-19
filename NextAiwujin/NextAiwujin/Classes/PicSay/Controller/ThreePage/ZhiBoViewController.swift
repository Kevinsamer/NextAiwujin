//
//  ZhiBoViewController.swift
//  NextAiwujin
//  直播vc
//  Created by DEV2018 on 2019/4/15.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class ZhiBoViewController: ZhiBoBaseViewController {
    
    override var ZhiBoData: CH2Model{
        didSet{
            secondCollView.reloadData()
            mainTable.reloadData{
                self.mainTable.switchRefreshHeader(to: .normal(.success, 0.5))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

extension ZhiBoViewController{
    override func setUI() {
        super.setUI()
        self.view.backgroundColor = .random
    }
    
    override func initData() {
        super.initData()
    }
}
//MARK: - collectionView代理
extension ZhiBoViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ZhiBoData.TV.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! SecondSectionCell
        cell.imageV.kf.setImage(with: URL.init(string: ZhiBoData.TV[indexPath.row].channel_logo), placeholder: UIImage.init(named: "loading"))
        cell.titleLabel.text = "\(ZhiBoData.TV[indexPath.row].channel_name)"
        return cell
    }
}
//MARK: - tableView的代理
extension ZhiBoViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2{
            if indexPath.row != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: zhiboCellID, for: indexPath) as! ZhiBoCell
                if ZhiBoData.TV.count > 0 {
//                    cell.guangboNameLabel.text = GuangBoData.Radio[0].program[indexPath.row - 1].program_name
//                    cell.startTimeLabel.text = GuangBoData.Radio[0].program[indexPath.row - 1].start_time
//                    cell.guangboImage.kf.setImage(with: URL(string: "\(GuangBoData.Radio[0].program[indexPath.row - 1].program_logo)"), placeholder: UIImage(named: "loading"))
                    cell.imageV.kf.setImage(with: URL(string: "\(ZhiBoData.TV[indexPath.row-1].channel_logo)"), placeholder: UIImage(named: "loading"))
                    cell.descLabel.text = "\(ZhiBoData.TV[indexPath.row-1].channel_desc)"
                    cell.titleLabel.text = "\(ZhiBoData.TV[indexPath.row-1].channel_name)"
                    cell.titleLabel.sizeToFit()
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if indexPath.row != 0 {
                return 80
            }
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            //该section第一个row用作header,所以需要+1
            if ZhiBoData.TV.count > 0{
                return ZhiBoData.TV.count + 1
            }
            
        }
        
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
}
