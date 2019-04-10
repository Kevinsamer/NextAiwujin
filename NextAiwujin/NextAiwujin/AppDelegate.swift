//
//  AppDelegate.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/1/29.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import EFNavigationBar
var Areas:[Area] = [Area]()
var globalAppConfig:AppConfigModel = AppConfigModel(jsonData: ""){
    didSet{
        //TODO:进入app时初始化新闻详细数据的数组newsArray，避免第一次进入页面时的卡顿
//        for menu in globalAppConfig.CH1.menu {
//            AppConfigViewModel.requestCH1Items(url: menu.File) { (news) in
//                AppDelegate.newsArray?.append(news)
//            }
//        }
        
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var mCenterViewModel:MycenterViewModel = MycenterViewModel()
    var window: UIWindow?
    static var appUser:AppUser?{
        didSet{
            
        }
    }
    
    
    static var newsArray: [[CH1MenuItemModel]]? = []{
        didSet{
            
        }
    }
    
    ///判断是否为登录状态
    static func isLogin() -> Bool{
        if appUser?.id == -1 {
            return false
        }
        return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //全局设置tabBarStyle
        UITabBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().clipsToBounds = true
        
        //全局设置navigationBarStyle
        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage.init(color: UIColor.white, size: CGSize(width: finalScreenW, height: finalNavigationBarH)), for: UIBarMetrics.default)
        //        UINavigationBar.appearance().topItem?.title = ""
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)//设置偏移量来隐藏返回按钮文字,TODO：修改为基类中设置navigationController?.navigationBar.topItem?.title = ""
        EFNavigationBar.defaultTransition = EFTransitionMethod.linear
        
//        设置状态栏style
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        //输入框适应键盘位置
        IQKeyboardManager.shared.enable = true
        //初始化地区信息
        Areas = MyAreaPickerView.getDataFromTxt()!
        //异步初始化新闻数据信息
        DispatchQueue.main.async {
            AppConfigViewModel.requestAppConfig { (appConfig) in
                globalAppConfig = appConfig
            }
        }
        
        //firstOpenUserInit
        if AppUserCoreDataHelper.AppUserHelper.getAppUser() == nil {
            AppUserCoreDataHelper.AppUserHelper.insertAppUser()
        }
        AppDelegate.appUser = AppUserCoreDataHelper.AppUserHelper.getAppUser()
        //print(AppDelegate.appUser?.user_id)
        //----------最后登录差值判断并补登录方法
        if AppDelegate.appUser?.user_id != -1{
            //未登录时的游客id为-1，如果不等于-1则已登录，每次进入app时都判断一下最后登录时间与当前时间的差值，如果相差大于2天则调用登录方法
            //print(AppDelegate.appUser?.local_pd)
            if YTools.calculateDifferenceBetweenTwoTimes(dateOne: YTools.stringToDate(str: (AppDelegate.appUser?.last_login)!), dateTwo: Date.now()) > 48 {
                //如果时间差大于48h，再次登录
                //1.benD记录了pass，自动再次登录
                if let name = AppDelegate.appUser?.username{
                    if let pass = AppDelegate.appUser?.local_pd{
                        self.mCenterViewModel.requestLoginData(username: name, password: pass, finishCallback: {
                            
                        })
                    }
                }
                //2.App退出登录
//                if AppDelegate.appUser?.id != -1 {
//
//                    AppUserCoreDataHelper.AppUserHelper.delAppUser {
//                        //self.navigationController?.popViewController(animated: true)
//                        //self.navigationController?.popViewController(animated: true)?.tabBarController?.selectedIndex = 0
//                    }
//                    //发出退出登录的http请求
//                    self.mCenterViewModel.requestLoginOut()
//
//                }
                
            }
        }
        
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay"{
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                //此处接收到返回数据后使用通知把值传到PayVC
                //TODO:支付宝接入流程文档编写
                //print("返回码\(resultDic)")
                NotificationCenter.default.post(name: ALiPayResultNotificationName, object: self, userInfo: resultDic)
            })
        }
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NextAiwujin")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

