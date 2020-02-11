//
//  BaoLiaoModel.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/11/28.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
///报料详情Model
class BaoLiaoModel {
    ///报料id
    var id:Int = -1
    ///报料内容
    var content: String = ""
    ///文件id，通过“，”分隔
    var file_id: String = ""
    
    var customer_id: Int = -1
    ///创建时间
    var created_at: String = ""
    ///更新时间
    var updated_at: String = ""
    ///报料状态  1已提交 0未提交
    var state: Int = -1
    ///图片列表
    var picList: [FileDetail] = []
    
    init(jsonData:JSON){
        id = jsonData["id"].intValue
        content = jsonData["content"].stringValue
        file_id = jsonData["file_id"].stringValue
        customer_id = jsonData["customer_id"].intValue
        created_at = jsonData["created_at"].stringValue
        updated_at = jsonData["updated_at"].stringValue
        state = jsonData["state"].intValue
        for json in jsonData["file_deatil"].arrayValue {
            picList.append(FileDetail(jsonData: json))
        }
    }
}

///文件详情Model
class FileDetail {
    
    ///图片路径
    var img_url: String = ""
    ///文件id
    var file_id: String = ""
    ///文件类型
    var ext: String = ""
    
    init(jsonData:JSON){
        img_url = jsonData["img_url"].stringValue
        file_id = jsonData["file_id"].stringValue
        ext = jsonData["ext"].stringValue
    }
}

class UploadFilesModel {
    
    var file_name: String = ""
    var real_name: String = ""
    var ext: String = ""
    var file_id: String = ""
    
    init(jsonData:JSON) {
        file_name = jsonData["file_name"].stringValue
        real_name = jsonData["real_name"].stringValue
        ext = jsonData["ext"].stringValue
        file_id = jsonData["file_id"].stringValue
    }
}

/// 报料列表model
class ReportListModel {
    
    var id: Int = -1
    var content: String = ""
    var file_id: String = ""
    var customer_id: Int = -1
    var created_at: String = ""
    var updated_at: String = ""
    var state: Int = -1
    var address: String = ""
    
    init(jsonData:JSON) {
        id = jsonData["id"].intValue
        content = jsonData["content"].stringValue
        file_id = jsonData["file_id"].stringValue
        customer_id = jsonData["customer_id"].intValue
        created_at = jsonData["created_at"].stringValue
        updated_at = jsonData["updated_at"].stringValue
        state = jsonData["state"].intValue
        address = jsonData["address"].stringValue
    }
}
