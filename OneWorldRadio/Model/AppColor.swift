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
            color = UIColor.white
        case .tabBar:
            color = UIColor.white
        case .disabled:
            color = UIColor.gray
        case .active:
            color = SPConstants.ColorPaletteHex.mainBlue.color
        case .itemBackground:
            color = SPConstants.ColorPaletteHex.mainBlue.color
        case .buttonBackground:
            color = SPConstants.ColorPaletteHex.mainBlue.color
        case .categoryText:
            color = UIColor.black
        case .mainText:
            color = UIColor.black
        case .bottomViewBackground:
            color = UIColor.white
            
        case .custom(let hexValue, let opacity):
            color = hexValue.color.withAlphaComponent(CGFloat(opacity))
        }
        
        return color
    }
}
