//
//  Company.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 18.10.2022.
//

import Foundation

class Company: Decodable {
    var name: String
    var employees: [Employee]
}
