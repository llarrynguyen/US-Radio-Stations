//
//  SPConstants.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 2/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

struct SPConstants {
    struct ColorPaletteHex {
        static let darkBlue = "192330"
        static let deepOceanBlue = "424E5F"
        static let foggySeaBlue = "95B1BB"
        static let smokyBlue = "81909D"
        static let shinySkyBlue = "49D8E0"
        static let smokyGreen = "5D9B95"
        static let lightSkyBlue = "CEFFFF"
        static let almostBlack = "000001"
        static let smoky = "64747D"
    }
}

struct Resources {
    struct ImageNames {
        static let search = "icons8-search"
        static let sector = "icons8-statistics"
        static let news = "icons8-pc_on_desk"
        static let you = "icons8-likes_folder"
        static let ad = "icons8-mortgage"
    }
    
    struct reusableIdentifiers {
        static let searchCell = "searchCell"
        static let oneLabelOneButtonView = "oneLabelOneButtonView"
        static let portfolioCell = "portfolioCell"
        static let youTopHeaderCell = "youTopHeaderCell"
        static let newsView = "NewsView"
        static let NewsViewReuse = "NewsViewReuse"
        static let stationCell = "stationCell"
     
    }
    
    struct NibName {
        static let StationNib = "StationCollectionViewCell"
    }
    
    struct Sizes {
        static let standardInset: CGFloat = 16
        static let halfInset: CGFloat = 8
        static let doubleInset: CGFloat = 32
    }
    
    struct StoryboardName {
        static let radioStoryboard = "Radio"
    }
    
    struct ViewControllerIds {
        static let SPNowPlayingViewController = "SPNowPlayingViewController"
    }
}

struct ConstantTexts {
    struct PlaceHolder {
        static let searchPlaceholder = "Stock symbol eg. AAPL"
    }
}

struct ViewControllerType {
    static let searchViewController = "SPSearchViewController"
    static let sectorViewController = "SPSectorViewController"
    static let newsViewController = "SPNewsViewController"
    static let youViewController = "SPYouViewController"
    static let adViewController = "SPAdViewController"
}
