//
//  AppConfigViewModel.swift
//  NextAiwujin
//  基础配置viewmodel
//  Created by DEV2018 on 2019/4/3.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
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
    
    
    /// 请求往期直播数据
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - finishCallBack: 回调函数
    class func requestZhiBoHistory(url:String, finishCallBack:@escaping (_ histories:[ZhiBoHistoryModel])->()){
        NetworkTool.requestData(type: .GET, urlString: url) { (result) in
            var models:[ZhiBoHistoryModel] = []
            let itemsJson = JSON(result).arrayValue
            for itemJson in itemsJson {
                models.append(ZhiBoHistoryModel(jsonData: itemJson))
            }
            finishCallBack(models)
        }
    }
    
    
    /// 请求评论数据
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - finishCallBack: 回调函数
    class func requestComments(url:String, finishCallBack:@escaping (_ comments: [CommentModel])->()){
        NetworkTool.requestData(type: .GET, urlString: url) { (result) in
            let itemsJson = JSON(result).arrayValue
//            print(itemsJson)
            var models:[CommentModel] = []
            for itemJson in itemsJson {
                models.append(CommentModel(jsonData: itemJson))
            }

            finishCallBack(models)
        }
//        AF.request(URL(string: url)!, method: HTTPMethod.get).responseJSON(queue: DispatchQueue.main) { (result) in
//            print(result.value)
//        }
        
//        AF.request(URL(string: url)!, method: HTTPMethod.get).responseString{ (result) in
//            guard let resultStr = result.value else {return}
//
//            let itemsJson = JSON(resultStr).arrayValue
//
//            print(itemsJson)
//            var models:[CommentModel] = []
//            for itemJson in itemsJson {
//                models.append(CommentModel(jsonData: itemJson))
//            }
//
//            finishCallBack(models)
//        }
    }
    
    
    /// 发表评论
    ///
    /// - Parameters:
    ///   - url: 发表评论接口
    ///   - content: 评论内容
    ///   - imageURL: 头像地址
    ///   - finishCallBack: 回调函数
    class func requestPostComments(url:String, content:String,imageURL:String, nickname:String,  finishCallBack:@escaping ()->()){
        AF.request(URL(string: url)!, method: HTTPMethod.post, parameters: ["content":"\(content)","headimg":"\(imageURL)","nickname":"\(nickname)"]).responseString { (result) in
            print(result)
            finishCallBack()
        }
    }
    
//    class func requestPostComments(url:String, content:String, imageURL:String, rid:Int, finishCallBack:@escaping ()->()){
//        AF.request(URL(string: url)!, method: HTTPMethod.post, parameters: ["content":"\(content)", "rid":"\(rid)", "headimgurl":"\(imageURL)"]).responseString { (result) in
//            finishCallBack()
//        }
//    }
}
