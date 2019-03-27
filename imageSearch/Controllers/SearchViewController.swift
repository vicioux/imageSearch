//
//  SearchViewController.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/26/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: SearchViewModelType!
    let searchController = UISearchController(searchResultsController: nil)
    var debouncer: Debouncer = Debouncer(timeInterval: 0.25)

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel()
        setupSearch()
        setupTable()
        
        debouncer.handler = {
            self.loadData()
        }
    }
    
    private func loadData() {
        viewModel.loadGallery { [weak self] (success) in
            if !success {
                // show something
                return
            }
            self?.tableView.reloadData()
        }
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(ImageTableViewCell.self)
    }
    

}

// MARK: - Table View UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let item = viewModel.getItemAt(index: indexPath.row) {
            let vm = ImageTableViewModel(withGalleryItem: item)
            cell.load(withViewModel: vm)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = viewModel.getItemsCount() - 1
        if indexPath.row == lastElement {
            viewModel.moveToNextPage()
            loadData()
        }
    }
}

// MARK: - Table View UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Images"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.resetText()
        viewModel.resetPage()
        viewModel.setText(text)
        debouncer.renewInterval()
    }
    
}
