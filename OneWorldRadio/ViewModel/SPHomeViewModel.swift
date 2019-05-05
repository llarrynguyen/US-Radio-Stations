//
//  SPSearchViewModel.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 2/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

protocol SPHomeViewModelProtocol: class {
    func haveUpdateStations()
}

class SPHomeViewModel {
    var stations = [RadioStation]() {
        didSet {
            guard stations != oldValue else { return }
            delegate?.haveUpdateStations()
        }
    }

    
    var stationDict: [String: RadioStation ] = [:]
    var usStations: [RadioStation] = []
    var ukStations: [RadioStation] = []
   
    
    weak var delegate: SPHomeViewModelProtocol?
    
    var countryList = ["usa", "uk"]
    

    init() {
       
    }
    
    func loadStationsFromJSON() {
        
       resetAllCategories()
        // Turn on network indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Get the Radio Stations
        LocalDataManager.getStationDataWithSuccess(country: "usa") { [unowned self](data) in
            
            // Turn off network indicator
            defer {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            }
            
            guard let data = data, let jsonArray = try? JSONDecoder().decode([RadioStation].self, from: data)else {
                return
            }
            
            for station in jsonArray {
                if let _ = self.stationDict[station.name] {
                    continue
                } else {
                     self.stationDict[station.name] = station
                }
                
                
              self.usStations.append(station)
                
                
            }
            
            DispatchQueue.main.async {
                self.stations.forEach({ (station) in
                    station.write(dataSource: RealmDataPersistence.shared)
                })
                
                self.stations.append(contentsOf: jsonArray)
            }
            gStations = self.stations   
            
        }
    }
    
    func loadStationsFromJSON2() {
        
        resetAllCategories()
        // Turn on network indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Get the Radio Stations
        LocalDataManager.getStationDataWithSuccess(country: "uk") { [unowned self](data) in
            
            // Turn off network indicator
            defer {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            }
            
            guard let data = data, let jsonArray = try? JSONDecoder().decode([RadioStation].self, from: data)else {
                return
            }
            
            for station in jsonArray {
                if let _ = self.stationDict[station.name] {
                    continue
                } else {
                    self.stationDict[station.name] = station
                }
                
                
                self.ukStations.append(station)
                
                
            }
            
            DispatchQueue.main.async {
                self.stations.forEach({ (station) in
                    station.write(dataSource: RealmDataPersistence.shared)
                })
                
                self.stations.append(contentsOf: jsonArray)
              
            }
            gStations = self.stations
            
        }
    }
    
    private func resetAllCategories() {
        stationDict = [:]
        usStations = []
        ukStations  = []
        stations = []
    
    }

    func numberOfCategories() -> Int {
        print("Number of stations \(stations.count)")
        return 3
    }
}
