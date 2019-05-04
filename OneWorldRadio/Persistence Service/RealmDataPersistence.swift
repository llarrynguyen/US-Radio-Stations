//
//  RealmDataPersistence.swift
//  Things+
//
//  Created by Larry Nguyen on 3/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataPersistence: DataSourceable {
    
    static let shared = RealmDataPersistence()
    var radios: [RadioStation] {
        let objects = realm.objects(RRadionStation.self)
        
        return objects.map {
            return $0.radio
        }
    }
    
    func radiosWithFilter(filter: String) -> [RadioStation] {
        
        if filter == "" {return []}
        let objects = realm.objects(RRadionStation.self)
        
        var myObjects = objects
        
        if filter != "" {
            myObjects = objects.filter("name CONTAINS[cd] %@", filter)
        }
  
        
        return myObjects.map {
            return $0.radio
            
        }
    }
    
    func radiosWithFilter(filter: String, isFavorite: Bool) -> [RadioStation] {
        
        let objects = realm.objects(RRadionStation.self)
        
        var myObjects = objects
        
        if filter != "" {
            myObjects = objects.filter("name CONTAINS[cd] %@", filter)
        }
        
        let filtered = myObjects.filter { (station) -> Bool in
            station.isFavorite == true
        }
        
        return filtered.map {
            return $0.radio
            
        }
    }
    
    
    var realm: Realm
    
    private init() {
        // Load our data
        self.realm = try! Realm(configuration: .defaultConfiguration)
    }
    
    func store<T>(object: T) {
        guard let radio = object as? RadioStation else {
            return
        }
        
        // Save
        try? self.realm.write {
            self.realm.add(radio.realmRadio, update: true)
        }
        
        NotificationCenter.default.post(name: .radioDataChanged, object: nil)
    }
    
    func delete<T>(object: T) {
        guard let radio = object as? RadioStation else {
            return
        }
        
        // Delete
        if let realmRadio = self.realm.object(ofType: RRadionStation.self, forPrimaryKey: radio.name) {
            self.realm.beginWrite()
            self.realm.delete(realmRadio)
            try? self.realm.commitWrite()
        }
        
        NotificationCenter.default.post(name: .radioDataChanged, object: nil)
    }
    
}

extension Notification.Name {
    
    static let radioDataChanged = Notification.Name(rawValue: "radioDataChanged")
}

