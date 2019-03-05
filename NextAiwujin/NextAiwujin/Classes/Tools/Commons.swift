//
//  Commons.swift
//  NextAiwujin
//  常量类
//  Created by DEV2018 on 2019/2/1.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import Foundation
import UIKit

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
