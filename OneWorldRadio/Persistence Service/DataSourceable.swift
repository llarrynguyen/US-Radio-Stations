//
//  DataSourceable.swift
//  Things+
//
//  Created by Larry Nguyen on 3/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation

protocol DataSourceable {
    func store<T>(object: T)
    func delete<T>(object: T)
}

