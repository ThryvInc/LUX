//
//  LUXSearchCollectionViewController.swift
//  LUX
//
//  Created by Elliot Schrock on 10/25/20.
//

import fuikit

open class LUXSearchCollectionViewController<U>: FUIViewController {
    @IBOutlet open weak var collectionView: UICollectionView!
    @IBOutlet open weak var searchBar: UISearchBar?
    @IBOutlet open weak var searchTopConstraint: NSLayoutConstraint?
    
    open var collectionViewModel: LUXCollectionViewModel?
    open var searchViewModel: LUXSearchViewModel<U>? = LUXSearchViewModel<U>()
    open var shouldRefresh = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar?.delegate = searchViewModel?.searchBarDelegate
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldRefresh = (searchViewModel?.savedSearch == nil || searchViewModel?.savedSearch == "")
        if let searchText = searchViewModel?.savedSearch {
            searchBar?.text = searchText
            searchBar?.resignFirstResponder()
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let vm = collectionViewModel as? LUXRefreshableCollectionViewModel, shouldRefresh {
            vm.refresh()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchViewModel?.savedSearch = searchBar?.text
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
