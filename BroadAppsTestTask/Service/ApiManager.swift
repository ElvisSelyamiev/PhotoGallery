//
//  ApiManager.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 13.10.2022.
//

import Foundation

final class ApiManager {
    
    func request(searchTerm: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let parameters = self.getParameters(searchTerm: searchTerm)
        let url = self.url(parameters: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = getHeader()
        request.httpMethod = "get"
        let task = dataTask(request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func url(parameters: [String : String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func getParameters(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(10)
        return parameters
    }
    
    private func getHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID y2vHKdc0Z1DS37_0uQr94Frx6H5ky0tAqJHxfIVFOQo"
        return headers
    }
    
    private func dataTask(_ request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completionHandler(data, error)
            }
        }
    }
}
