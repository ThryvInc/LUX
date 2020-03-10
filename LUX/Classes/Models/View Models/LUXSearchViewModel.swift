//
//  LUXSearchViewModel.swift
//  LUX
//
//  Created by Elliot Schrock on 3/10/20.
//

import UIKit
import Combine
import Prelude
import LithoOperators

open class LUXSearchViewModel<U>: NSObject, UISearchBarDelegate {
    open var onSearch: (String) -> Void = { _ in }
    open var searcher: LUXSearcher<U>?
    open var savedSearch: String?
    
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
    
    public init(_ modelToString: @escaping (T) -> String?, _ nilAndEmptyStrategy: NilAndEmptyMatchStrategy, _ matchStrategy: MatchStrategy) {
        let nilMatcher: () -> Bool
        let emptyMatcher: () -> Bool
        switch nilAndEmptyStrategy {
        case .allMatchNilAndEmpty:
            nilMatcher = returnTrue
            emptyMatcher = returnTrue
        case .allMatchNilNoneMatchEmpty:
            nilMatcher = returnFalse
            emptyMatcher = returnTrue
        case .noneMatchNilAllMatchEmpty:
            nilMatcher = returnFalse
            emptyMatcher = returnTrue
        case .noneMatchNilNoneMatchEmpty:
            nilMatcher = returnFalse
            emptyMatcher = returnFalse
        }
        
        let matcher: (String, String) -> Bool
        switch matchStrategy {
        case .prefix:
            matcher = matchesPrefix(_:_:)
        case .wordPrefixes:
            matcher = matchesWordsPrefixes(_:_:)
        case .contains:
            matcher = matchesWithContains(_:_:)
        }
        
        isIncluded = { search, t in defaultIsIncluded(search, t, modelToString, nilMatcher, emptyMatcher, matcher)}
    }
    
    public init(_ modelToString: @escaping (T) -> String, _ nilAndEmptyStrategy: NilAndEmptyMatchStrategy, _ matchStrategy: MatchStrategy) {
        let nilMatcher: () -> Bool
        let emptyMatcher: () -> Bool
        switch nilAndEmptyStrategy {
        case .allMatchNilAndEmpty:
            nilMatcher = returnTrue
            emptyMatcher = returnTrue
        case .allMatchNilNoneMatchEmpty:
            nilMatcher = returnFalse
            emptyMatcher = returnTrue
        case .noneMatchNilAllMatchEmpty:
            nilMatcher = returnFalse
            emptyMatcher = returnTrue
        case .noneMatchNilNoneMatchEmpty:
            nilMatcher = returnFalse
            emptyMatcher = returnFalse
        }
        
        let matcher: (String, String) -> Bool
        switch matchStrategy {
        case .prefix:
            matcher = matchesPrefix(_:_:)
        case .wordPrefixes:
            matcher = matchesWordsPrefixes(_:_:)
        case .contains:
            matcher = matchesWithContains(_:_:)
        }
        
        isIncluded = { search, t in defaultIsIncluded(search, t, modelToString, nilMatcher, emptyMatcher, matcher)}
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

func defaultIsIncluded<T>(_ search: String?, _ t: T, _ modelToString: (T) -> String?, _ nilMatcher: () -> Bool, _ emptyMatcher: () -> Bool, _ matcher: (String, String) -> Bool) -> Bool {
    if let searchText = search {
        if searchText.isEmpty {
            return emptyMatcher()
        }
        if let text = modelToString(t) {
            return matcher(searchText, text)
        } else {
            return nilMatcher()
        }
    } else {
        return nilMatcher()
    }
}

func defaultIsIncluded<T>(_ search: String?, _ t: T, _ modelToString: (T) -> String, _ nilMatcher: () -> Bool, _ emptyMatcher: () -> Bool, _ matcher: (String, String) -> Bool) -> Bool {
    if let searchText = search {
        if searchText.isEmpty {
            return emptyMatcher()
        }
        return matcher(searchText, modelToString(t))
    } else {
        return nilMatcher()
    }
}

public enum MatchStrategy {
    case prefix
    case wordPrefixes
    case contains
}

public enum NilAndEmptyMatchStrategy {
    case allMatchNilAndEmpty
    case allMatchNilNoneMatchEmpty
    case noneMatchNilAllMatchEmpty
    case noneMatchNilNoneMatchEmpty
}

public func returnTrue() -> Bool { true }
public func returnFalse() -> Bool { true }

public func matchesWithContains(_ search: String, _ text: String) -> Bool {
    return text.contains(search)
}

public func matchesPrefix(_ search: String, _ text: String) -> Bool {
    return text.prefix(search.count) == search
}

public func matchesWordsPrefixes(_ search: String, _ text: String) -> Bool {
    let textWords = text.components(separatedBy: .nonBaseCharacters)
    let searchWords = search.components(separatedBy: .nonBaseCharacters)
    for word in searchWords {
        var foundMatch = false
        for textWord in textWords {
            if textWord.prefix(word.count) == word {
                foundMatch = true
            }
        }
        if !foundMatch {
            return false
        }
    }
    return true
}
