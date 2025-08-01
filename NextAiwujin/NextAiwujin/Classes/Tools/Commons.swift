//
//  Commons.swift
//  NextAiwujin
//  常量类
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import UIKit
import CoreData
//ps--tag设置记录：新闻页banner=index+10000，商城页banner=index+20000，商城页分类collectionView=301，商城页今日推荐collectionView=302

let finalScreenW : CGFloat = UIScreen.main.bounds.width
let finalScreenH : CGFloat = UIScreen.main.bounds.height

let finalStatusBarH : CGFloat = UIApplication.shared.statusBarFrame.size.height
let finalNavigationBarH : CGFloat = 44
let finalTabBarH : CGFloat = 49
let notificationBarH : CGFloat = 20
let IphonexHomeIndicatorH :CGFloat = 34
public var searchContent : String = ""
public var finalContentViewHaveTabbarH = UIDevice.current.isX() ? finalScreenH - finalStatusBarH - finalNavigationBarH - finalTabBarH - IphonexHomeIndicatorH : finalScreenH - finalStatusBarH - finalNavigationBarH - finalTabBarH
public var finalContentViewNoTabbarH = UIDevice.current.isX() ? finalScreenH - finalStatusBarH - finalNavigationBarH - IphonexHomeIndicatorH : finalScreenH - finalStatusBarH - finalNavigationBarH

public var testMode : Bool = true//测试模式flag
public var showSearchButton = true//某些页面是否显示搜索按钮
//搜索栏显示状态标记 1隐藏  2显示
public var searchBarState = 2
public var loginState:Bool = false//登录状态
public var context:NSManagedObjectContext = {
    let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    return context
}()
//个人中心cell文字颜色集合
let myCenterColors:[UIColor] = [#colorLiteral(red: 0.1960784314, green: 0.6980392157, blue: 0.9254901961, alpha: 1),#colorLiteral(red: 0.2078431373, green: 0.7333333333, blue: 0.5960784314, alpha: 1),#colorLiteral(red: 0.1215686275, green: 0.6705882353, blue: 0.9215686275, alpha: 1),#colorLiteral(red: 0.9450980392, green: 0.2509803922, blue: 0.4823529412, alpha: 1),#colorLiteral(red: 0.968627451, green: 0.3529411765, blue: 0.3803921569, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.5529411765, blue: 0.568627451, alpha: 1),#colorLiteral(red: 1, green: 0.7019607843, blue: 0.3490196078, alpha: 1)]

//支付宝支付结果通知名
public let ALiPayResultNotificationName:NSNotification.Name = NSNotification.Name(rawValue: "ALiPayResultNotificationName")
//自定义alert单例
let myAlert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)

//取消订单通知名
public let CancelOrderNotificationName:NSNotification.Name = NSNotification.Name("CancelOrderNotificationName")

//确认收货订单通知名
public let ConfirmOrderNotificationName:NSNotification.Name = NSNotification.Name("ConfirmOrderNotificationName")

//播放器未全屏时执行pop的通知名
public let PopVCWhenPlayerNotFullScreenNotificationName:NSNotification.Name = Notification.Name("PopVCWhenPlayerNotFullScreenNotificationName")

//音频开始播放时的通知
public let AudioPlayingNotificationName:NSNotification.Name = Notification.Name("AudioPlayingNotificationName")

//搜索历史记录最大数
let maxHistory:Int = 20

//播放器顶部bar的高度
let playerTopBarH:CGFloat = 40 + finalStatusBarH

//强制横屏变量
public var blockRotation = Bool()

///颜色常量
enum myColors{
    /// 微信绿色
    static let wxGreen: UIColor = #colorLiteral(red: 0.02745098039, green: 0.7568627451, blue: 0.3764705882, alpha: 1)
}


/// 权限类型
enum HWpermissionsType{
    /// 相机
    case camera
    /// 相册
    case photo
    /// 位置
    case location
    /// 网络
    case network
    /// 麦克风
    case microphone
    /// 媒体库
    case media
}

///tabbar索引
enum tabIndex: Int {
    case 视听 = 0
    case 新闻 = 1
//    case 报料 = 2
    case 商城 = 2
    case 我的 = 3
}
