//
//  AppConfigModel.swift
//  NextAiwujin
//  基础配置信息
//  Created by DEV2018 on 2019/4/3.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class AppConfigModel {
    var Root:String = ""
    var platform:PlatformModel = PlatformModel(jsonData: JSON())
    ///首页推荐数据
    var CH0:CH0Model = CH0Model(jsonData: JSON())
    ///新闻资讯
    var CH1:CH1Model = CH1Model(jsonData: JSON())
    ///电视直播
    var CH2:CH2Model = CH2Model(jsonData: JSON())
    ///视频点播、电视回看
    var CH3:CH3Model = CH3Model(jsonData: JSON())
    ///广播
    var CH4:CH4Model = CH4Model(jsonData: JSON())
    ///论坛
    var CH5:CH5Model = CH5Model(jsonData: JSON())
    ///购物
    var CH6:CH6Model = CH6Model(jsonData: JSON())
    
    init(jsonData: JSON){
        Root = jsonData["Root"].stringValue
        platform = PlatformModel(jsonData: jsonData["platform"])
        CH0 = CH0Model(jsonData: jsonData["CH0"])
        CH1 = CH1Model(jsonData: jsonData["CH1"])
        CH2 = CH2Model(jsonData: jsonData["CH2"])
        CH3 = CH3Model(jsonData: jsonData["CH3"])
        CH4 = CH4Model(jsonData: jsonData["CH4"])
        CH5 = CH5Model(jsonData: jsonData["CH5"])
        CH6 = CH6Model(jsonData: jsonData["CH6"])
    }
}
//MARK: - CH0开始
class CH0Model {
    var Title:String = ""
    var Host:String = ""
    var Folder:String = ""
    var Channel:[CH0ChannelModel] = []
    
    init(jsonData:JSON) {
        Title = jsonData["Title"].stringValue
        Host = jsonData["Host"].stringValue
        Folder = jsonData["Folder"].stringValue
        for json in jsonData["Channel"].arrayValue{
            Channel.append(CH0ChannelModel(jsonData: json))
        }
    }
}

class CH0ChannelModel{
    var CH_Title:String = ""
    var Item:[CH0ChannelItemModel] = []
    
    init(jsonData:JSON) {
        CH_Title = jsonData["CH_Title"].stringValue
        for json in jsonData["Item"].arrayValue{
            Item.append(CH0ChannelItemModel(jsonData: json))
        }
    }
}

class CH0ChannelItemModel{
    var title:String = ""
    var titleurl:String = ""
    var titlepic:String = ""
    var isVidel:String = ""
    
    init(jsonData:JSON) {
        title = jsonData["title"].stringValue
        titleurl = jsonData["titleurl"].stringValue
        titlepic = jsonData["titlepic"].stringValue
        isVidel = jsonData["isVidel"].stringValue
    }
}
//MARK: - CH0结束
//MARK: - CH1开始
///新闻资讯类
class CH1Model {
    var Title:String = ""
    var Host:String = ""
    var Folder:String = ""
    var menu:[CH1MenuModel] = []
    init(jsonData:JSON) {
        Title = jsonData["Title"].stringValue
        Host = jsonData["Host"].stringValue
        Folder = jsonData["Folder"].stringValue
        for json in jsonData["Menu"].arrayValue{
            menu.append(CH1MenuModel(jsonData: json))
        }
    }
    
}

class CH1MenuModel{
    var classid:String = ""
    var Title:String = ""
    ///新闻内容接口地址
    var File:String = ""
    var DefaultImage:String = ""
    
    init(jsonData:JSON) {
        classid = jsonData["classid"].stringValue
        Title = jsonData["Title"].stringValue
        File = jsonData["File"].stringValue
        DefaultImage = jsonData["DefaultImage"].stringValue
    }
}

///单条新闻model
class CH1MenuItemModel{
    var classid:String = ""
    var id:String = ""
    var title:String = ""
    var ftitle:String = ""
    var titleurl:String = ""
    var titlepic:String = ""
    var isVideo:String = ""
    
    init(jsonData:JSON) {
        classid = jsonData["classid"].stringValue
        id = jsonData["id"].stringValue
        title = jsonData["title"].stringValue
        ftitle = jsonData["ftitle"].stringValue
        titleurl = jsonData["titleurl"].stringValue
        titlepic = jsonData["titlepic"].stringValue
        isVideo = jsonData["isVideo"].stringValue
    }
}
//MARK: - CH1结束
//MARK: - CH2开始
///直播数据model
class CH2Model{
    var Title:String = ""
    var Host:String = ""
    var Folder:String = ""
    var TV:[CH2TVModel] = []
    
    init(jsonData:JSON) {
        Title = jsonData["Title"].stringValue
        Host = jsonData["Host"].stringValue
        Folder = jsonData["Folder"].stringValue
        for tvJson in jsonData["TV"].arrayValue {
            TV.append(CH2TVModel(jsonData: tvJson))
        }
    }
}

class CH2TVModel{
    var channel_id:String = ""
    var channel_name:String = ""
    var channel_logo:String = ""
    var channel_url:String = ""
    var channel_picture:String = ""
    var channel_stream:String = ""
    var channel_stream_android:String = ""
    var channel_stream_ios:String = ""
    var audio_only:String = ""
    var is_live:String = ""
    var channel_desc:String = ""
    var channel_on:String = ""
    var program:[CH2TVProgramModel]? = []
    var programJSON:JSON = JSON()
    
    init(jsonData:JSON) {
        channel_id = jsonData["channel_id"].stringValue
        channel_name = jsonData["channel_name"].stringValue
        channel_logo = jsonData["channel_logo"].stringValue
        channel_url = jsonData["channel_url"].stringValue
        channel_picture = jsonData["channel_picture"].stringValue
        channel_stream = jsonData["channel_stream"].stringValue
        channel_stream_android = jsonData["channel_stream_android"].stringValue
        channel_stream_ios = jsonData["channel_stream_ios"].stringValue
        audio_only = jsonData["audio_only"].stringValue
        is_live = jsonData["is_live"].stringValue
        channel_desc = jsonData["channel_desc"].stringValue
        channel_on = jsonData["channel_on"].stringValue
        programJSON = jsonData["program"]
        if programJSON != ""{
            for json in programJSON.arrayValue{
                program?.append(CH2TVProgramModel(jsonData: json))
            }
        }
    }
}

class CH2TVProgramModel{
    var program_id:String = ""
    var program_name:String = ""
    var program_logo:String = ""
    var program_desc:String = ""
    var start_time:String = ""
    
    init(jsonData:JSON){
        program_id = jsonData["program_id"].stringValue
        program_name = jsonData["program_name"].stringValue
        program_logo = jsonData["program_logo"].stringValue
        program_desc = jsonData["program_desc"].stringValue
        start_time = jsonData["start_time"].stringValue
    }
}
//MARK: - CH2结束
//MARK: - CH3开始
///频道3model(电视节目回看)
class CH3Model{
    var Title:String = ""
    var Host:String = ""
    var Folder:String = ""
    var program:[CH3ProgramModel] = []
    
    init(jsonData:JSON) {
        Title = jsonData["Title"].stringValue
        Host = jsonData["Host"].stringValue
        Folder = jsonData["Folder"].stringValue
        for programJson in jsonData["Program"].arrayValue{
            program.append(CH3ProgramModel(jsonData: programJson))
        }
    }
}
///栏目model
class CH3ProgramModel{
    var program_id:String = ""
    var program_name:String = ""
    ///该栏目往期节目数据接口
    var indexFile:String = ""
    var program_logo:String = ""
    ///最后更新时间
    var last_Update:String = ""
    init(jsonData:JSON){
        program_id = jsonData["program_id"].stringValue
        program_name = jsonData["program_name"].stringValue
        indexFile = jsonData["indexFile"].stringValue
        program_logo = jsonData["program_logo"].stringValue
        last_Update = jsonData["last_Update"].stringValue
    }
}

///栏目往期视频model
class CH3ProgramVideoModel{
    ///标题带节目日期
    var title:String = ""
    ///该节目网站观看地址
    var titleurl:String = ""
    ///一级域名
    var host:String = ""
    ///文件夹名
    var dir:String = ""
    ///文件路径
    var filepath:String = ""
    ///视频路径
    var videofile:String = ""
    ///视频封面路径
    var thumbnail:String = ""
    ///发布时间
    var newstime:String = ""
    ///完整视频路径
    var totalVideoPath:String = ""
    ///完整封面路径
    var totalImagePath:String = ""
    
    init(jsonData:JSON) {
        title = jsonData["title"].stringValue
        titleurl = jsonData["titleurl"].stringValue
        host = jsonData["host"].stringValue
        dir = jsonData["dir"].stringValue
        filepath = jsonData["filepath"].stringValue
        videofile = jsonData["videofile"].stringValue
        thumbnail = jsonData["thumbnail"].stringValue
        newstime = jsonData["newstime"].stringValue
        totalImagePath = host + dir + filepath + thumbnail
        totalVideoPath = host + dir + filepath + videofile
    }
}

//MARK: - CH3结束
//MARK: - CH4开始
///频道4model(广播)
class CH4Model{
    var Title:String = ""
    var Host:String = ""
    var Folder:String = ""
    var Radio:[RadioModel] = []
    
    init(jsonData:JSON){
        Title = jsonData["Title"].stringValue
        Host = jsonData["Host"].stringValue
        Folder = jsonData["Folder"].stringValue
        for radioJson in jsonData["Radio"].arrayValue{
            Radio.append(RadioModel(jsonData: radioJson))
        }
    }
}
///广播详细数据model
class RadioModel{
    ///广播id
    var channel_id:String = ""
    ///广播名称
    var channel_name:String = ""
    ///广播logo
    var channel_logo:String = ""
    ///广播流
    var channel_stream:String = ""
    ///安卓端广播流
    var channel_stream_android:String = ""
    ///ios端广播流
    var channel_stream_ios:String = ""
    ///是否只有声音  1只有声音
    var audio_only:String = ""
    ///是否直播
    var is_live:String = ""
    ///频道介绍
    var channel_desc:String = ""
    ///频道是否开启标志位
    var channel_on:String = ""
    ///节目单数据
    var program:[CH4ProgramModel] = []
    
    init(jsonData:JSON){
        channel_id = jsonData["channel_id"].stringValue
        channel_name = jsonData["channel_name"].stringValue
        channel_logo = jsonData["channel_logo"].stringValue
        channel_stream = jsonData["channel_stream"].stringValue
        channel_stream_android = jsonData["channel_stream_android"].stringValue
        channel_stream_ios = jsonData["channel_stream_ios"].stringValue
        audio_only = jsonData["audio_only"].stringValue
        is_live = jsonData["is_live"].stringValue
        channel_desc = jsonData["channel_desc"].stringValue
        channel_on = jsonData["channel_on"].stringValue
        for programJson in jsonData["program"].arrayValue{
            program.append(CH4ProgramModel(jsonData: programJson))
        }
        
    }
}
///广播节目model
class CH4ProgramModel{
    ///节目id
    var program_id:String = ""
    ///节目名称
    var program_name:String = ""
    ///节目logo
    var program_logo:String = ""
    ///节目简介
    var program_desc:String = ""
    ///开始时间
    var start_time:String = ""
    ///节目回听数据源
    var program_stream:String = ""
    ///节目播放页面旋转图片
    var program_jpg:String = ""
    ///结束时间
    var end_time:String = ""
    ///节目时长（秒数）
    var duration_time:Int = 0
    
    init(jsonData:JSON){
        program_id = jsonData["program_id"].stringValue
        program_name = jsonData["program_name"].stringValue
        program_logo = jsonData["program_logo"].stringValue
        program_desc = jsonData["program_desc"].stringValue
        start_time = jsonData["start_time"].stringValue
        program_stream = jsonData["program_stream"].stringValue
        program_jpg = jsonData["program_jpg"].stringValue
        end_time = jsonData["end_time"].stringValue
        duration_time = jsonData["duration_time"].intValue
    }
}
//MARK: - CH4结束
//MARK: - CH5开始
///5频道model(论坛)
class CH5Model{
    var Title:String = ""
    var Host:String = ""
    var linkApi:String = ""
    ///论坛logo
    var forumLogo:String = ""
    
    init(jsonData:JSON){
        Title = jsonData["Title"].stringValue
        Host = jsonData["Host"].stringValue
        linkApi = jsonData["linkApi"].stringValue
        forumLogo = jsonData["forumLogo"].stringValue
    }
}
//MARK: - CH5结束
//MARK: - CH6开始
///6频道model(购物)
class CH6Model{
    var Title:String = ""
    var Host:String = ""
    var linkApi:String = ""
    
    init(jsonData:JSON){
        Title = jsonData["Title"].stringValue
        Host = jsonData["Host"].stringValue
        linkApi = jsonData["linkApi"].stringValue
    }
}
//MARK: - CH6结束
//MARK: - platform开始
///配置信息model
class PlatformModel{
    var iOS:String = ""
    var Android:String = ""
    var WP:String = ""
    
    init(jsonData: JSON){
        iOS = jsonData["iOS"].stringValue
        Android = jsonData["Android"].stringValue
        WP = jsonData["WP"].stringValue
    }
}
//MARK: - platform结束
//MARK: - 往期直播开始
///往期直播model
class ZhiBoHistoryModel{
    var title:String = ""
    ///视频地址
    var videofile:String = ""
    var titlepic:String = ""
    var time:String = ""
    var rid:String = ""
    
//    init(jsonData:JSON) {
//        title = jsonData["title"].stringValue
//        videofile = jsonData["videofile"].stringValue
//        titlepic = jsonData["titlepic"].stringValue
//        time = jsonData["time"].stringValue
//        rid = jsonData["rid"].stringValue
//    }
    
    init(jsonData:JSON) {
        title = jsonData["title"].stringValue
        videofile = jsonData["host"].stringValue + jsonData["dir"].stringValue + jsonData["filedate"].stringValue + jsonData["videofile"].stringValue
        titlepic = jsonData["host"].stringValue + jsonData["dir"].stringValue + jsonData["filedate"].stringValue + jsonData["thumbnail"].stringValue
        time = jsonData["newspath"].stringValue
        rid = jsonData["rid"].stringValue
    }
}
//MARK: - 往期直播结束
//MARK: - 评论开始
class CommentModel {
    ///评论id
    var id:String = ""
    ///昵称
    var nickName:String = ""
    ///头像
    var userLogo:String = ""
    ///评论内容
    var content:String = ""
    ///评论时间
    var createDate:String = ""
    
    init(jsonData:JSON) {
        id = jsonData["id"].stringValue
        nickName = jsonData["nickName"].stringValue
        userLogo = jsonData["userLogo"].stringValue
        content = jsonData["content"].stringValue
        createDate = jsonData["createDate"].stringValue
    }
}
//MARK: - 评论结束
