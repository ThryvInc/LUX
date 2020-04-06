//
//  LUXDetailTableViewCell.swift
//  FunNet
//
//  Created by Elliot Schrock on 12/7/19.
//

import UIKit

public class LUXDetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
