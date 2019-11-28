//
//  UISearchBar-extension.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/10/31.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation

extension UISearchBar {
    public func getSearchTextField() -> UITextField{
        if #available(iOS 13.0, *){
            return self.searchTextField
        }else{
            return value(forKey: "searchField") as! UITextField
        }
    }
}
