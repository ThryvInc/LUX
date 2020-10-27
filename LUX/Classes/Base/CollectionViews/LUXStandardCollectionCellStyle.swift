//
//  LUXStandardCollectionCellStyle.swift
//  LUX
//
//  Created by Elliot Schrock on 10/21/20.
//

import UIKit
import SDWebImage

public func defaultCellStyle<T>(titleKeyPath: KeyPath<T, String>, detailsKeyPath: KeyPath<T, String>, imageUrlKeyPath: KeyPath<T, String>) -> (T, UICollectionViewCell) -> Void {
    return {
        if let cell = $1 as? LUXStandardCollectionViewCell {
            defaultCellStyle(cell)
            cell.titleLabel.text = $0[keyPath: titleKeyPath]
            cell.detailsLabel.text = $0[keyPath: detailsKeyPath]
            cell.button.isHidden = true
            cell.cellImageView.image = nil
            cell.cellImageView.sd_setImage(with: URL(string: $0[keyPath: imageUrlKeyPath]), completed: nil)
        }
    }
}

public func defaultCellStyle<T>(titleKeyPath: KeyPath<T, String?>, detailsKeyPath: KeyPath<T, String?>, imageUrlKeyPath: KeyPath<T, String?>) -> (T, UICollectionViewCell) -> Void {
    return {
        if let cell = $1 as? LUXStandardCollectionViewCell {
            defaultCellStyle(cell)
            cell.titleLabel.text = $0[keyPath: titleKeyPath]
            cell.detailsLabel.text = $0[keyPath: detailsKeyPath]
            cell.button.isHidden = true
            cell.cellImageView.image = nil
            if let imageUrlString = $0[keyPath: imageUrlKeyPath] {
                cell.cellImageView.sd_setImage(with: URL(string: imageUrlString), completed: nil)
            }
        }
    }
}

public func defaultCellStyle(_ cell: LUXStandardCollectionViewCell) {
    let radius: CGFloat = 6.0
    
    cell.enclosingView.layer.cornerRadius = radius
    cell.enclosingView.layer.shadowColor = UIColor.black.cgColor
    cell.enclosingView.layer.shadowRadius = 4
    cell.enclosingView.layer.shadowOffset =  CGSize(width: 2, height: 2)
    cell.enclosingView.layer.shadowOpacity = 0.2
    cell.titleBackgroundView.layer.cornerRadius = radius
    cell.cellImageView.layer.cornerRadius = radius
}
