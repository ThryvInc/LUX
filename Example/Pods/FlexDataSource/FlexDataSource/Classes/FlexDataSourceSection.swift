//
//  FlexDataSourceSection.swift
//  FlexDataSource
//
//  Created by Elliot Schrock on 2/10/18.
//

import UIKit

open class FlexDataSourceSection: NSObject {
    open var title: String?
    open var items: [FlexDataSourceItem]?
}

public func itemsToSection(items: [FlexDataSourceItem]) -> FlexDataSourceSection {
    let section = FlexDataSourceSection()
    section.items = items
    return section
}

public func sectionsToDataSource(sections: [FlexDataSourceSection]?) -> FlexDataSource {
    let ds = FlexDataSource()
    ds.sections = sections
    return ds
}
