//
//  LUXStandardCollectionViewCell.swift
//  LUX
//
//  Created by Elliot Schrock on 10/20/20.
//

import UIKit

open class LUXStandardCollectionViewCell: UICollectionViewCell {
    @IBOutlet public weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet public weak var button: UIButton!
    @IBOutlet public weak var cellImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var detailsLabel: UILabel!
    @IBOutlet public weak var titleBackgroundView: UIView!
    @IBOutlet public weak var enclosingView: UIView!
    
    @IBOutlet public weak var enclosingViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet public weak var enclosingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet public weak var enclosingViewTopConstraint: NSLayoutConstraint!
    @IBOutlet public weak var enclosingViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet public weak var titleLeadingMargin: NSLayoutConstraint!
    @IBOutlet public weak var titleTrailingMargin: NSLayoutConstraint!
    
    @IBOutlet public weak var imageAspectRatioConstraint: NSLayoutConstraint!
    
    @IBOutlet public weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet public weak var buttonWidthConstraint: NSLayoutConstraint!
    @IBOutlet public weak var buttonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet public weak var buttonTopConstraint: NSLayoutConstraint!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
