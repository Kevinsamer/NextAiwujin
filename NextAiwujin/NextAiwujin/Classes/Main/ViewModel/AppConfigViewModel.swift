//
//  AppConfigViewModel.swift
//  NextAiwujin
//  基础配置viewmodel
//  Created by DEV2018 on 2019/4/3.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class AppConfigViewModel{
    var appConfig:AppConfigModel?
}

extension AppConfigViewModel{
    
    /// 请求新闻类所有数据
    ///
    /// - Parameter finishCallBack: 回调函数
    class func requestAppConfig(finishCallBack:@escaping (_ appCon:AppConfigModel)->()){
        NetworkTool.requestData(type: MethodType.GET, urlString: API_ConfigFile) { (result) in
            let jsonResult = JSON(result)
            let appConfigResult = AppConfigModel(jsonData: jsonResult)
            finishCallBack(appConfigResult)
        }
    }
    
    
    /// 请求新闻资讯数据
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - finishCallBack: 回调函数
    class func requestCH1Items(url:String, finishCallBack:@escaping (_ news:[CH1MenuItemModel])->()) {
        NetworkTool.requestData(type: .GET, urlString: url) { (result) in
            var items:[CH1MenuItemModel] = []
            let itemsJson = JSON(result)["item"].arrayValue
            for itemJson in itemsJson{
                items.append(CH1MenuItemModel(jsonData: itemJson))
            }
            finishCallBack(items)
        }
    }
    
    
    /// 请求往期栏目视频数据
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - finishCallBack: 回调函数
    class func requestTVHuiKan(url:String, finishCallBack:@escaping (_ videos:[CH3ProgramVideoModel])->()){
        NetworkTool.requestData(type: .GET, urlString: url) { (result) in
            var videos:[CH3ProgramVideoModel] = []
            let itemsJson = JSON(result)["item"].arrayValue
            for itemJson in itemsJson {
                videos.append(CH3ProgramVideoModel(jsonData: itemJson))
            }
            finishCallBack(videos)
        }
    }
}
