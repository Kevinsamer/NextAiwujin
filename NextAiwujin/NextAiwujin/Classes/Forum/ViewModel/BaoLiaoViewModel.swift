//
//  BaoLiaoViewModel.swift
//  NextAiwujin
//  报料viewmodel
//  Created by DEV2018 on 2019/11/28.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class BaoLiaoViewModel {
    
}

//MARK: - 报料网络请求
extension BaoLiaoViewModel {
    
    /// 请求新增新的报料
    /// - Parameters:
    ///   - content: 报料内容
    ///   - address: 地址
    ///   - file_ids: 文件id数组
    ///   - finishCallback: 回调函数
    class func requestAddReportNews(content: String, address: String, file_ids: String, finishCallback: @escaping (_ message: JSON)->()){
        let parameters: [String: String] = ["content":"\(content)", "address":"\(address)", "file_ids":"\(file_ids)"]
//        print(parameters)
        NetworkTool.requestDataByJSON(type: .POST, urlString: ADD_REPORT_NEWS_URL, parameters: parameters) { (result) in
            let resultJson = JSON(result)
//            print(resultJson)
            finishCallback(resultJson)
        }
    }
    
    
    /// 请求报料列表
    /// - Parameter finishCallback: 回调函数
    class func requestNewsList(finishCallback: @escaping (_ reportNewList: [ReportListModel])->()){
        NetworkTool.requestData(type: .POST, urlString: REPORT_NEWS_LIST_URL) { (result) in
//            print(JSON(result))
            var reportList:[ReportListModel] = []
            let jsonList = JSON(result)["data"].arrayValue
//            if jsonList.count == 0 {
//                finishCallback(reportList)
//            }else {
//                
//            }
            for json in jsonList {
                reportList.append(ReportListModel(jsonData: json))
            }
            finishCallback(reportList)
        }
    }
    
    
    /// 上传文件
    /// - Parameters:
    ///   - url: 文件url
    ///   - finishCallback: 回调函数
    class func uploadFiles(url: URL, finishCallback: @escaping (_ uploadResult: UploadFilesModel)->()){
        NetworkTool.uploadFiles(fileUrl: url, toUrl: UPLOAD_FILES_URL) { (result) in
            let resultJson = JSON(result)
            print(resultJson)
            let resultModel = UploadFilesModel(jsonData: resultJson[0])
            finishCallback(resultModel)
        }
    }
}
