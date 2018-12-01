//
//  MachineListViewController.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 28/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import UIKit

class MachineListViewController: UIViewController, AlertDisplayable {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var avatarButton: UIButton!
    @IBOutlet private var filterButtonsCollection: [UIButton]!
    @IBOutlet private weak var countLabel: UILabel!

    private var machines = [Machine]()
    private var filteredMachines = [Machine]()
    private var currentPage = 0
    private var total = 0 {
        didSet {
            countLabel.text = "\(total)"
        }
    }
    private var isFetchInProgress = false
    
    private let client = APIClient()
    private let request = APIRequest(username: "admin@boot.com", password: "admin")
    var totalCount: Int {
        return total
    }
    var currentCount: Int {
        return machines.count
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.startAnimating()
        setupSearchBar()
        setupTableView()
        setupFilterButtons()
        avatarButton.makeCircleBorders()
        fetchMachines()
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        guard let index = filterButtonsCollection.index(of: sender) else { return }
        filterButtonsCollection.forEach({ $0.isSelected = false })
        let item = filterButtonsCollection[index]
        item.isSelected = true
        print("\(item.titleLabel!.text ?? "") tapped")
    }
    
    
    private func fetchMachines() {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        client.fetchMachines(with: request, page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    print(response)
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.total = response.totalElements
                    self.machines.append(contentsOf: response.machines)
                    if response.page > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.machines)
                        self.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    // MARK: Setup UI
    private func setupFilterButtons() {
        filterButtonsCollection.enumerated().forEach({
            filterButtonsCollection[$0.offset].makeCircleBorders()
            filterButtonsCollection[$0.offset].makeBordersWith(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), width: 1.0)
            filterButtonsCollection[$0.offset].setBackgroundImage(UIImage.from(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), for: .normal)
            filterButtonsCollection[$0.offset].setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
            filterButtonsCollection[$0.offset].setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.02028449997, green: 0.6400577426, blue: 0.9848441482, alpha: 1)), for: .selected)
            filterButtonsCollection[$0.offset].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        })
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.register(UINib(nibName: "MachineTableViewCell", bundle: nil), forCellReuseIdentifier: "MachineCell")
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.isUserInteractionEnabled = true
    }
    

}

// MARK: TableView DataSource
extension MachineListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text != "" {
            return filteredMachines.count
        }
        return self.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MachineCell") as! MachineTableViewCell
        if self.searchBar.text != "" {
            if isLoadingCell(for: indexPath) {
                cell.configure(with: .none)
            } else {
                cell.configure(with: filteredMachines[indexPath.row])
            }
        } else {
            if isLoadingCell(for: indexPath) {
                cell.configure(with: .none)
            } else {
                cell.configure(with: machines[indexPath.row])
            }
        }
        return cell
    }
    
}

// MARK: TableView Delegate
extension MachineListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: TableViewHeader = .fromNib()
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}

// MARK: TableView DataSourcePrefetching(for pagination)
extension MachineListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            fetchMachines()
        }
    }
}

// MARK: - Searchbar delegate
extension MachineListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        let searchString = self.searchBar.text
        filteredMachines = machines.filter({ (item) -> Bool in
            let name: NSString = item.name as NSString
            let serialNumber: NSString = (item.serialNumber ?? "unknown") as NSString
            let ipAddress: NSString = (item.ipAddress ?? "unknown") as NSString
            let ipSubnetMask: NSString = (item.ipSubnetMask ?? "unknown") as NSString
            let fileredResult = (name.range(of: searchString!, options: .caseInsensitive).location != NSNotFound) ||
                (serialNumber.range(of: searchString!, options: .caseInsensitive).location != NSNotFound) ||
                (ipAddress.range(of: searchString!, options: .caseInsensitive).location != NSNotFound) ||
                (ipSubnetMask.range(of: searchString!, options: .caseInsensitive).location != NSNotFound)
            return fileredResult
        })
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        searchBar.showsCancelButton = false
        tableView.reloadData()
    }
    
}



// MARK: Helpers for pagination
private extension MachineListViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
    
    func calculateIndexPathsToReload(from newMachines: [Machine]) -> [IndexPath] {
        let startIndex = machines.count - newMachines.count
        let endIndex = startIndex + newMachines.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

