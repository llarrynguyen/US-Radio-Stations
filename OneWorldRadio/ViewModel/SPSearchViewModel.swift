//
//  SPNewsViewModel.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 2/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation

class SPSearchViewModel {


    var searchText = ""
    
    var stations: [RadioStation] {
        get {
            return RealmDataPersistence.shared.radiosWithFilter(filter: searchText)
        }
    }
    
    init() {
        
    }
    
    func numberOfRows() -> Int {
        return stations.count
    }
}
