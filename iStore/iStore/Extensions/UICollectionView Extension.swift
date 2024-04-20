
//
//  UICollectionView Extension.swift
//  iStore
//


import UIKit

extension UICollectionViewFlowLayout {
    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 12
        let availableWidth = view.bounds.width - (padding * 2)
        let itemWidth = (availableWidth - minimumItemSpacing) / 2
        let itemHeight = (215 / 170) * itemWidth  // Calculate height as 2/3 of the width

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
//        flowLayout.itemSize = CGSize(width: itemWidth, height: 217)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        // Set the spacing between cells in the same row
        flowLayout.minimumInteritemSpacing = minimumItemSpacing

        // Set the spacing between rows to be three times the padding
        flowLayout.minimumLineSpacing = padding * 3

        return flowLayout
    }
}
