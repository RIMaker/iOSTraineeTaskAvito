//
//  EmployeesTableViewController.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 18.10.2022.
//

import UIKit

class EmployeesTableViewController: UITableViewController {
    
    var presenter: EmployeesTableVCPresenter?
    
    var companyItem: CompanyItem? {
        didSet {
            if let newCompanyItem = companyItem {
                companyItem?.company.employees = newCompanyItem.company.employees.sorted {
                    $0.name < $1.name
                }
            }
        }
    }
    
    var rightBarButtonItem: SystemSymbol = .wifi {
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
    
    let loadingDataIndicator: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView()
        actInd.isHidden = true
        actInd.hidesWhenStopped = true
        return actInd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.delegate = self
        presenter?.viewShown()
       
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyItem?.company.employees.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.cellId, for: indexPath) as! EmployeeCell
       
        cell.employee = companyItem?.company.employees[indexPath.row]
        cell.backgroundColor = .secondarySystemBackground
        cell.selectionStyle = .none
        return cell
    }
    
}
