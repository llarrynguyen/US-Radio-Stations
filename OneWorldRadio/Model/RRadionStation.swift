//
//  RRadionStation.swift
//  OneWorldRadio
//
//  Created by Larry Nguyen on 4/14/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation
import RealmSwift

class RRadionStation: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var logo: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var isFavorite: Bool = false
    
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
}

extension RRadionStation {
    
    convenience init(radio: RadioStation) {
        self.init()
        
        self.name = radio.name
        self.url = radio.url
        self.logo = radio.logo
        self.category = radio.category ?? ""
        self.isFavorite = radio.isFavorite ?? false
       
    }
    
    var radio: RadioStation {
        return RadioStation(realmRadio: self)
    }
    
}

