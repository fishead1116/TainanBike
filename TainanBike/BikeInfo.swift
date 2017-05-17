//
//  BikeInfo.swift
//  TainanBike
//
//  Created by Li Yun Jung on 2017/5/16.
//  Copyright © 2017年 Li Yun Jung. All rights reserved.
//

import Foundation
import RealmSwift

class BikeInfo: Object {
    
    // Specify properties to ignore (Realm won't persist these)
    dynamic var name = ""
    dynamic var id = 0
    dynamic var latitude  : Double = 0.0
    dynamic var longitude : Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    static func saveBikeInfo(completionHandler : @escaping ([BikeInfo]) -> ()){
        
        TBike.getTBikeStatus { (bikes : [TBike]) in
            
            let realm = try! Realm()
            var result : [BikeInfo] = []
            for bike in bikes{
                
                let info = BikeInfo()
                info.name = bike.stationName
                info.id = bike.id
                info.latitude = bike.latitude
                info.longitude = bike.longitude
                
                try! realm.write {
                    realm.add(info, update: true)
                    result.append(info)
                }
            }
            completionHandler(result)
        }
    }
    
    static func readBikeInfo() -> [BikeInfo]{
        
        let realm = try! Realm()
        let objects = realm.objects(BikeInfo.self).sorted(byKeyPath : "id")
        
        return Array(objects)
        
    }
}
