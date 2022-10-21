//
//  APIProvider.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 21.10.2022.
//

import Foundation

struct APIProvider {
    
    static let shared = APIProvider()
    
    let apiUrl = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    
    let contentType = "application/json; charset=UTF-8"
    
}
