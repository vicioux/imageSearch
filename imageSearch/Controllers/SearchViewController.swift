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
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    var viewModel: SearchViewModelType!
    let searchController = UISearchController(searchResultsController: nil)
    var debouncer: Debouncer = Debouncer(timeInterval: 0.25)

    var selectedIndexPath: IndexPath?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel()
        setupSearch()
        setupTable()
        setupEmptyState()
        
        debouncer.handler = {
            self.loadData()
        }
    }
    
    private func loadData() {
        viewModel.loadGallery { [weak self] (success) in
            self?.removeLoadMore()
            self?.setupEmptyState()
            
            if !success {
                self?.showShareFailAlert()
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
    
    private func setupEmptyState() {
        emptyStateView.isHidden = !viewModel.showEmptyState()
        emptyStateLabel.text = viewModel.getEmptyStateMessage()
    }
    
    private func addLoadMore() {
        if tableView.tableFooterView == nil {
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            tableView.tableFooterView = spinner
        }
        
        tableView.tableFooterView?.isHidden = false
    }
    
    private func removeLoadMore() {
        tableView.tableFooterView?.isHidden = true
    }

    private func showShareFailAlert() {
        let alert = UIAlertController(title: "Opsss!", message: "Something went wrong, please try later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        if let item = viewModel.getItemAt(index: indexPath.row) {
            let vm = ImageTableViewModel(withGalleryItem: item)
            let vc = DetailViewController(withViewModel: vm)
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = viewModel.getItemsCount() - 1
        if indexPath.row == lastElement {
            viewModel.moveToNextPage()
            loadData()
            addLoadMore()
        }
    }
}

// MARK: - Table View UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func setupSearch() {
        title = "Start Searching..."
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Images"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.resetText()
        viewModel.resetPage()
        viewModel.setText(text)
        debouncer.renewInterval()
    }
}

// MARK: ExpandingTransitionPresentingViewController
extension SearchViewController: ExpandingTransitionPresentingViewController
{
    func expandingTransitionTargetViewForTransition(_ transition: ExpandingCellTransition) -> UIView! {
        guard let indexPath = selectedIndexPath else { return nil }
        return tableView.cellForRow(at: indexPath)
    }
}
