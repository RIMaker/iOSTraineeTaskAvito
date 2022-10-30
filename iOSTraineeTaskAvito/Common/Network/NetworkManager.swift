//
//  NetworkManager.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 19.10.2022.
//

import Foundation
import Network

protocol NetworkManager {
    func fetchData(forURL requestUrl: String, complition: @escaping (Result<CompanyItem?, Error>)->())
    func createNetworkConnectionMonitor(complition: @escaping (NWPath.Status)->())
}

class NetworkManagerImpl: NetworkManager {
    
    private var lastStatus: NWPath.Status?
    
    func fetchData(forURL requestUrl: String, complition: @escaping (Result<CompanyItem?, Error>)->()) {
        guard let url = URL(string: requestUrl) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.setValue(APIProvider.shared.contentType, forHTTPHeaderField: "Content-Type")
        DispatchQueue.global().async {
            session.dataTask(with: request) { (data, response, error) in
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    error == nil
                else {
                    if let error = error {
                        complition(.failure(error))
                    }
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let companyItem = try decoder.decode(CompanyItem.self, from: data)
                    complition(.success(companyItem))
                } catch {
                    complition(.failure(error))
                }
            }.resume()
        }
    }
    
    func createNetworkConnectionMonitor(complition: @escaping (NWPath.Status)->()) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            if self?.lastStatus != path.status {
                self?.lastStatus = path.status
                complition(path.status)
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
}
