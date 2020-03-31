//
//  TestHelpers.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 12/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Combine
import FlexDataSource
import LUX

struct Human: Codable {
    var id: Int = -1
    var name: String?
}

let neo = Human(id: 1, name: "Neo")

let firstPageOfHumans = """
[{"id":1}]
"""
let secondPageOfHumans = """
[{"id":2}]
"""
let thirdPageOfHumans = """
[{"id":3}]
"""

class SomeClass {
    @Published var property = 1
}

func humanConfigurer(_ human: Human) -> (UITableViewCell) -> Void {
    return {
        if let name = human.name {
            $0.textLabel?.text = name
        }
    }
}

func configurerToItem(configurer: @escaping (UITableViewCell) -> Void) -> FlexDataSourceItem { return FunctionalFlexDataSourceItem<LUXDetailTableViewCell>(identifier: "cell", configurer) }
