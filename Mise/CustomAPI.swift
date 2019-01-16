//
//  CustomAPI.swift
//  Mise
//
//  Created by Seongchan Kang on 15/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit

struct CustomAPI {
    
    static let token = "7ba124cd957e5ac93963ee8aa2e8d7eb478d3c12"
    
    static func getDustMap(topLeft:CLLocationCoordinate2D, bottomRight:CLLocationCoordinate2D, completion:(([MapAQI])->())?) {
        
        Alamofire.request("https://api.waqi.info/map/bounds/?latlng=\(bottomRight.latitude),\(bottomRight.longitude),\(topLeft.latitude),\(topLeft.longitude)&token=\(token)").responseJSON { (response) in
            
            var infos:[MapAQI] = []
            switch response.result {
                
            case .failure(let error):
                print(error)
                guard let completion = completion else {return}
                completion([])
            case .success(let value):
                
                let json = JSON(value)
                _ = json["data"].arrayValue.map({
                    let maps = MapAQI.init(json: $0)
                    infos.append(maps)
                })
                guard let completion = completion else {return}
                completion(infos)
            }
        }
    }
    
    static func getDust(lat:String, lng:String, completion:((WeatherData)->())?) {
        
        Alamofire.request("http://api.waqi.info/feed/geo:\(lat);\(lng)/?token=\(token)").responseJSON { (response) in
            switch response.result {
                
            case .failure(let error):
                print(error)
            case .success(let value):
                print(value)                
                
                let weatherData = WeatherData.init(json: JSON(value))
            
                completion!(weatherData)
                
            }
        }
        
    }
    
    static func getDust(city:String, completion:((WeatherData)->())?) {
        
        Alamofire.request("http://api.waqi.info/feed/\(city)/?token=\(token)").responseJSON { (response) in
            switch response.result {
                
            case .failure(let error):
                print(error)
            case .success(let value):
                print(value)
                
                let weatherData = WeatherData.init(json: JSON(value))
                
                completion!(weatherData)
                
            }
        }
        
    }
//    static func
    
}
