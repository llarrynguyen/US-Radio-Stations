//
//  String+Extension.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 2/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

extension String {
    public var color: UIColor {
        return UIColor(hexString: self)
    }
    
    public var image: UIImage? {
        return UIImage(named: self)
    }
}


