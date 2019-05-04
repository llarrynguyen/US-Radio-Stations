//
//  SPGlobals.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 3/2/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation
import FRadioPlayer

var currentGlobalStation: RadioStation? = nil

var gStations: [RadioStation] = []

var gSelectedCountry = "usa"


internal func mainQueue( _ block: @escaping () -> ()){
    DispatchQueue.main.async {
        block()
    }
}

internal func globalQueue( _ block: @escaping () -> ()){
    DispatchQueue.global(qos:.default).async{
        block()
    }
}


typealias VoidClosureParameter = (() -> ())
