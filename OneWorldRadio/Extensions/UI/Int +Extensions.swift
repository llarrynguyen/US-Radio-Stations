//
//  Int +Extensions.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 2/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

extension Int {
    public var color: UIColor {
        return UIColor(hexInt: self)
    }
}
