//
//  LUXTableViewCellTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 1/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
class LUXTableViewCellTests: XCTestCase {

    func testCommentTVC() {
        let bundle = Bundle(for: LUXCommentTableViewCell.self)
        guard let cell = bundle.loadNibNamed("LUXCommentTableViewCell", owner: nil, options: [:])?.first as? LUXCommentTableViewCell else { return XCTFail("Could not instantiate") }
        XCTAssert(cell.userNameLabel.frame.minX > cell.userImageView.frame.maxX)
    }
    
    func testSearchTVC() {
        let bundle = Bundle(for: LUXSearchTableViewCell.self)
        guard let cell = bundle.loadNibNamed("LUXSearchTableViewCell", owner: nil, options: [:])?.first as? LUXSearchTableViewCell else { return XCTFail("Could not instantiate") }
        cell.setSelected(true, animated: true)
    }
    
    func testDetailTVC() {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.register(LUXDetailTableViewCell.self, forCellReuseIdentifier: "detail")
        guard let _ = tableView.dequeueReusableCell(withIdentifier: "detail") as? LUXDetailTableViewCell else { return XCTFail("Could not instantiate") }
    }
    
    func testRightDetailTVC() {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.register(LUXRightDetailTableViewCell.self, forCellReuseIdentifier: "rightDetail")
        guard let _ = tableView.dequeueReusableCell(withIdentifier: "rightDetail") as? LUXRightDetailTableViewCell else { return XCTFail("Could not instantiate") }
    }

    func testLeftDetailTVC() {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.register(LUXLeftDetailTableViewCell.self, forCellReuseIdentifier: "leftDetail")
        guard let _ = tableView.dequeueReusableCell(withIdentifier: "leftDetail") as? LUXLeftDetailTableViewCell else { return XCTFail("Could not instantiate") }
    }
}
