//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 31/08/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UpComingTableViewCell.self, forCellReuseIdentifier: UpComingTableViewCell.reuseIdentifer)
        return tableView
    }()
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchBar.tintColor = .label
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text
        guard let query = query, query.count > 3, let searchResultVC = searchController.searchResultsController as? SearchResultViewController else{return}
        searchResultVC.searchMoviesNetworkRequest(query: query)
    }
    
    
}

