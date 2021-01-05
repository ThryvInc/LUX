//
//  FlexItemsTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 12/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
import Foundation
import FlexDataSource
import LithoOperators
@testable import LUX
import XCTest
import Prelude


class FlexItemTests: XCTestCase {
    func testFlexModelItem() {
        let setMainLabel: (Human, UITableViewCell) -> Void = {
            $1.detailTextLabel?.text = $0.name
        }
        let configurer: (Human, UITableViewCell) -> Void = setMainLabel
        let item = LUXModelItem<Human, UITableViewCell>(Human(id: 123, name: "Calvin Collins"), configurer)
        item.configureCell(UITableViewCell())
    }
    
    func testFlexTappable() {
        let setMainLabel: (Human, UITableViewCell) -> Void = {
            $1.detailTextLabel?.text = $0.name
        }
        let configurer: (Human, UITableViewCell) -> Void = setMainLabel
        var wasTapped: Bool = false
        let item = LUXTappableModelItem<Human, UITableViewCell>(model: Human(id: 123, name: "Calvin Collins"), configurer: configurer, tap: { _ in
            wasTapped = true
        })
        item.onTap()
        XCTAssert(wasTapped)
    }
    
    func testFlexSwipe() {
        let setMainLabel: (Human, UITableViewCell) -> Void = {
            $1.detailTextLabel?.text = $0.name
        }
        let configurer: (Human, UITableViewCell) -> Void = setMainLabel
        var wasSwiped: Bool = false
        var wasTapped: Bool = false
        let item = LUXSwipeTapModelItem<Human, UITableViewCell>(model: Human(id: 123, name: "Calvin Collins"), configurer: configurer, tap: { _ in
                wasTapped = true
        }, swipe: { _ in
            wasSwiped = true
        })
        item.onSwipe()
        item.onTap()
        XCTAssert(wasTapped && wasSwiped)
    }
}
