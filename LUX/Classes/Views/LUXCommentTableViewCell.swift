//
//  THUXCommentTableViewCell.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/10/18.
//

import UIKit

class LUXCommentTableViewCell: UITableViewCell {
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commentTextLabel: UILabel!
    
    @IBOutlet var imageTopMargin: NSLayoutConstraint!
    @IBOutlet var imageLeftMargin: NSLayoutConstraint!
    @IBOutlet var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet var imageRightMargin: NSLayoutConstraint!
    @IBOutlet var imageBottomMargin: NSLayoutConstraint!
    
    @IBOutlet var commentTopMargin: NSLayoutConstraint!
    @IBOutlet var commentBottomMargin: NSLayoutConstraint!
    @IBOutlet var commentRightMargin: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
