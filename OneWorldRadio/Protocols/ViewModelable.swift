//
//  ViewModelable.swift
//  StockPerformance
//
//  Created by Larry Nguyen on 3/1/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

protocol ViewModelable {
    var delegate: Any {get}
    var networkManager: LocalDataManager {get}
}


protocol ViewControllerable {
    var name: String {get}
    var tabItemImageString: String {get}
    var viewModel: Any? {get}
    func setupViewController()
}

