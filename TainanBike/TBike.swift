//
//  TBikeStatus.swift
//  TainanBike
//
//  Created by Li Yun Jung on 2017/3/28.
//  Copyright © 2017年 Li Yun Jung. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let tBikeUrl = "http://tbike.tainan.gov.tw:8081/Service/StationStatus/Json"

class TBike{
    
    var id : Int
    var stationName : String
    var address : String
    var latitude : Double
    var longitude : Double

    var capacity : Int
    var avaliableBikeCount : Int
    var avaliableSpaceCount : Int
    var updateTime : Date
    
    init(id : Int , stationName : String , address : String , latitude : Double , longitude : Double , capacity : Int, avaliableBikeCount : Int , avaliableSpaceCount : Int , updateTime : Date) {
        self.id = id
        self.stationName = stationName
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.capacity = capacity
        self.avaliableBikeCount = avaliableBikeCount
        self.avaliableSpaceCount = avaliableSpaceCount
        self.updateTime = updateTime
    }

    fileprivate static func jsonToTBike(json : JSON) -> TBike?{
    
        guard let id = json["Id"].int else{
            return nil
        }
        guard let stationName = json["StationName"].string else{
            return nil
        }
        guard let address = json["Address"].string else{
            return nil
        }
        guard let latitude = json["Latitude"].double else{
            return nil
        }
        guard let longitude = json["Longitude"].double else{
            return nil
        }
        guard let capacity = json["Capacity"].int else{
            return nil
        }
        guard let avaliableBikeCount = json["AvaliableBikeCount"].int else{
            return nil
        }
        guard let avaliableSpaceCount = json["AvaliableSpaceCount"].int else{
            return nil
        }
        guard let timeStr = json["UpdateTime"].string else{
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        guard let updateTime = formatter.date(from: timeStr) else{
            return nil
        }
        
        let bike = TBike(id: id, stationName: stationName, address: address, latitude: latitude, longitude: longitude, capacity: capacity, avaliableBikeCount: avaliableBikeCount, avaliableSpaceCount: avaliableSpaceCount, updateTime: updateTime)
        
        return bike
    
    }
    
    static func getTBikeStatus(completionHandler : @escaping ([TBike]) -> ()) {
    
        Alamofire.request(tBikeUrl, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default	, headers: nil).responseJSON { (response : DataResponse<Any>) in
            if let value = response.result.value{
                let json = JSON(value)
                var bikes : [TBike] = []
                if let array = json.array{
                    for item in array{
                        if let bike = jsonToTBike(json: item){
                            bikes.append(bike)
                        }
                    }
                }
                completionHandler(bikes)
            }
            
        }
    }

}
