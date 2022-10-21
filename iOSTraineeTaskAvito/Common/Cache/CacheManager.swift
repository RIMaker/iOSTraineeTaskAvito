//
//  CacheManager.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 20.10.2022.
//

import Foundation

class CacheManager {
    
    static let shared = CacheManager()
    
    func cachedData() -> CompanyItem? {

        guard
            let data = UserDefaults.standard.object(forKey: UserDefaultsKeys.cachedObjectKey.rawValue) as? Data,
            let companyItem = try? JSONDecoder().decode(CompanyItem.self, from: data)
        else {
            return nil
        }
        return companyItem
    }
    
    func cache(data: CompanyItem) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.cachedObjectKey.rawValue)
        }
    }
}
