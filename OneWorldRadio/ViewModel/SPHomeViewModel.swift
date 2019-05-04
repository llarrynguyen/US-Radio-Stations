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
    var hotStations: [RadioStation] = []
    var sportStations: [RadioStation] = []
    var popStations: [RadioStation] = []
    var countryStations: [RadioStation] = []
    var talkStations: [RadioStation] = []
    var oldiesStations: [RadioStation] = []
    var rockStations: [RadioStation] = []
    
    weak var delegate: SPHomeViewModelProtocol?
    
    var countryList = ["usa", "uk", "australia", "canada", "nz"]
    
    var selectedCountry = "usa" {
        didSet {
            loadStationsFromJSON()
        }
    }
    
    init() {
       
    }
    
    func loadStationsFromJSON() {
        
       resetAllCategories()
        // Turn on network indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Get the Radio Stations
        LocalDataManager.getStationDataWithSuccess(country: selectedCountry) { [unowned self](data) in
            
            // Turn off network indicator
            defer {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            }
            
            guard let data = data, let jsonArray = try? JSONDecoder().decode([RadioStation].self, from: data)else {
                return
            }
            
            for station in jsonArray {
                let trueCategory: RadioStationCategory = RadioStationCategory.radioTrueCategoryFactory(station: station)
                
                if let _ = self.stationDict[station.name] {
                    continue
                } else {
                     self.stationDict[station.name] = station
                }
                
                
               
                switch trueCategory {
                    case .Hot:
                        self.hotStations.append(station)
                    case .Sports:
                        self.sportStations.append(station)
                    case .Pop:
                        self.popStations.append(station)
                    case .Country:
                        self.countryStations.append(station)
                    case .Rock:
                        self.rockStations.append(station)
                    case .Oldies:
                        self.oldiesStations.append(station)
                    case .TalkAndNews:
                        self.talkStations.append(station)
        
                    default:
                        continue
                }
            }
            
            DispatchQueue.main.async {
                self.stations.forEach({ (station) in
                    station.write(dataSource: RealmDataPersistence.shared)
                })
                
                self.stations = jsonArray
            }
            gStations = self.stations   
            
        }
    }
    
    private func resetAllCategories() {
        stationDict = [:]
        hotStations = []
        sportStations  = []
        popStations = []
        countryStations = []
        talkStations = []
        oldiesStations = []
        rockStations = []
    }

    func numberOfCategories() -> Int {
        print("Number of stations \(stations.count)")
        return 7
    }
}
