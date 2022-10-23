//
//  EmployeesTableVCPresenterImpl.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 23.10.2022.
//

import UIKit

class EmployeesTableVCPresenterImpl: EmployeesTableVCPresenter {
    
    weak var delegate: EmployeesTableViewController?
    
    func viewShown() {
        setupViews()
        createNetworkConnectionMonitor()
    }
    
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Connection failure", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(alertAction)
        delegate?.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    private func setupViews() {
        guard let delegate = delegate else { return }
        delegate.view.addSubview(delegate.loadingDataIndicator)
        
        delegate.navigationController?.navigationBar.prefersLargeTitles = true
        
        delegate.loadingDataIndicator.translatesAutoresizingMaskIntoConstraints = false
        delegate.loadingDataIndicator.centerXAnchor.constraint(equalTo: delegate.view.centerXAnchor).isActive = true
        delegate.loadingDataIndicator.centerYAnchor.constraint(equalTo: delegate.view.centerYAnchor, constant: -(delegate.navigationController?.navigationBar.frame.height ?? 0)).isActive = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        
        delegate.tableView.refreshControl = refreshControl
        delegate.tableView.register(EmployeeCell.self, forCellReuseIdentifier: EmployeeCell.cellId)
        delegate.tableView.rowHeight = UITableView.automaticDimension
        delegate.tableView.estimatedRowHeight = 120
        delegate.tableView.backgroundColor = .secondarySystemBackground
    }
    
    // MARK: - Data processing
    @objc func fetchData() {
        delegate?.loadingDataIndicator.isHidden = false
        delegate?.loadingDataIndicator.startAnimating()
        delegate?.refreshControl?.endRefreshing()
        NetworkManager.shared.fetchData(forURL: APIProvider.shared.apiUrl) { companyItem in
            self.delegate?.companyItem = companyItem
            DispatchQueue.main.async {
                self.delegate?.loadingDataIndicator.stopAnimating()
                self.delegate?.tableView.reloadData()
                self.delegate?.navigationItem.title = self.delegate?.companyItem?.company.name
            }
        }
    }
    
    private func updateData() {
        if NetworkManager.shared.shouldUpdateData() {
            fetchData()
        } else {
            delegate?.refreshControl?.endRefreshing()
            delegate?.companyItem = CacheManager.shared.cachedData()
            delegate?.tableView.reloadData()
            delegate?.navigationItem.title = delegate?.companyItem?.company.name
        }
    }
    
    private func createNetworkConnectionMonitor() {
        NetworkManager.shared.createNetworkConnectionMonitor { status in
            DispatchQueue.main.async {
                switch status {
                case .satisfied:
                    self.delegate?.rightBarButtonItem = .wifi
                    self.updateData()
                case .unsatisfied:
                    self.delegate?.rightBarButtonItem = .wifiSlash
                    self.showAlert()
                    self.updateData()
                case .requiresConnection:
                    self.delegate?.rightBarButtonItem = .wifiExclamationMark
                default: break
                }
            }
        }
    }
}
