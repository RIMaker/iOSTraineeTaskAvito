//
//  EmployeesTableVCPresenterDelegate.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 23.10.2022.
//

import Foundation

protocol EmployeesTableVCPresenter {
    var delegate: EmployeesTableViewController? { get set }
    func viewShown()
}
