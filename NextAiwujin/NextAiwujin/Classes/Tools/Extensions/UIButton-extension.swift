//
//  UIButton-extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/3.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
enum TitleImageStyly{
    ///图片在左，文字在右，整体居中。
    case ButtonImageTitleStyleDefault
    //图片在左，文字在右，整体居中。
    case ButtonImageTitleStyleLeft
    ///图片在右，文字在左，整体居中。
    case ButtonImageTitleStyleRight
    ///图片在上，文字在下，整体居中。
    case ButtonImageTitleStyleTop
    ///图片在下，文字在上，整体居中。
    case ButtonImageTitleStyleBottom
    ///图片居中，文字在上距离按钮顶部。
    case ButtonImageTitleStyleCenterTop
    ///图片居中，文字在下距离按钮底部。
    case ButtonImageTitleStyleCenterBottom
    ///图片居中，文字在图片上面。
    case ButtonImageTitleStyleCenterUp
    ///图片居中，文字在图片下面。
    case ButtonImageTitleStyleCenterDown
    ///图片在右，文字在左，距离按钮两边边距
    case ButtonImageTitleStyleRightLeft
    ///图片在左，文字在右，距离按钮两边边距
    case ButtonImageTitleStyleLeftRight
}
extension UIButton {
    
    func setButtonTitleImageStyle(padding:CGFloat, style:TitleImageStyly){
        let padding:CGFloat = padding
        if self.imageView?.image != nil && self.titleLabel?.text != nil {
            //先还原
            self.titleEdgeInsets = UIEdgeInsets.zero;
            self.imageEdgeInsets = UIEdgeInsets.zero;
            
            let imageRect:CGRect = self.imageView!.frame;
            let titleRect:CGRect = self.titleLabel!.frame;
            
            let totalHeight:CGFloat = imageRect.size.height + padding + titleRect.size.height;
            let selfHeight:CGFloat = self.frame.size.height;
            let selfWidth:CGFloat = self.frame.size.width;
            
            switch style{
            case .ButtonImageTitleStyleLeft :
                if (padding != 0)
                {
                    self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                        left: padding/2,
                                                        bottom: 0,
                                                        right: -padding/2);
                    
                    self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                        left: -padding/2,
                                                        bottom: 0,
                                                        right: padding/2);
                }
                
                break
            case .ButtonImageTitleStyleRight:
                //图片在右，文字在左
                self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: -(imageRect.size.width + padding/2),
                                                    bottom: 0,
                                                    right: (imageRect.size.width + padding/2));
                
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: (titleRect.size.width +  padding/2),
                                                    bottom: 0,
                                                    right: -(titleRect.size.width + padding/2));
                break
                
            case .ButtonImageTitleStyleTop:
                //图片在上，文字在下
                self.titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                                    left: (selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                    bottom: -((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                                    right: -(selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                                    left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                    bottom: -((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                                    right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
                break
                
            case .ButtonImageTitleStyleBottom:
                //图片在下，文字在上。
                self.titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                                    left: (selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                    bottom: -((selfHeight - totalHeight)/2 - titleRect.origin.y),
                                                    right: -(selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight)/2 + titleRect.size.height + padding - imageRect.origin.y),
                                                    left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                    bottom: -((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y),
                                                    right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
                break
            case .ButtonImageTitleStyleCenterTop:
                self.titleEdgeInsets = UIEdgeInsets(top: -(titleRect.origin.y - padding),
                                                    left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                    bottom: (titleRect.origin.y - padding),
                                                    right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                    bottom: 0,
                                                    right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
                break
            case .ButtonImageTitleStyleCenterBottom:
                self.titleEdgeInsets = UIEdgeInsets(top: (selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                    left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                    bottom: -(selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                    right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                    bottom: 0,
                                                    right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
                break
                
            case .ButtonImageTitleStyleCenterUp:
                self.titleEdgeInsets = UIEdgeInsets(top: -(titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                                    left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                    bottom: (titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                                    right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                    bottom: 0,
                                                    right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
                break
                
            case .ButtonImageTitleStyleCenterDown:
                self.titleEdgeInsets = UIEdgeInsets(top: (imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                                    left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                    bottom: -(imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                                    right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                    bottom: 0,
                                                    right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
                break
                
            case .ButtonImageTitleStyleRightLeft:
                //图片在右，文字在左，距离按钮两边边距
                
                self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: -(titleRect.origin.x - padding),
                                                    bottom: 0,
                                                    right: (titleRect.origin.x - padding));
                
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: (selfWidth - padding - imageRect.origin.x - imageRect.size.width),
                                                    bottom: 0,
                                                    right: -(selfWidth - padding - imageRect.origin.x - imageRect.size.width));
                
                break
                
            case .ButtonImageTitleStyleLeftRight:
                //图片在左，文字在右，距离按钮两边边距
                
                self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: (selfWidth - padding - titleRect.origin.x - titleRect.size.width),
                                                    bottom: 0,
                                                    right: -(selfWidth - padding - titleRect.origin.x - titleRect.size.width));
                
                self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                    left: -(imageRect.origin.x - padding),
                                                    bottom: 0,
                                                    right: (imageRect.origin.x - padding));
                break
            default: break
                
            }
        }else{
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
