//
//  WXShareTools.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2020/2/17.
//  Copyright © 2020 DEV2018. All rights reserved.
//

import Foundation
import Kingfisher
class WXShareTools {
    enum WXShareType:String {
        case 朋友圈 = "朋友圈"
        case 会话 = "会话"
        case 收藏 = "收藏"
        case 指定的联系人 = "指定的联系人"
    }
    /// 分享链接
    static var shareLink       :String = ""
    
    /// 分享标题
    static var shareTitle      :String = ""
    
    /// 分享描述
    static var shareDescription:String = ""
    
    /// 分享图片
    static var sharePic        :String = ""
    
    /// 分享标签
    static var shareTag        :String = ""
    
    /// 分享目标
    static var shareScene      :Int32  = 0
 
    @objc class func WXShare(shareType type: WXShareType.RawValue, URL shareLink:String, shareTitle title:String, shareDescription description:String, sharePic pic:String, shareTag tag:String){
        
        let kfManager = KingfisherManager.shared
        let downloader = kfManager.downloader
        kfManager.defaultOptions = [.downloader(downloader), .forceRefresh, .backgroundDecode]
        let resouce = ImageResource(downloadURL: URL(string: "\(pic)")!)
        DispatchQueue.main.async {
            let _ = kfManager.retrieveImage(with: resouce, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if error == nil {
                    //图片下载成功
                    let imageShare = image!
                    var scene:WXScene!
                    switch type {
                    case "朋友圈":
                        scene = WXSceneTimeline
                        break
                    case "会话":
                        scene = WXSceneSession
                        break
                    case "收藏":
                        scene = WXSceneFavorite
                        break
                    case "指定的联系人":
                        scene = WXSceneSpecifiedSession
                        break
                    
                    default: break
                        
                    }
                    sendLinkURL(shareLink, tagName: "tag", title: title, description: description, thumbImage: imageShare, in: scene)
                    
                }else{
                    print((error?.localizedFailureReason)!)
                }
            })
        }
    }
    
    /// 微信sdk分享链接
    /// - Parameters:
    ///   - urlString: 链接
    ///   - tagName: 分享标签
    ///   - title: 分享标题
    ///   - description: 分享描述
    ///   - thumbImage: 分享图片
    ///   - scene: 分享目标,会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
    class func sendLinkURL(_ urlString: String, tagName: String, title: String, description: String, thumbImage: UIImage, in scene: WXScene){
        
        let ext = WXWebpageObject()
        ext.webpageUrl = urlString
        
        let message = WXMediaMessage()
        message.title = title
        message.description = description
        message.mediaObject = ext
        message.messageExt = nil
        message.messageAction = nil
        message.setThumbImage(thumbImage)
        message.mediaTagName = tagName
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.scene = Int32(scene.rawValue)
        req.message = message
        WXApi.send(req)
    }
}
