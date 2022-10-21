//
//  EmployeesTableViewController.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 18.10.2022.
//

import UIKit

class EmployeesTableViewController: UITableViewController {
    
    private let cellId = "cell"
    
    private var rightBarButtonItemImage: SystemImageNames = .wifi {
        didSet {
            DispatchQueue.main.async {
                let rightBarButtonItem = UIBarButtonItem(
                    image: UIImage(systemName: self.rightBarButtonItemImage.rawValue),
                    style: .plain,
                    target: EmployeesTableViewController.self,
                    action: nil)
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            }
        }
    }
    
    private var companyItem: CompanyItem? {
        didSet {
            if let newCompanyItem = companyItem {
                companyItem?.company.employees = newCompanyItem.company.employees.sorted {
                    $0.name < $1.name
                }
            }
        }
    }
    
    private let loadingDataIndicator: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView()
        actInd.isHidden = true
        actInd.hidesWhenStopped = true
        return actInd
    }()
    
    private let internetConnectionIndicator: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView()
        actInd.isHidden = true
        actInd.hidesWhenStopped = true
        return actInd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingDataIndicator)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadingDataIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingDataIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingDataIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(navigationController?.navigationBar.frame.height ?? 0)).isActive = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.backgroundColor = .secondarySystemBackground
        
        createNetworkConnectionMonitor()
       
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Connection failure", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(alertAction)
        navigationController?.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyItem?.company.employees.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EmployeeCell
       
        cell.employee = companyItem?.company.employees[indexPath.row]
        cell.backgroundColor = .secondarySystemBackground
        cell.selectionStyle = .none
        return cell
    }
    
}

// MARK: - Data processing
extension EmployeesTableViewController {
    
    @objc private func fetchData() {
        loadingDataIndicator.isHidden = false
        loadingDataIndicator.startAnimating()
        refreshControl?.endRefreshing()
        NetworkManager.shared.fetchData(forURL: APIProvider.shared.apiUrl) { companyItem in
            self.companyItem = companyItem
            DispatchQueue.main.async {
                self.loadingDataIndicator.stopAnimating()
                self.tableView.reloadData()
                self.navigationItem.title = self.companyItem?.company.name
            }
        }
    }
    
    private func updateData() {
        if NetworkManager.shared.shouldUpdateData() {
            fetchData()
        } else {
            refreshControl?.endRefreshing()
            companyItem = CacheManager.shared.cachedData()
            tableView.reloadData()
            navigationItem.title = companyItem?.company.name
        }
    }
    
    private func createNetworkConnectionMonitor() {
        NetworkManager.shared.createNetworkConnectionMonitor { status in
            DispatchQueue.main.async {
                switch status {
                case .satisfied:
                    self.rightBarButtonItemImage = .wifi
                    self.updateData()
                case .unsatisfied:
                    self.rightBarButtonItemImage = .wifiSlash
                    self.showAlert()
                    self.updateData()
                case .requiresConnection:
                    self.rightBarButtonItemImage = .wifiExclamationMark
                default: break
                }
            }
        }
    }
}
