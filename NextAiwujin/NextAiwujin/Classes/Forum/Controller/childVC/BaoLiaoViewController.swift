//
//  BaseBaoLiaoViewController.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/11/26.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import SwiftyJSON
import Toast_Swift
import Photos
private let picW:CGFloat = (finalScreenW - 20 - 10)/3
private let picCellID:String = "picCellID"
private let baoliaoPlaceholder:String = "请输入报料内容"
/// 图片url数组
public var imageUrlArray: [URL] = [] {
    didSet{
        for url in imageUrlArray {
            print(url)
        }
    }
}
class BaoLiaoViewController: BaseViewController {
    //定位相关
    var locationManager = CLLocationManager()
    var currLocation = CLLocation()
    //当前位置信息
    var locationStr:String = ""{
        didSet{
            if self.locationStr != oldValue {
//                print(self.locationStr)
                self.lbsLabel.text = self.locationStr + "\n\n\n\n\n"
            }
            
        }
    }
    
   
    
    /// 图片id数组，用于新增报料
    var imageIDArray: [String] = [] {
        didSet{
//            print(imageIDArray)
        }
    }
    
    var file_ids: String = ""
    
    
    /// 选中的图片组
    var imageArray: [UIImage] = [] {
        didSet{
            picCollView.reloadData()
        }
    }
    
    //MARK: - 懒加载
    
    /// 上传文件loading动画
    lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            view.style = UIActivityIndicatorView.Style.large
        } else {
            view.style = .whiteLarge
        }
//        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4421553938)
        return view
    }()
    
    /// 手动输入地址框
    lazy var addressInputAlert: UIAlertController = {
        let alert = UIAlertController(title: "请输入详细地址", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.modalTransitionStyle = .crossDissolve
        alert.addTextField { (textField) in
            textField.placeholder = "详细地址"
        }
        let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
            if let addressString = alert.textFields![0].text {
                if addressString != "" {
                    self.lbsLabel.text = "\(addressString)\n\n\n\n\n"
                    self.locationStr = addressString
                }
            }
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }()
    
    lazy var submitBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        btn.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: UIControl.State.disabled)
        //disable背景为淡灰色,normal背景为绿色
        btn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btn.isEnabled = false
        btn.setTitleForAllStates("发布")
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(sumbitNews), for: .touchUpInside)
        return btn
    }()
    
    //dismiss按钮
    lazy var dismissBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImageForAllStates(#imageLiteral(resourceName: "guanbi"))
        btn.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(dismissSelf), for: UIControl.Event.touchUpInside)
        return btn
    }()

    //报料内容
    lazy var inputField: UITextView = {
        let field = UITextView()
        field.placeholder = baoliaoPlaceholder
        field.delegate = self
        field.font = UIFont.systemFont(ofSize: 16)
//        field.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return field
    }()
    //添加图片按钮
    lazy var addPicBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImageForAllStates(#imageLiteral(resourceName: "baoliao_add_pic"))
        btn.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        btn.addTarget(self, action: #selector(selectPic), for: UIControl.Event.touchUpInside)
        return btn
    }()
    //展示图片collectionView
    lazy var picCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: picW, height: picW)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        //layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        let coll = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: picCellID)
        coll.backgroundColor = .white
        coll.delegate = self
        coll.dataSource = self
        return coll
    }()
    //lbs图标
    lazy var lbsImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "address_icon_desel"))
//        img.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(location)))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    //位置信息label
    lazy var lbsLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inputAddress)))
        return label
    }()
    
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        imageUrlArray = []
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputField.resignFirstResponder()
    }

}
//MARK: - 设置UI
extension BaoLiaoViewController {
    override func initData() {
        super.initData()
        location()
//        print(IsOpenAlbum())
//        hw_openAlbumServiceWithBlock { (result) in
//            print(result)
//        }
    }
    
    // MARK: - 检测是否开启相册
    /// 检测是否开启相册
    func hw_openAlbumServiceWithBlock(_ isSet:Bool? = nil,_ action :@escaping ((Bool)->())) {
        var isOpen = true
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
            isOpen = false;
            if isSet == true {YTools.settingOpenURL(.photo)}
        }
        action(isOpen)
    }
    
    //是否开启相册权限
    func IsOpenAlbum() -> Bool{
        let authStatus = PHPhotoLibrary.authorizationStatus()
        return authStatus != .restricted && authStatus != .denied
    }
    
    override func setUI() {
        super.setUI()
        //0.设置dismiss按钮
        setDismissBtn()
        //0.1设置提交按钮
        setSubmitBtn()
        //1.设置报料输入框
        setInputField()
        //2.设置选择图片控件
        setPicChooseView()
        //3.设置lbs图标
        setLBSImage()
        //4.设置lbslabel
        setLBSLabel()
    }
    
    private func setSubmitBtn(){
        self.view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIDevice.current.isX() ? (20 + finalStatusBarH) : (finalStatusBarH + finalStatusBarH))
            make.bottom.equalTo(dismissBtn.snp.bottom)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(60)
            
        }
    }
    
    private func setDismissBtn(){
        self.view.addSubview(dismissBtn)
        dismissBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(finalStatusBarH)
        }
    }
    
    private func setLBSLabel(){
        self.view.addSubview(lbsLabel)
        lbsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(picCollView.snp.bottom).offset(10)
            make.left.equalTo(lbsImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(UIDevice.current.isX() ? -IphonexHomeIndicatorH : 0)
//            make.height.equalTo(100)
        }
    }
    
    private func setLBSImage(){
        self.view.addSubview(lbsImageView)
        lbsImageView.snp.makeConstraints { (make) in
            make.top.equalTo(picCollView.snp.bottom).offset(20)
            make.left.equalTo(picCollView.snp.left)
            make.width.height.equalTo(30)
        }
    }
    
    private func setInputField(){
        self.view.addSubview(inputField)
        inputField.snp.makeConstraints { (make) in
            make.top.equalTo(dismissBtn.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
    }
    
    private func setPicChooseView(){
        self.view.addSubview(picCollView)
        picCollView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(finalScreenW - 20)
            make.height.equalTo(picW * 3 + 10)
        }
    }
 
}

//MARK: - 设置UICollectionView的代理和数据源协议
extension BaoLiaoViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picCellID, for: indexPath)
        cell.backgroundColor = .random
        if indexPath.row == 0 {
            cell.addSubview(addPicBtn)
            addPicBtn.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }else {
            if imageArray.count > 0 {
                let imageView = UIImageView(image: imageArray[indexPath.row-1])
                cell.addSubview(imageView)
                imageView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: - 点击事件
extension BaoLiaoViewController {
    
    /// dismiss页面事件，拦截该事件并将以写内容存入草稿箱
    @objc private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 定位
    @objc private func location(){
        // 初始化地图框架
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // 设置精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    /// 输入地址
    @objc private func inputAddress(){
        self.present(addressInputAlert
            , animated: true, completion: nil)
    }
    
    
    /// 选择图片
    @objc private func selectPic(){
        let picAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        let localAction = UIAlertAction(title: "本地图片", style: .default) { [unowned self] (action) in
            self.goImage()
        }
        let takingPhotoAction = UIAlertAction(title: "拍照", style: .default) { [unowned self]  (action) in
            self.goCamera()
        }
        picAlert.addAction(takingPhotoAction)
        picAlert.addAction(localAction)
        picAlert.addAction(cancelAction)
        self.present(picAlert, animated: true, completion: nil)
    }
    
    /// 调起相机
    private func goCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            
            print("不支持拍照")
            
        }

    }
    
    /// 调起相册
    private func goImage(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
        
    }
    
    
    /// 提交报料
    @objc private func sumbitNews(){

        // -1.位置信息判断
        if self.locationStr == "" {
            YTools.showMyToast(rootView: self.view, message: "请重新定位或正确填写位置信息", duration: 1, position: .center, completion: nil)
            return
        }
        // 0.加载动画
        self.view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backView.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        loadingView.startAnimating()
        // 1.创建文件上传队列调度组
        let group = DispatchGroup()
       
        // 2.创建上传线程
        let queue = DispatchQueue(label: "myUploadFiles")
        if imageUrlArray.count >= 0 {
            //循环执行入组和出组操作，出组需在请求网络内部完成
            for url in imageUrlArray {
                //3.入组
                group.enter()
                //4.异步上传文件
                queue.async(group: group) {
                    BaoLiaoViewModel.uploadFiles(url: url) {[unowned self] (uploadResult) in
                        self.imageIDArray.append(uploadResult.file_id)
                        self.file_ids += "\(uploadResult.file_id),"
                        //5.出组
                        group.leave()
                    }
                }
            }
            //6.调度组所有任务执行完毕后，执行后续操作
            group.notify(queue: .main) {
                self.file_ids = String(self.file_ids.dropLast())
                BaoLiaoViewModel.requestAddReportNews(content: self.inputField.text, address: self.locationStr, file_ids: self.file_ids) { (result) in
                    print(result)
                    
                    //上传完成提示
                    UIView.animate(withDuration: 0.3, animations: {
                        self.loadingView.alpha = 0
                    }) { (finished) in
                        if finished {
                            //上传成功后清除图片路径数组
                            imageUrlArray.removeAll()
                            YTools.showMyToast(rootView: self.view, message: "报料成功！", duration: 1.5, position: .center) { (finished) in
                                self.loadingView.stopAnimating()
                                self.loadingView.removeFromSuperview()
                                self.backView.removeFromSuperview()
                                self.dismissSelf()
                            }
                        }else {
                            YTools.showMyToast(rootView: self.view, message: "网络异常，请重新提交报料", duration: 1.5, position: .center, completion: nil)
                        }
                        
                    }
                }
            }
        }
        
    }
}

//MARK: - 设置报料输入框的代理协议
extension BaoLiaoViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
//        print(textView.text.lengthOfBytes(using: String.Encoding.utf8))
        if textView.text.lengthOfBytes(using: .utf8) > 0 {
            //监听到有文字输入时将提示文字去除并将提交按钮设置为可用
            textView.placeholder = nil
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = myColors.wxGreen
            
        }else {
            textView.placeholder = baoliaoPlaceholder
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}

//MARK: - 设置相册代理协议
extension BaoLiaoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            print("获得照片============= \(info)")
        //每次弹出此页面，imageArray都会清空
//            print(self.imageArray.count)
            let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
//        print(info[UIImagePickerController.InfoKey.imageURL] as! URL)
           //显示设置的照片
//           imgView.image = image
        
        //判断图片来源，如果是图库则直接获得路径，如果是拍照则先存储照片后获得路径
        if picker.sourceType == .camera {
            //1.使用UIImageWriteToSavedPhotosAlbum()方法保存图片
            //UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImg(image:didFinishSavingWithError:contextInfo:)), nil)
            //2.使用Photos框架来保存图片
            
            
//            print(PHPhotoLibrary.authorizationStatus().rawValue)
            PhotoAlbumUtil.saveImageInAlbum(image: image, albumName: "爱武进") { (result) in
                DispatchQueue.main.async {
                    switch result{
                    case .success:
                        print("success")
                        self.imageArray.append(image)
                        break
                        
                    case .error:
                        print("error")
                        break
                        
                    case .denied:
                        print("denied")
                        YTools.showMyToast(rootView: self.view, message: "没有相册权限,请您到 \"设置\" -> \"APP\" 开启相册权限")
//                        DispatchQueue.main.async {
//                            let a = MyAlertController(title: "没有相册权限", message: "请您到 \"设置\" -> \"APP\" 开启相册权限", preferredStyle: .alert)
//                            a.addAction(UIAlertAction(title: "去设置", style: UIAlertAction.Style.default, handler: { (action) in
//                                let url = URL(string: UIApplication.openSettingsURLString)
//                                if let url = url, UIApplication.shared.canOpenURL(url) {
//                                    if #available(iOS 10, *) {
//                                        UIApplication.shared.open(url, options: [:],
//                                                                  completionHandler: {
//                                                                    (success) in
//                                        })
//                                    } else {
//                                        UIApplication.shared.openURL(url)
//                                    }
//                                }
//                            }))
//
//                            a.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
//                            a.show()
//                        }
                        
                        break
                        
                    }
                }
            }
            
        }else if picker.sourceType == .photoLibrary {
            self.imageArray.append(image)
            imageUrlArray.append(info[UIImagePickerController.InfoKey.imageURL] as! URL)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveImg(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject){
        if error != nil{
            print("保存失败")
        }else{
            print("保存成功")
//            print(image.accessibilityPath)
            
        }
    }
}

//MARK: - 设置定位协议
extension BaoLiaoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Error while updating location: " + error.localizedDescription)
           self.lbsLabel.text = "获取地理位置信息失败，请点击左侧重新获取或点击文字输入详细地址\n\n\n\n\n"
       }
       
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           // 将经纬度转化成地址
           CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {
           (placemarks, error) -> Void in
               //"获取地理位置信息失败，请点击左侧重新获取或点击文字输入详细地址\n\n\n\n\n"
               if error != nil {
                print("Reverse geocoder failed with error: " + error!.localizedDescription)
                   self.lbsLabel.text = "获取地理位置信息失败，请点击左侧重新获取或点击文字输入详细地址\n\n\n\n\n"
                   return
               }
               
               
               if placemarks!.count > 0 {
                   let pm = placemarks![0]
                   self.displayLocationInfo(pm)
               }
               else {
                   print("Error existed in the data received from geocoder")
                   self.lbsLabel.text = "获取地理位置信息失败，请点击左侧重新获取或点击文字输入详细地址\n\n\n\n\n"
               }
               
           })
       }
       
       func displayLocationInfo(_ placemark: CLPlacemark?) {
            guard let containsPlacemark = placemark else {return}
            locationManager.stopUpdatingLocation()
    
        self.locationStr = "\(containsPlacemark.locality ?? "") \(containsPlacemark.subLocality ?? "") \(containsPlacemark.thoroughfare ?? "") \(containsPlacemark.subThoroughfare ?? "") \(containsPlacemark.name ?? "")"

       }

}


/// 操作结果枚举
enum PhotoAlbumUtilResult {
    ///成功存入相册
    case success
    ///存入相册失败
    case error
    ///未授权
    case denied
}
 
/// 相册操作工具类
class PhotoAlbumUtil: NSObject {
     
     public typealias completion = ((_ result: PhotoAlbumUtilResult) -> ())
    ///判断是否授权,已授权或未选择是否授权返回true，未授权或拒绝返回false
    class func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .notDetermined
         
    }
     
    
    /// 保存图片到相册
    /// - Parameters:
    ///   - image: 目标图片实例
    ///   - albumName: 相册名
    ///   - completion: 回调函数，返回存入相册操作结果
    class func saveImageInAlbum(image: UIImage, albumName: String,
                                completion: completion?) {
        //权限验证，如未授权则直接结束
        if !isAuthorized() {
            completion?(.denied)
            return
        }
        var assetAlbum: PHAssetCollection?
         
        //如果指定的相册名称为空，则保存到相机胶卷。（否则保存到指定相册）
        if albumName.isEmpty {
            let list = PHAssetCollection
                .fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary,
                                       options: nil)
            assetAlbum = list[0]
        } else {
            //看保存的指定相册是否存在
            let list = PHAssetCollection
                .fetchAssetCollections(with: .album, subtype: .any, options: nil)
            list.enumerateObjects({ (album, index, stop) in
                let assetCollection = album
                if albumName == assetCollection.localizedTitle {
                    assetAlbum = assetCollection
                    stop.initialize(to: true)
                }
            })
            //不存在的话则创建该相册
            if assetAlbum == nil {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest
                        .creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: { (isSuccess, error) in
                    self.saveImageInAlbum(image: image, albumName: albumName,
                                          completion: completion)
                })
                return
            }
        }
        
        /// 保存标志位
        var localId: String! = ""

        PHPhotoLibrary.shared().performChanges({
            //添加的相机胶卷
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            //是否要添加到相簿
            if !albumName.isEmpty {
                let assetPlaceholder = result.placeholderForCreatedAsset
                let albumChangeRequset = PHAssetCollectionChangeRequest(for:
                    assetAlbum!)
                albumChangeRequset!.addAssets([assetPlaceholder!]  as NSArray)
                //保存标志符
                localId = assetPlaceholder?.localIdentifier
            }
            //TODO:看懂这段代码，并添加其他权限提示
            
        }) { (isSuccess, error) in
            if isSuccess {
                print("保存成功")
                //通过标志符获取对应的资源
                let assetResult = PHAsset.fetchAssets(
                    withLocalIdentifiers: [localId], options: nil)
                let asset = assetResult[0]
                let options = PHContentEditingInputRequestOptions()
                options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData)
                    -> Bool in
                    return true
                }
                //获取保存的图片路径
                asset.requestContentEditingInput(with: options, completionHandler: {
                    (contentEditingInput:PHContentEditingInput?, info: [AnyHashable : Any]) in
//                    print("地址：",contentEditingInput!.fullSizeImageURL!)
                    imageUrlArray.append(contentEditingInput!.fullSizeImageURL!)
                })
                completion?(.success)
            }else{
                print("保存失败",error!.localizedDescription)
                completion?(.error)
            }
        }
    }
}
