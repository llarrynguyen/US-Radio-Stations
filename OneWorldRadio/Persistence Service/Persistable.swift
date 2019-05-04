//
//  Persistable.swift
//  Things+
//
//  Created by Larry Nguyen on 3/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation

protocol Persistable {
    func write(dataSource: DataSourceable)
    func delete(dataSource: DataSourceable)
}


