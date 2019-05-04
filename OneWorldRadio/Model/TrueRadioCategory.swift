//
//  TrueRadioCategory.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 4/12/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation

enum RadioStationCategory: String {
    case US
    case UK
    
    var categoryName: String {
        switch self {
        case .US:
            return "USA"
        case .UK:
            return "United Kingdom"
        }
    }
    
    static func radioTrueCategoryFactory( station:RadioStation) -> RadioStationCategory{
        if let category = station.category {
            if category == "US" {
                return .US
            } else {
                return .UK
            }
        }
      return .US
    }
}
