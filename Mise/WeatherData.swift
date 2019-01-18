//
//  WeatherData.swift
//  Mise
//
//  Created by Seongchan Kang on 15/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

struct MapAQI {
    
    var geo:CLLocationCoordinate2D
    var aqi:String
    var uid:Int
    
    init(json:JSON) {
    
        self.uid = json["uid"].intValue
        self.aqi = json["aqi"].stringValue
        self.geo = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(json["lat"].floatValue), longitude: CLLocationDegrees(json["lon"].floatValue))
    }
    
}

struct WeatherData {
    
    private var iaqis:[String:JSON]
    var name:String
    var time:String
    var geo:CLLocationCoordinate2D
    var aqi:Int
    var temperature:Float?
    var pm10:Float?
    var pressure:Float?
    var wind:Float?
    var rain:Float?
    var no2:Float?
    var pm25:Float?
    var o3:Float?
    var humidity:Float?
    var co:Float?
    var so2:Float?
    var dominentpol:String
    var alertLevel:AlertLevel?

    
    init(json:JSON) {
        
        self.name = json["data"]["city"]["name"].stringValue
        self.time = json["data"]["time"]["s"].stringValue
        self.aqi = json["data"]["aqi"].intValue
        if let loca = json["data"]["city"]["geo"].array {
                    self.geo = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(loca[0].floatValue), longitude: CLLocationDegrees(loca[1].floatValue))
        }else{
            self.geo = CLLocationCoordinate2D()
        }
        

        self.iaqis = json["data"]["iaqi"].dictionaryValue
        self.dominentpol = json["data"]["dominentpol"].stringValue
        
        _ = self.iaqis.map({
            
            let value = $1["v"].floatValue
            
            switch $0 {
                
            case "pm10":
                self.pm10 = value
            case "h":
                self.humidity = value
            case "w":
                self.wind = value
            case "p":
                self.pressure = value
            case "co":
                self.co = value
            case "wd":
                self.wind = value
            case "so2":
                self.so2 = value
            case "t":
                self.temperature = value
            case "pm25":
                self.pm25 = value
            case "o3":
                self.o3 = value
            case "r":
                self.rain = value
            case "no2":
                self.no2 = value
            default:
                break
            }
            print($0, $1["v"])
        })
        
        switch aqi {
            
        case 0...50 :
            self.alertLevel = AlertLevel.safe
        case 51...100:
            self.alertLevel = AlertLevel.normal
        case 101...150:
            self.alertLevel = AlertLevel.little
        case 151...200:
            self.alertLevel = AlertLevel.bad
        case 201...300:
            self.alertLevel = AlertLevel.veryBad
        case 300...1000:
            self.alertLevel = AlertLevel.danger
        default:
            break
            
        }
    }
    
    mutating func setTemperature(_ temp:Float?) {
        self.temperature = temp
    }
    
}

enum AlertLevel:String {
    
    case safe, normal, little, bad, veryBad, danger
}
