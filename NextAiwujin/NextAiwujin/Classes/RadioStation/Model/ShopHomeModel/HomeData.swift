//
//  HomeData.swift
//  NextAiwujin
//  首页数据类
//  Created by DEV2018 on 2019/3/7.
//  Copyright © 2019 DEV2018. All rights reserved.
//

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
import Foundation
import SwiftyJSON

class HomeData {
    //BaseModel
    var hots:[HotInfo] = [HotInfo]()
    var recommends:[RecommendInfo] = [RecommendInfo]()
    var channels:[ChannelInfo] = [ChannelInfo]()
    var banners:[BannerInfo] = [BannerInfo]()
    init(jsonData:JSON) {
//        print(jsonData)
        for json in jsonData["hot_info"].arrayValue {
            hots.append(HotInfo(jsonData: json))
        }
        for json in jsonData["recommend_info"].arrayValue {
            recommends.append(RecommendInfo(jsonData: json))
        }
        for json in jsonData["channel_info"].arrayValue {
            channels.append(ChannelInfo(jsonData: json))
        }
        for json in jsonData["banner_info"].arrayValue {
            banners.append(BannerInfo(jsonData: json))
        }
    }
}


//@objc var banner_info:[[String:NSObject]]?
//    {
//    didSet{
//        guard let bannersLists = banner_info else { return }
//        for dict in bannersLists {
//            banners.append(BannerInfo(dict: dict))
//        }
//    }
//}
//@objc var channel_info:[[String:NSObject]]?
//    {
//    didSet{
//        guard let channelLists = channel_info else { return }
//        for dict in channelLists {
//            channels.append(ChannelInfo(dict: dict))
//        }
//    }
//}
//@objc var recommend_info:[[String:NSObject]]?
//    {
//    didSet{
//        guard let recommendLists = recommend_info else { return }
//        for dict in recommendLists {
//            recommends.append(RecommendInfo(dict: dict))
//        }
//    }
//}
//@objc var hot_info:[[String:NSObject]]?
//    {
//    didSet{
//        guard let hotLists = hot_info else { return }
//        for dict in hotLists {
//            hots.append(HotInfo(dict: dict))
//        }
//    }
//}
