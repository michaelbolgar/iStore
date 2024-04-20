//
//  UICollectionView Extension.swift
//  iStore
//


import UIKit

enum UICollectionFlowLayout {

    static func createTwoColFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 12
                let availableWidth = view.bounds.width - (padding * 2)
                let itemWidth = (availableWidth - minimumItemSpacing) / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
//        flowLayout.itemSize = CGSize(width: 170, height: 217)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 217)
        
        return flowLayout
    }
}
