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
    
    func insertHistory(history:String){
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
    }
    
    func getHistory() -> [SearchHistory]{
        let fetchRequest:NSFetchRequest = SearchHistory.fetchRequest()
        do {
            let histories = try context.fetch(fetchRequest)
            return histories
        } catch  {
            fatalError("\(error)")
        }
    }
    
    func modifyHistory(history:SearchHistory){
        saveData()
    }
    ///删除某个历史
    func delHistory(history:SearchHistory){
        context.delete(history)
        saveData()
    }
    ///清空搜索历史
    func delAllHistory(){
        for history in self.getHistory(){
            delHistory(history: history)
        }
    }
    
    
}
