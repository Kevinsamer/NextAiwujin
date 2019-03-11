//
//  ShopViewModel.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/7.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

class ShopViewModel {
    ///首页数据集合
    var homeDataGroup : HomeData?
}

//商城数据请求
extension ShopViewModel{
    
    ///请求首页数据
    /// - parameter finishCallback:回调接口
    func requestHomeData(finishCallback : @escaping () -> ()){
        NetworkTool.requestData(type: .GET, urlString: HOMEDATA_URL) { (result) in
//            print(result)
            guard let resultDict = result as? [String : NSObject] else { return }
            guard let resultCode = resultDict["code"] as? Int else { return }
            if resultCode == 200 {
                guard let homeDatas = resultDict["result"] as? [String:NSObject] else { return }
                //print(homeDatas.count)
                self.homeDataGroup = HomeData(dict: homeDatas)
                finishCallback()
            }else if resultCode == 201 {
                
            }
        }
    }
}
