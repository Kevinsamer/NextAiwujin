//
//  SearchHistoryCoreDataHelper.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/3/12.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import CoreData
class SearchHistoryCoreDataHelper{
    static let historyHelper = SearchHistoryCoreDataHelper()
    
    private func saveData(){
        do {
            try context.save()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    func insertHistory(history:String, type:String = "shop"){
        switch type {
        case "shop":
            let his = NSEntityDescription.insertNewObject(forEntityName: "SearchHistory", into: context) as! SearchHistory
            for his in self.getHistory(){
                if his.history == history{
                    self.delHistory(history: his)
                }
            }
            his.history = history
            saveData()
            if getHistory().count > maxHistory{
                delHistory(history: getHistory().first!)
            }
            break;
        case "web":
            let his = NSEntityDescription.insertNewObject(forEntityName: "WebSearchHistory", into: context) as! WebSearchHistory
            for his in self.getWebHistory(){
                if his.webhistory == history{
                    self.delWebHistory(history: his)
                }
            }
            his.webhistory = history
            saveData()
            if getWebHistory().count > maxHistory{
                delHistory(history: getHistory().first!)
            }
            break;
        default:
            break;
        }

        
    }
    
    
    /// 商城搜索历史
    /// - Returns: 搜索历史结果
    func getHistory() -> [SearchHistory]{
        let fetchRequest:NSFetchRequest = SearchHistory.fetchRequest()
        do {
            let histories = try context.fetch(fetchRequest)
            return histories
        } catch  {
            fatalError("\(error)")
        }
    }
    
    /// 网站搜索历史
    /// - Returns: 搜索历史结果
    func getWebHistory() -> [WebSearchHistory]{
        let fetchRequest:NSFetchRequest = WebSearchHistory.fetchRequest()
        do {
            let histories = try context.fetch(fetchRequest)
            return histories
        } catch  {
            fatalError("\(error)")
        }
    }
    
    
    /// 商城搜索历史修改
    /// - Parameter history: 要修改的搜索结果
    func modifyHistory(history:SearchHistory){
        saveData()
    }
    
    /// 网站搜索历史修改
    /// - Parameter history: 要修改的搜索结果
    func modifyWebHistory(history:WebSearchHistory){
        saveData()
    }
    
    
    ///删除商城某个搜索历史
    func delHistory(history:SearchHistory){
        context.delete(history)
        saveData()
    }
    
    ///删除网站某个搜索历史
    func delWebHistory(history:WebSearchHistory){
        context.delete(history)
        saveData()
    }
    
    ///清空商城搜索历史
    func delAllHistory(){
        for history in self.getHistory(){
            delHistory(history: history)
        }
    }
    
    ///清空网站搜索历史
    func delAllWebHistory(){
        for history in self.getWebHistory(){
            delWebHistory(history: history)
        }
    }
    
    
}
