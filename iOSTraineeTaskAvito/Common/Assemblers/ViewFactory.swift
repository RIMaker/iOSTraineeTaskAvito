//
//  ViewFactory.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 30.10.2022.
//

import UIKit

enum ScreenIdentifier {
    case mainScreen
    case launchScreen
}


protocol ViewFactory {
    func makeView(for screenIdentifier: ScreenIdentifier) -> UIViewController?
}

class ViewFactoryImpl: ViewFactory {
    
    func makeView(for screenIdentifier: ScreenIdentifier) -> UIViewController? {
        switch screenIdentifier {
        case .mainScreen: return makeMainScreen()
        case .launchScreen: return makeLaunchScreen()
        }
    }
    
}

// MARK: - Supporting functions
extension ViewFactoryImpl {
    
    func makeMainScreen() -> UIViewController? {
        let employeesVC = EmployeesTableViewControllerImpl()
        let employeesVCPresenter = EmployeesTableVCPresenterImpl(
            view: employeesVC,
            networkManager: NetworkManagerImpl(),
            cacheManager: CacheManagerImpl())
        employeesVC.presenter = employeesVCPresenter
        let navController = UINavigationController(rootViewController: employeesVC)
        return navController
    }
    
    func makeLaunchScreen() -> UIViewController? {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: .main)
        let launchScreen = storyboard.instantiateInitialViewController()
        return launchScreen
    }
    
}
