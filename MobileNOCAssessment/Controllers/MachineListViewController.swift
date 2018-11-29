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
    
    private var machines: [Machine] = []
    private var currentPage = 0
    private var total = 0
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
    
    func machine(at index: Int) -> Machine {
        return machines[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
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
        // 1
        return self.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "machineCell", for: indexPath)
        
        
        // 2
        if isLoadingCell(for: indexPath) {
            
        } else {
            cell.textLabel?.text = machines[indexPath.row].name
            cell.detailTextLabel?.text = machines[indexPath.row].serialNumber ?? "unknown"
        }
        return cell
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



