//
//  CollectionViewModelTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 12/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
import LithoOperators
import FunNet


let setBackground: (UICollectionViewCell) -> Void = set(\UICollectionViewCell.backgroundColor, .gray)
let configurer: (Human, UICollectionViewCell) -> Void = ignoreFirstArg(f: setBackground)


class CollectionViewModelItemTests: XCTestCase {
    
    

    func testStandardViewModelItem() {
        let vm = LUXModelCollectionItem(Human(id: 123, name: "Calvin Collins"), configurer)
        let cell = UICollectionViewCell()
        vm.configureCell(cell)
        XCTAssert(cell.backgroundColor == .gray)
    }

    func testTappableViewModelItem() {
        var wasTapped: Bool = false
        let vm = LUXTappableModelCollectionItem(model: Human(id: 123, name: "Calvin Collins"), configurer: configurer, tap: {
            wasTapped = true
            XCTAssert($0.name == "Calvin Collins")
        })
        vm.onTap()
        XCTAssert(wasTapped)
    }
    
    func testButtonViewModelItem() {
        var cellTapped: Bool = false
        var buttonTapped: Bool = false
        let vm = LUXButtonTappableModelCollectionItem(model: Human(id: 123, name: "Calvin Collins"), configurer: configurer, tap: { _ in
            cellTapped = true
        }, buttonPressed: { buttonTapped = true })
        vm.onButtonPressed()
        vm.onTap()
        XCTAssert(cellTapped && buttonTapped)
    }
    
    func testCollectionViewModel() {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: .init())
        let vm = LUXCollectionViewModel()
        vm.collectionView = collectionView
        XCTAssert(vm.collectionView != nil)
    }
    
    func testRefreshableViewModel() {
        let call: CombineNetCall = CombineNetCall(configuration: ServerConfiguration(host: "https://lithobyte.co", apiRoute: "/v1/api"), Endpoint())
        call.firingFunc = { $0.responder?.data = json.data(using: .utf8) }
        let refresher = LUXCallRefresher(call)
        let vm = LUXRefreshableCollectionViewModel(refresher)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: .init())
        vm.collectionView = collection
        vm.configureCollectionView()
        vm.setupEndRefreshing(from: call)
        vm.refresh()
    }
    
    func testCellStyle() {
        struct CellModel {
            let name: String?
            let desc: String?
            var imageURL: String? = nil
        }
        
        let cell: LUXStandardCollectionViewCell = LUXStandardCollectionViewCell()
        let model = CellModel(name: "Calvin", desc: "A great tester.")
        let cellConfigurer: (CellModel, UICollectionViewCell) -> Void = defaultCellStyle(titleKeyPath: \CellModel.name, detailsKeyPath: \CellModel.desc, imageUrlKeyPath: \CellModel.imageURL)
        let enclosingView: UIView = UIView()
        let titleBackground: UIView = UIView()
        let imageView: UIImageView = UIImageView()
        let titleLabel: UILabel = UILabel()
        let detailsLabel: UILabel = UILabel()
        let button = UIButton()
        cell.button = button
        cell.enclosingView = enclosingView
        cell.titleBackgroundView = titleBackground
        cell.cellImageView = imageView
        cell.titleLabel = titleLabel
        cell.detailsLabel = detailsLabel
        cellConfigurer(model, cell)
        
        XCTAssert(cell.titleLabel.text == model.name)
        XCTAssert(cell.detailsLabel.text == model.desc)
    }
    
    func testCollectionViewDelegate() {
        
        var wasSelected: Bool = false
        var willDisplay: Bool = false
        
        let onWillDisplayCell: (UICollectionView, UICollectionViewCell, IndexPath) -> Void = {
            _, _, _ in
            willDisplay = !willDisplay
        }
        
        let onDidSelectItem: (UICollectionView, IndexPath) -> Void = { _, _ in
            wasSelected = !wasSelected
        }
        
        let delegate = LUXCollectionDelegate(onDidSelectItem: onDidSelectItem, onWillDisplayCell: onWillDisplayCell)
        
        delegate.onWillDisplayCell(UICollectionView(frame: .zero, collectionViewLayout: .init()), UICollectionViewCell(), IndexPath(row: 0, section: 0))
        delegate.onDidSelectItem(UICollectionView(frame: .zero, collectionViewLayout: .init()), IndexPath(row: 0, section: 0))
        
        XCTAssert(wasSelected && willDisplay)
        
        let delegateTwo = LUXCollectionDelegate()
        delegateTwo.onDidSelectItem = onDidSelectItem
        delegateTwo.onWillDisplayCell = onWillDisplayCell
        
        delegateTwo.onWillDisplayCell(UICollectionView(frame: .zero, collectionViewLayout: .init()), UICollectionViewCell(), IndexPath(row: 0, section: 0))
        delegateTwo.onDidSelectItem(UICollectionView(frame: .zero, collectionViewLayout: .init()), IndexPath(row: 0, section: 0))
        
        XCTAssert(!(wasSelected || willDisplay))
        
        
    }
}
