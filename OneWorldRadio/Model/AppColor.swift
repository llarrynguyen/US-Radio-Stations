//
//  AppColor.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 2/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

enum AppColor {
    case mainBackgroud
    case tabBar
    case disabled
    case active
    case itemBackground
    case buttonBackground
    case categoryText
    case mainText
    case bottomViewBackground
    
    
    case custom(hexString: String, alpha: Double)
    
    func alpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension AppColor {
    
    var value: UIColor {
        var color = UIColor.clear
        
        switch self {
        case .mainBackgroud:
            color = SPConstants.ColorPaletteHex.almostBlack.color
        case .tabBar:
            color = SPConstants.ColorPaletteHex.almostBlack.color
        case .disabled:
            color = SPConstants.ColorPaletteHex.smoky.color
        case .active:
            color = SPConstants.ColorPaletteHex.shinySkyBlue.color
        case .itemBackground:
            color = SPConstants.ColorPaletteHex.deepOceanBlue.color
        case .buttonBackground:
            color = SPConstants.ColorPaletteHex.almostBlack.color
        case .categoryText:
            color = SPConstants.ColorPaletteHex.lightSkyBlue.color
        case .mainText:
            color = SPConstants.ColorPaletteHex.almostBlack.color
        case .bottomViewBackground:
            color = SPConstants.ColorPaletteHex.foggySeaBlue.color
            
        case .custom(let hexValue, let opacity):
            color = hexValue.color.withAlphaComponent(CGFloat(opacity))
        }
        
        return color
    }
}
