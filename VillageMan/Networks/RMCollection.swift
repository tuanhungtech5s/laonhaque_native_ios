//
//  RMCollection.swift
//  VillageMan
//
//  Created by cauca on 11/16/21.
//

import Foundation
import RealmSwift
import SwiftUI

protocol PrimaryType { }

extension Int: PrimaryType { }
extension String: PrimaryType { }

struct RMCollection<T: Object> {
    
    private let config: Realm.Configuration
    
    init(config: Realm.Configuration = .defaultConfiguration) {
        self.config = config
    }
    
    func add(_ model: T) {
        do {
            let realm = try Realm(configuration: self.config)
            realm.beginWrite()
            if T.primaryKey() == nil {
                realm.add(model)
            } else {
                realm.add(model, update: .modified)
            }
            try realm.commitWrite()
            
        } catch {
            debugPrint("Add model \(String(describing: T.self)) error:\n\(error.localizedDescription)")
        }
    }
    
    func model(_ primaryKey: PrimaryType? = nil) -> T? {
        return nil
//        do {
//            let realm = try Realm(configuration: self.config)
//            guard let primaryKey = primaryKey, T.primaryKey() != nil else {
//                return realm.objects(T.self).first
//            }
//            return realm.object(ofType: T.self, forPrimaryKey: primaryKey)
//        } catch {
//            debugPrint("Get\(String(describing: T.self)) error:\n\(error.localizedDescription)")
//            return nil
//        }
    }
}

class RMResponseCache: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var data: Data? = nil
    
    convenience init(key: String, data: Data) {
        self.init()
        self.id = key
        self.data = data
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
