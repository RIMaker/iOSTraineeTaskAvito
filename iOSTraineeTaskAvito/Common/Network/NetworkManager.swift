//
//  NetworkManager.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 19.10.2022.
//

import Foundation
import Network

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let lastUpdatingDateKey = "lastUpdatingDate"
    
    private let requestUrl = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    
    func shouldUpdateData() -> Bool {
        let lastUpdatingDate = UserDefaults.standard.value(forKey: lastUpdatingDateKey) as? Date
        let cachedData = CacheManager.shared.cachedData()
        let nowDate = Date()
        if let lastUpdatingDate = lastUpdatingDate, let _ = cachedData {
            if nowDate.timeIntervalSince(lastUpdatingDate) >= 3600 {
                return true
            }
            return false
        }
        return true
    }
    
    func fetchData(complition: @escaping (CompanyItem?)->()) {
        guard let url = URL(string: requestUrl) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: request) { (data, response, error) in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil
            else {
                complition(nil)
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let companyItem = try? decoder.decode(CompanyItem.self, from: data)
            if let companyItem = companyItem {
                CacheManager.shared.cache(data: companyItem)
                UserDefaults.standard.setValue(Date(), forKey: self.lastUpdatingDateKey)
            }
            complition(companyItem)
        }.resume()
    }
    
    func createNetworkConnectionMonitor(complition: @escaping (NWPath.Status)->()) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            complition(path.status)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
}
