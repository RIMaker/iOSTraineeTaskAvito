//
//  CacheManager.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 20.10.2022.
//

import Foundation

class CacheManager {
    
    static let shared = CacheManager()
    
    private let cachedObjectKey: NSString = "CachedObject"
    
    private let cache = NSCache<NSString, CompanyItem>()
    
    func cachedData() -> CompanyItem? {

        let cachedData = cache.object(forKey: cachedObjectKey)
        
        return cachedData
        
    }
    
    func cache(data: CompanyItem) {
        cache.setObject(data, forKey: cachedObjectKey)
    }
}
