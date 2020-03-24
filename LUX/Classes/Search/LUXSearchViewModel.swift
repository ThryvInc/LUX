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
    open var onIncrementalSearch: (String) -> Void = { _ in }
    open var onFullSearch: (String) -> Void = { _ in }
    open var searcher: LUXSearcher<U>?
    open var savedSearch: String?
    
    //MARK: - search
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onIncrementalSearch(searchText)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let searchText = searchBar.text {
            onFullSearch(searchText)
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

open class LUXSearcher<T> {
    @Published public var incrementalSearchText: String?
    @Published public var searchText: String?
    open var isIncluded: (String?, T) -> Bool
    
    public init(isIncluded: @escaping (String?, T) -> Bool) {
        self.isIncluded = isIncluded
    }
    
    public init(_ modelToString: @escaping (T) -> String?, _ nilAndEmptyStrategy: NilAndEmptyMatchStrategy, _ matchStrategy: MatchStrategy, _ isCaseSensitive: Bool = false) {
        let (nilMatcher, emptyMatcher) = nilAndEmptyMatchers(for: nilAndEmptyStrategy)
        let match = matcher(for: matchStrategy)
        
        if isCaseSensitive {
            isIncluded = { search, t in defaultIsIncluded(search, t, modelToString, nilMatcher, emptyMatcher, match)}
        } else {
            isIncluded = { search, t in
                defaultIsIncluded(search?.lowercased(), t, modelToString >>> lowercased(string:), nilMatcher, emptyMatcher, match)
            }
        }
    }
    
    public init(_ modelToString: @escaping (T) -> String, _ nilAndEmptyStrategy: NilAndEmptyMatchStrategy, _ matchStrategy: MatchStrategy, _ isCaseSensitive: Bool = false) {
        let (nilMatcher, emptyMatcher) = nilAndEmptyMatchers(for: nilAndEmptyStrategy)
        let match = matcher(for: matchStrategy)
        
        if isCaseSensitive {
            isIncluded = { search, t in defaultIsIncluded(search, t, modelToString, nilMatcher, emptyMatcher, match)}
        } else {
            isIncluded = { search, t in
                defaultIsIncluded(search?.lowercased(), t, modelToString >>> lowercased(string:), nilMatcher, emptyMatcher, match)
            }
        }
    }
    
    open func updateIncrementalSearch(text: String?) {
        incrementalSearchText = text
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
    open func filteredIncrementalPublisher(from modelsPublisher: AnyPublisher<[T], Never>) -> AnyPublisher<[T], Never> {
        return $incrementalSearchText.combineLatest(modelsPublisher).map(filter(tuple:)).eraseToAnyPublisher()
    }
}

func lowercased(string: String) -> String { return string.lowercased() }
func lowercased(string: String?) -> String? { return string?.lowercased() }

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

func matcher(for strategy: MatchStrategy) -> (String, String) -> Bool {
    let matcher: (String, String) -> Bool
    switch strategy {
    case .prefix:
        matcher = matchesPrefix(_:_:)
    case .wordPrefixes:
        matcher = matchesWordsPrefixes(_:_:)
    case .contains:
        matcher = matchesWithContains(_:_:)
    }
    return matcher
}

public enum CaseSensitivity {
    case caseInsensitive
    case caseSensitive
}

public enum NilAndEmptyMatchStrategy {
    case allMatchNilAndEmpty
    case allMatchNilNoneMatchEmpty
    case noneMatchNilAllMatchEmpty
    case noneMatchNilNoneMatchEmpty
}

public func returnTrue() -> Bool { true }
public func returnFalse() -> Bool { true }

func nilAndEmptyMatchers(for strategy: NilAndEmptyMatchStrategy) -> (() -> Bool, () -> Bool) {
    let nilMatcher: () -> Bool
    let emptyMatcher: () -> Bool
    switch strategy {
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
    return (nilMatcher, emptyMatcher)
}

public func matchesWithContains(_ search: String, _ text: String) -> Bool {
    return text.contains(search)
}

public func matchesPrefix(_ search: String, _ text: String) -> Bool {
    return text.prefix(search.count) == search
}

public func matchesWordsPrefixes(_ search: String, _ text: String) -> Bool {
    let textWords = text.components(separatedBy: CharacterSet.letters.inverted)
    let searchWords = search.components(separatedBy: CharacterSet.letters.inverted)
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

public func defaultOnSearch<T>(_ searcher: LUXSearcher<T>, _ call: CombineNetCall, _ refresher: Refreshable? = nil, paramName: String = "query") -> (String) -> Void {
    return { text in
        searcher.updateSearch(text: text)
        call.endpoint.getParams.updateValue(text, forKey: paramName)
        if let refresher = refresher {
            refresher.refresh()
        } else {
            call.fire()
        }
    }
}

public func onWillReturnToSearch<T>(_ searchBar: UISearchBar?, _ searchViewModel: LUXSearchViewModel<T>?) {
    if let searchText = searchViewModel?.savedSearch {
        searchBar?.text = searchText
        searchBar?.resignFirstResponder()
    }
}

public func saveSearch<T>(_ searchBar: UISearchBar?, _ searchViewModel: LUXSearchViewModel<T>?) {
    searchViewModel?.savedSearch = searchBar?.text
}
