//
//  ShopViewModel.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/7.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SwiftyJSON
class ShopViewModel {
    ///首页数据集合
    var homeDataGroup : HomeData?
}

//商城数据请求
extension ShopViewModel{
    //简易首页json数据
    //{
    //    "code":200,
    //    "result":{
    //        "banner_info":Array[2],
    //        "channel_info":Array[4],
    //        "recommend_info":Array[6],
    //        "hot_info":Array[8]
    //    },
    //    "time":1534904225
    //}
    
    ///请求首页数据
    /// - parameter finishCallback:回调接口
    func requestHomeData(finishCallback : @escaping () -> ()){
        NetworkTool.requestData(type: .GET, urlString: HOMEDATA_URL) { (result) in
            let jsonData = JSON(result)["result"]
            let code = JSON(result)["code"].intValue
//            print(result)
            //guard let resultDict = result as? [String : NSObject] else { return }
            //guard let resultCode = resultDict["code"] as? Int else { return }
            if code == 200 {
//                guard let homeDatas = resultDict["result"] as? [String:NSObject] else { return }
                //print(homeDatas.count)
                self.homeDataGroup = HomeData(jsonData: jsonData)
                finishCallback()
            }else if code == 201 {
                
            }
        }
    }
}
