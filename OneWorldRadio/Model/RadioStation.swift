//
//  RadioStation.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 4/11/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class RadioStation: Codable {
    
    var name: String
    var url: String
    var logo: String
    var category: String?
    var isFavorite: Bool?
    
    init(name: String, streamURL: String, imageURL: String, category: String?, isFavorite: Bool?) {
        self.name = name
        self.url = streamURL
        self.logo = imageURL
        self.category = category
        self.isFavorite = isFavorite
    }
}

extension RadioStation: Equatable {
    
    static func ==(lhs: RadioStation, rhs: RadioStation) -> Bool {
        return (lhs.name == rhs.name) && (lhs.url == rhs.url) && (lhs.logo == rhs.logo) && (lhs.category == rhs.category)
    }
}

extension RadioStation : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension RadioStation: Persistable {
    
    func write(dataSource: DataSourceable) {
        dataSource.store(object: self)
    }
    
    func delete(dataSource: DataSourceable) {
        dataSource.delete(object: self)
    }
}


extension RadioStation {
    
    convenience init(realmRadio: RRadionStation) {
        self.init(name: realmRadio.name, streamURL: realmRadio.url, imageURL: realmRadio.logo, category: realmRadio.category, isFavorite: realmRadio.isFavorite)
    }
    
    var realmRadio: RRadionStation {
        return RRadionStation(radio: self)
    }
    
}

