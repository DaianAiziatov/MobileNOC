//
//  MachineListViewController.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 28/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import UIKit

class MachineListViewController: UIViewController, AlertDisplayer {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Left bar outlets
    @IBOutlet weak var avatarButton: UIButton! {
        didSet {
            avatarButton.makeCircleBorders()
        }
    }
    
    // MARK: Top bar outlets
    @IBOutlet var fileterButtonsCollection: [UIButton]! {
        didSet {
            fileterButtonsCollection.enumerated().forEach({
                fileterButtonsCollection[$0.offset].makeCircleBorders()
                fileterButtonsCollection[$0.offset].makeBordersWith(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), width: 1.0)
            })
        }
    }
    
    @IBOutlet weak var countLabel: UILabel!

    
    
    
    private var machines = [Machine]()
    private var filteredMachines = [Machine]()
    private var currentPage = 0
    private var total = 0 {
        didSet {
            countLabel.text = "\(total)"
        }
    }
    private var isFetchInProgress = false
    
    let client = APIClient()
    let request = APIRequest(username: "admin@boot.com", password: "admin")
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return machines.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MachineTableViewCell", bundle: nil), forCellReuseIdentifier: "MachineCell")

        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.isUserInteractionEnabled = true
        
        fetchMachines()
    }
    
    func fetchMachines() {
        // 1
        guard !isFetchInProgress else {
            return
        }
        
        // 2
        isFetchInProgress = true
        
        client.fetchMachines(with: request, page: currentPage) { result in
            switch result {
            // 3
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    print(error)
                    //self.delegate?.onFetchFailed(with: error.reason)
                }
            // 4
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
    
    private func calculateIndexPathsToReload(from newMachines: [Machine]) -> [IndexPath] {
        let startIndex = machines.count - newMachines.count
        let endIndex = startIndex + newMachines.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

}

extension MachineListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text != "" {
            return filteredMachines.count
        }
        return self.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MachineCell") as! MachineTableViewCell
        // 2
        if self.searchBar.text != "" {
            if isLoadingCell(for: indexPath) {
                
            } else {
                cell.serverNameLabel?.text = filteredMachines[indexPath.row].name
                cell.serialNumberLabel?.text = filteredMachines[indexPath.row].serialNumber ?? "unknown"
                cell.ipAddressLabel?.text = filteredMachines[indexPath.row].ipAddress ?? "unknown"
                cell.ipSubnetMaskLabel?.text = filteredMachines[indexPath.row].ipSubnetMask ?? "unknown"
                cell.statusId = filteredMachines[indexPath.row].statusId
                return cell
            }
            
        } else {
            if isLoadingCell(for: indexPath) {
                
            } else {
                cell.serverNameLabel?.text = machines[indexPath.row].name
                cell.serialNumberLabel?.text = machines[indexPath.row].serialNumber ?? "unknown"
                cell.ipAddressLabel?.text = machines[indexPath.row].ipAddress ?? "unknown"
                cell.ipSubnetMaskLabel?.text = machines[indexPath.row].ipSubnetMask ?? "unknown"
                cell.statusId = machines[indexPath.row].statusId
                return cell
            }
        }
        return cell
        
    }
    
}

extension MachineListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: TableViewHeader = .fromNib()
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}


extension MachineListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            fetchMachines()
        }
    }
}

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
        // 1
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            //indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        // 2
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        //indicatorView.stopAnimating()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
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

