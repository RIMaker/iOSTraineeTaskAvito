//
//  EmployeesTableViewController.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 18.10.2022.
//

import UIKit

protocol EmployeesTableViewController: AnyObject {
    func setRightBarButtonItem(systemSymbol: SystemSymbol)
    func reloadData()
    func startLoadingDataIndicator()
    func stopRefreshControl()
    func showAlert(withTitle title: String, withMessage message: String?)
}

class EmployeesTableViewControllerImpl: UITableViewController {
    
    var presenter: EmployeesTableVCPresenter?
    
    lazy private var rightBarButtonItem: SystemSymbol = .wifi {
        didSet {
            DispatchQueue.main.async {
                let rightBarButton = UIBarButtonItem(
                    image: UIImage(systemName: self.rightBarButtonItem.rawValue),
                    style: .plain,
                    target: EmployeesTableViewController.self,
                    action: nil)
                self.navigationItem.rightBarButtonItem = rightBarButton
            }
        }
    }
    
    lazy private var loadingDataIndicator: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView()
        actInd.isHidden = true
        actInd.hidesWhenStopped = true
        return actInd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        presenter?.viewShown()
       
    }
    
    private func setupViews() {
        view.addSubview(loadingDataIndicator)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadingDataIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingDataIndicator.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
        loadingDataIndicator.centerYAnchor.constraint(
            equalTo: view.centerYAnchor,
            constant: -(navigationController?.navigationBar.frame.height ?? 0)
        ).isActive = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(EmployeeCell.self, forCellReuseIdentifier: EmployeeCell.cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    @objc
    private func fetchData() {
        presenter?.fetchData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.companyItem?.company.employees.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.cellId, for: indexPath) as! EmployeeCell
       
        cell.employee = presenter?.companyItem?.company.employees[indexPath.row]
        cell.backgroundColor = .secondarySystemBackground
        cell.selectionStyle = .none
        return cell
    }
    
}

// MARK: - EmployeesTableViewController
extension EmployeesTableViewControllerImpl: EmployeesTableViewController {
    
    func showAlert(withTitle title: String, withMessage message: String?) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(alertAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func stopRefreshControl() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    
    func startLoadingDataIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingDataIndicator.isHidden = false
            self?.loadingDataIndicator.startAnimating()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingDataIndicator.stopAnimating()
            self.tableView.reloadData()
            self.navigationItem.title = self.presenter?.companyItem?.company.name
        }
    }
    
    func setRightBarButtonItem(systemSymbol: SystemSymbol) {
        rightBarButtonItem = systemSymbol
    }
    
}
