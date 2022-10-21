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
    
    func shouldUpdateData() -> Bool {
        let lastUpdatingDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastUpdatingDateKey.rawValue) as? Date
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
    
    func fetchData(forURL requestUrl: String, complition: @escaping (CompanyItem?)->()) {
        guard let url = URL(string: requestUrl) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.setValue(APIProvider.shared.contentType, forHTTPHeaderField: "Content-Type")
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
                UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastUpdatingDateKey.rawValue)
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
