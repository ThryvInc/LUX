//
//  SearchTests.swift
//  LithoUXComponents_Tests
//
//  Created by Elliot Schrock on 10/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import Combine
@testable import LUX
import LithoOperators

class SearchTests: XCTestCase {

    func testSearch() {
        var count = 0
        
        let humansProperty = PassthroughSubject<[Human]?, Never>()
        let searcher = LUXSearcher<Human> { searchString, human in
            guard let search = searchString else {
                return true
            }
            return (human.name ?? "").contains(search)
        }
        
        let modelsSignal = humansProperty.skipNils().eraseToAnyPublisher()
        
        let listSignal = searcher.filteredPublisher(from: modelsSignal)
        
        let cancel = listSignal.sink { (humans) in
            count += 1
            switch count {
            case 1:
                XCTAssertEqual(humans.count, 3)
                break
            case 2:
                XCTAssertEqual(humans.count, 1)
                break
            case 3:
                XCTAssertEqual(humans.count, 3)
                break
            case 4:
                XCTAssertEqual(humans.count, 2)
                break
            case 5:
                XCTAssertEqual(humans.count, 2)
                XCTAssertEqual(searcher.searchText, "e")
                break
            case 6:
                XCTAssertEqual(humans.count, 3)
                break
            default:
                XCTAssertEqual(count, 0)
                break
            }
        }
        
        let humans = [Human(id: 1, name: "Neo"), Human(id: 2, name: "Morpheus"), Human(id: 3, name: "Trinity")]
        
        humansProperty.send(humans)
        
        searcher.updateSearch(text: "N")
        searcher.updateSearch(text: "")
        searcher.updateSearch(text: "e")
        
        humansProperty.send(humans)
        
        searcher.updateSearch(text: "")
        
        XCTAssertEqual(count, 6)
        cancel.cancel()
    }

    func testSearchString() {
        var count = 0
        
        let humansProperty = PassthroughSubject<[Human]?, Never>()
        let searcher = LUXSearcher<Human>(^\Human.name, .allMatchNilAndEmpty, .wordPrefixes)
        
        let modelsSignal = humansProperty.compactMap({ $0 }).eraseToAnyPublisher()
        
        let listSignal = searcher.filteredPublisher(from: modelsSignal)
        
        let cancel = listSignal.sink { (humans) in
            count += 1
            switch count {
            case 1:
                XCTAssertEqual(humans.count, 3)
                break
            case 2:
                XCTAssertEqual(humans.count, 1)
                break
            case 3:
                XCTAssertEqual(humans.count, 3)
                break
            case 4:
                XCTAssertEqual(humans.count, 1)
                break
            case 5:
                XCTAssertEqual(humans.count, 3)
                break
            case 6:
                XCTAssertEqual(humans.count, 1)
                break
            case 7:
                XCTAssertEqual(humans.count, 1)
                XCTAssertEqual(searcher.searchText, "N A")
                break
            case 8:
                XCTAssertEqual(humans.count, 3)
                break
            case 9:
                XCTAssertEqual(humans.count, 3)
                break
            default:
                XCTAssertEqual(count, 0)
                break
            }
        }
        
        let humans = [Human(id: 1, name: "Neo Anderson"), Human(id: 2, name: "Morpheus"), Human(id: 3, name: "Trinity")]
        
        humansProperty.send(humans)
        
        searcher.updateSearch(text: "N")
        searcher.updateSearch(text: "")
        searcher.updateSearch(text: "A")
        searcher.updateSearch(text: "")
        searcher.updateSearch(text: "N A")
        
        humansProperty.send(humans)
        
        searcher.updateSearch(text: "")
        
        XCTAssertEqual(count, 8)
        cancel.cancel()
    }
    
    func testWordPrefixes() {
        let search = "N A"
        let text = "Neo Anderson"
        
        XCTAssert(matchesWordsPrefixes(search, text))
    }
}
