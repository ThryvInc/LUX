//
//  LUXCollectionDelegate.swift
//  LUX
//
//  Created by Elliot Schrock on 10/20/20.
//

import UIKit

open class LUXCollectionDelegate: NSObject, UICollectionViewDelegate {
    public var onDidSelectItem: (UICollectionView, IndexPath) -> Void
    public var onWillDisplayCell: (UICollectionView, UICollectionViewCell, IndexPath) -> Void
    
    public  init(onDidSelectItem: @escaping (UICollectionView, IndexPath) -> Void = { _, _ in },
                 onWillDisplayCell: @escaping (UICollectionView, UICollectionViewCell, IndexPath) -> Void = { _, _, _ in }) {
        self.onDidSelectItem = onDidSelectItem
        self.onWillDisplayCell = onWillDisplayCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onDidSelectItem(collectionView, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        onWillDisplayCell(collectionView, cell, indexPath)
    }
}
