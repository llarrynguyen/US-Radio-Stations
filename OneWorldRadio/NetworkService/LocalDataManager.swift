//
//  AppError.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 3/1/19.
//  Copyright © 2019 Larry. All rights reserved.
//


import UIKit

struct LocalDataManager {
    
    static func getStationDataWithSuccess(country: String, success: @escaping ((_ metaData: Data?) -> Void)) {

        DispatchQueue.global(qos: .userInitiated).async {
            if inAppStation {
                getDataFromFileWithSuccess(country) { data in
                    success(data)
                }
            } else {
                guard let stationDataURL = URL(string: httpStationURL) else {
                    success(nil)
                    return
                }
                
                loadDataFromURL(url: stationDataURL) { data, error in
                    success(data)
                }
            }
        }
    }
   
    static func getDataFromFileWithSuccess(_ countryName: String,success: (_ data: Data?) -> Void) {
        guard let filePathURL = Bundle.main.url(forResource: countryName, withExtension: "json") else {
            success(nil)
            return
        }
        
        do {
            let data = try Data(contentsOf: filePathURL, options: .uncached)
            success(data)
        } catch {
            fatalError()
        }
    }

    static func loadDataFromURL(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true
        sessionConfig.timeoutIntervalForRequest = 10
        sessionConfig.timeoutIntervalForResource = 38
        sessionConfig.httpMaximumConnectionsPerHost = 1
        
        let session = URLSession(configuration: sessionConfig)
        
        let loadDataTask = session.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                completion(nil, nil)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }

            completion(data, nil)
        }
        
        loadDataTask.resume()
    }
}
