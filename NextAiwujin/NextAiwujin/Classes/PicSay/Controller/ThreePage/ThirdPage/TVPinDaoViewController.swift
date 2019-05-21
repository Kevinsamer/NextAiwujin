//
//  TVPinDaoViewController.swift
//  NextAiwujin
//  电视频道播放vc
//  Created by DEV2018 on 2019/5/14.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import Kingfisher
class TVPinDaoViewController: BasePlayerViewController {
    var TVInfo:CH2TVModel = CH2TVModel(jsonData: "")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
//MARK: - 点击事件
extension TVPinDaoViewController{
    override func shareEvent() {
        let kfManager = KingfisherManager.shared
        let downloader = kfManager.downloader
        kfManager.defaultOptions = [.downloader(downloader), .forceRefresh, .backgroundDecode, .downloadPriority(1.0)]
        let resouce = ImageResource(downloadURL: URL(string: "\(TVInfo.channel_logo)")!)
        let _ = kfManager.retrieveImage(with: resouce, options: nil, progressBlock: nil) { (image, error, cacheType, imageUrl) in
            if error == nil {
                //success
                let textShare = self.TVInfo.channel_desc
                //        let contentShare = "分享的内容。"
                let imageShare:UIImage = image!
                let urlShare = URL(string: self.TVInfo.channel_url)
                let activityItems = [textShare,imageShare,urlShare] as [Any]
                let toVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                
                self.navigationController?.present(toVC, animated: true, completion: nil)
            }else{
                print("failed")
            }
        }
    }
}
