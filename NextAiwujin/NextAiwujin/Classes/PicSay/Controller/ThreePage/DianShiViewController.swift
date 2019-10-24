//
//  DianShiViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/4/15.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class DianShiViewController: ZhiBoBaseViewController {
    var banners:[UIImage] = [#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back"),#imageLiteral(resourceName: "individual_header_back")]
    //MARK: - 懒加载
    override var TVData: CH3Model{
        didSet{
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

extension DianShiViewController{
    override func setUI() {
        super.setUI()
//        self.view.addSubview(topBanner)
//        self.view.addSubview(topBannerControl)
        self.view.backgroundColor = .white
    }
    
    override func initData() {
        super.initData()
    }
}

//MARK: - tableView的代理
extension DianShiViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if TVData.program.count > 0{
                return TVData.program.count + 1
            }
            
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            if indexPath.row != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: dianshiCellID, for: indexPath) as! DianshiCell
                if TVData.program.count > 0{
                    cell.imageV.kf.setImage(with: URL(string: "\(TVData.program[indexPath.row-1].program_logo)"), placeholder: UIImage(named: "loading"))
                    cell.imageV.clipsToBounds = true
                    cell.imageV.layer.cornerRadius = 5
                    cell.nameLabel.text = "\(TVData.program[indexPath.row-1].program_name)\n"
                    cell.updateTimeLabel.text = "最后更新:\(YTools.dateToString(date: Date.init(timeIntervalSince1970: Double(TVData.program[indexPath.row-1].last_Update)!)))"
                }
                
                return cell
            }
            
        }
        
//        cell.removeSubviews()
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row != 0 {
                return 100
            }
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击跳转到相应的回看vc
        if indexPath.section == 1 {
            if indexPath.row != 0 {
//                print(indexPath.row - 1)
                let vc = TVHuiKanController()
                vc.tvLogo = TVData.program[indexPath.row - 1].program_logo
                vc.requestURL = TVData.program[indexPath.row - 1].indexFile
                vc.navigationItem.title = "\(TVData.program[indexPath.row - 1].program_name)"
                self.navigationController?.show(vc, sender: self)
            }
        }
    }
}
