//
//  TrueRadioCategory.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 4/12/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation

enum RadioStationCategory: String {
    case Hot
    case Sports
    case Pop
    case Country
    case Rock
    case TalkAndNews
    case Oldies
    case Others
    
    var categoryName: String {
        switch self {
        case .Hot:
            return "Hot Now"
        case .Sports:
            return "Sports"
        case .Pop:
            return "Pop"
        case .Rock:
            return "Rock"
        case .Country:
            return "Country Music"
        case .TalkAndNews:
            return "Talks & News"
        case .Oldies:
            return "60s, 70s && 80s"
        case .Others:
            return "Others"
        }
    }
    
    static func radioTrueCategoryFactory( station:RadioStation) -> RadioStationCategory{
        if let category = station.category {
            if station.name.contains("Pop") || category.contains("Pop") {
                return .Pop
            } else  if station.name.contains("Sport") || category.contains("Sport") {
                return .Sports
            } else  if station.name.contains("Hot") || category.contains("Hot") {
                return .Hot
            } else  if station.name.contains("Rock") || category.contains("Rock") {
                return .Rock
            } else  if station.name.contains("Talk") || station.name.contains("News") || category.contains("Talk") || category.contains("News"){
                return .TalkAndNews
            } else if station.name.contains("Oldies") || category.contains("Oldies") || category.contains("60") || category.contains("70")  ||  category.contains("80")   {
                return .Oldies
            } else  if station.name.contains("Country") || category.contains("Country") {
                return .Country
            }  else {
                return .Others
            }
        }
      return .Others
    }
}
