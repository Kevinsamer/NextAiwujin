//
//  NewsCustomLayout.swift
//  NextAiwujin
//
//  Created by DEV2018 on 2019/2/13.
//  Copyright © 2019 DEV2018. All rights reserved.
//

import UIKit

let twoCellWidth: CGFloat = (UIScreen.main.bounds.width - 15 * 4) / 3
let twoCellHeight: CGFloat = twoCellWidth * 1.2

let oneCellWidth: CGFloat = UIScreen.main.bounds.width
let oneCellHeight: CGFloat = oneCellWidth * 0.5

let headerWidth: CGFloat = UIScreen.main.bounds.width
let headerHeight: CGFloat = 200

protocol CustomLayoutDataSource: NSObjectProtocol {
    func treasureLayoutEachFrameForItemAtIndexPath(layout: NewsCustomLayout,indexPath: IndexPath) -> CGRect
    func collectionViewContentSize(layout: NewsCustomLayout) -> CGSize
}

class NewsCustomLayout: UICollectionViewFlowLayout {
    
    weak var dataSource: CustomLayoutDataSource?

    override func prepare() {
        super.prepare()
    }
    
    override var collectionViewContentSize: CGSize{
        get{
            return dataSource?.collectionViewContentSize(layout: self) ?? CGSize.zero
            
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attr.frame = dataSource?.treasureLayoutEachFrameForItemAtIndexPath(layout: self, indexPath: indexPath) ?? CGRect.zero
        return attr
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = [UICollectionViewLayoutAttributes]()
        
        for j in 0..<(collectionView?.numberOfSections)! {
            
            let indexPath: IndexPath = IndexPath(item: 0, section: j)
            
            attrs.append(layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)!)
            
            for i in 0..<(collectionView?.numberOfItems(inSection: j))! {
                let indexPath = IndexPath(item: i, section: j)
                attrs.append(layoutAttributesForItem(at: indexPath)!)
            }
        }
        return attrs
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionHeader {
            let attr = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            attr.frame = CGRect(x: 0,y: 0,width: headerWidth,height: headerHeight)
            return attr
        }
        return nil
    }
}
