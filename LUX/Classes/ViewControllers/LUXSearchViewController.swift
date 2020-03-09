//
//  THUXSearchViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/17/19.
//

import UIKit
import Combine
import LithoOperators
import Prelude

open class LUXSearchViewController<T, U>: LUXMultiModelTableViewController<T>, UISearchBarDelegate {
    @IBOutlet open weak var searchBar: UISearchBar?
    @IBOutlet open weak var searchTopConstraint: NSLayoutConstraint?
    
    open var lastScreenYForAnimation: CGFloat?
    open var onSearch: (String) -> Void = { _ in }
    open var searcher: LUXSearcher<U>?
    
    open var shouldRefresh = true
    open var savedSearch: String?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if let y = lastScreenYForAnimation {
            searchTopConstraint?.constant = y
            tableView?.alpha = 0
        }
        
        searchBar?.delegate = self
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldRefresh = (savedSearch == nil || savedSearch == "")
        if let searchText = savedSearch {
            searchBar?.text = searchText
            searchBar?.resignFirstResponder()
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = self.lastScreenYForAnimation {
            UIView.animate(withDuration: 0.25, animations: {
                self.searchTopConstraint?.constant = 0
                self.tableView?.alpha = 1
            }) { _ in
                self.searchBar?.becomeFirstResponder()
            }
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        savedSearch = searchBar?.text
    }
    
    open override func refresh() {
        if shouldRefresh {
            super.refresh()
            searchBar?.resignFirstResponder()
            searchBar?.text = ""
        } else {
            shouldRefresh = true
        }
    }
    
    //MARK: - search
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onSearch(searchText)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

open class LUXSearcher<T> {
    @Published public var searchText: String?
    open var isIncluded: (String?, T) -> Bool
    
    public init(isIncluded: @escaping (String?, T) -> Bool) {
        self.isIncluded = isIncluded
    }
    
    open func updateSearch(text: String?) {
        searchText = text
    }
    
    open func filter(_ t: T) -> Bool {
        guard let text = searchText, text != "" else {
            return true
        }
        return isIncluded(text, t)
    }
    
    open func filter(text: String?, array: [T]) -> [T] {
        guard let t = text, t != "" else {
            return array
        }
        return array.filter(t >|> isIncluded)
    }
    
    open func filter(tuple: (String?, [T])) -> [T] {
        return tuple |> ~filter(text:array:)
    }
}

extension LUXSearcher {
    open func filteredPublisher(from modelsPublisher: AnyPublisher<[T], Never>) -> AnyPublisher<[T], Never> {
        return $searchText.combineLatest(modelsPublisher).map(filter(tuple:)).eraseToAnyPublisher()
    }
}
