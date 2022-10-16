//
//  DataFetch.swift
//  BroadAppsTestTask
//
//  Created by Elvis on 13.10.2022.
//

import Foundation

final class DataFetch {
    
    private var apiManager = ApiManager()
    
    func fetchImage(searchTerm: String, comletionHandler: @escaping (SearchingResult?) -> ()) {
        apiManager.request(searchTerm: searchTerm) { (data, error) in
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
                comletionHandler(nil)
            }
            
            let decode = self.decodeJSON(type: SearchingResult.self, from: data)
            comletionHandler(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("JSONError: ", jsonError)
            return nil
        }
    }
}
