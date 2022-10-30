//
//  EmployeesTableVCPresenterImpl.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 23.10.2022.
//

import UIKit

protocol EmployeesTableVCPresenter {
    var companyItem: CompanyItem? { get set }
    init(view: EmployeesTableViewController, networkManager: NetworkManager, cacheManager: CacheManager)
    func viewShown()
    func fetchData()
}

class EmployeesTableVCPresenterImpl: EmployeesTableVCPresenter {
    
    private let networkManager: NetworkManager
    
    private let cacheManager: CacheManager
    
    weak var view: EmployeesTableViewController?
    
    var companyItem: CompanyItem? {
        didSet {
            if let newCompanyItem = companyItem {
                companyItem?.company.employees = newCompanyItem.company.employees.sorted {
                    $0.name < $1.name
                }
            }
        }
    }
    
    required init(
        view: EmployeesTableViewController,
        networkManager: NetworkManager,
        cacheManager: CacheManager)
    {
        self.view = view
        self.networkManager = networkManager
        self.cacheManager = cacheManager
    }
    
    func viewShown() {
        createNetworkConnectionMonitor()
    }
    
    func fetchData() {
        view?.startLoadingDataIndicator()
        networkManager.fetchData(forURL: APIProvider.shared.apiUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let companyItem):
                self.cacheManager.cache(data: companyItem)
                self.companyItem = companyItem
                self.view?.reloadData()
            case .failure(_):
                break
            }
            self.view?.stopRefreshControl()
        }
    }
}

// MARK: - Supporting functions
extension EmployeesTableVCPresenterImpl {
    
    private func createNetworkConnectionMonitor() {
        networkManager.createNetworkConnectionMonitor { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .satisfied:
                    self?.view?.setRightBarButtonItem(systemSymbol: .wifi)
                    self?.updateData()
                case .unsatisfied:
                    self?.view?.setRightBarButtonItem(systemSymbol: .wifiSlash)
                    self?.view?.showAlert(withTitle: "Connection failure", withMessage: nil)
                    self?.updateData()
                case .requiresConnection:
                    self?.view?.setRightBarButtonItem(systemSymbol: .wifiExclamationMark)
                default: break
                }
            }
        }
    }
    
    private func shouldUpdateData() -> Bool {
        let lastUpdatingDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastUpdatingDateKey.rawValue) as? Date
        let cachedData = cacheManager.cachedData()
        let nowDate = Date()
        if let lastUpdatingDate = lastUpdatingDate, let _ = cachedData {
            if nowDate.timeIntervalSince(lastUpdatingDate) >= 3600 {
                return true
            }
            return false
        }
        return true
    }
    
    private func updateData() {
        if shouldUpdateData() {
            fetchData()
        } else {
            companyItem = cacheManager.cachedData()
            view?.reloadData()
            view?.stopRefreshControl()
        }
    }
    
}
