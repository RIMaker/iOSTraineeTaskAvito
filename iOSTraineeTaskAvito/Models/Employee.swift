//
//  Employee.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 18.10.2022.
//

import Foundation

class Employee: Decodable {
    var name: String
    var phoneNumber: String
    var skills: [String]
}
