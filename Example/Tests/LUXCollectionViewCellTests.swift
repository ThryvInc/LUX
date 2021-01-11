//
//  LUXCollectionViewCellTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 1/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
class LUXCollectionViewCellTests: XCTestCase {

    func testStandardCVC() {
        let bundle = Bundle(for: LUXStandardCollectionViewCell.self)
        guard let _ = bundle.loadNibNamed("LUXStandardCollectionViewCell", owner: nil, options: [:])?.first as? LUXStandardCollectionViewCell else { return XCTFail() }
        
    }

}
