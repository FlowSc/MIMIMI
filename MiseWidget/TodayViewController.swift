//
//  TodayViewController.swift
//  MiseWidget
//
//  Created by Seongchan Kang on 17/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var thumnailImv: UIImageView!
    @IBOutlet weak var widgetLb: UILabel!
    @IBOutlet weak var moveToAppBtn: UIButton!
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
//        locationManager.
        locationManager = CLLocationManager()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view from its nib.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
        
//        URLSession.

    }
    
    func setUI() {
        moveToAppBtn.addTarget(self, action: #selector(moveToApp(sender:)), for: .touchUpInside)
        moveToAppBtn.setAttributedTitle("앱에서\n자세히 보기".makeAttrString(font: .NotoSans(.bold, size: 12), color: .white), for: .normal)
        moveToAppBtn.titleLabel?.numberOfLines = 2
        moveToAppBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        moveToAppBtn.titleLabel?.textAlignment = .center
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        setData()

        
        completionHandler(NCUpdateResult.newData)
    }
    
    func setData() {

        if let myLocation = locationManager.location {
            
            
            print(myLocation)
            
            
            CustomAPI.getDust(lat:"\(myLocation.coordinate.latitude)", lng: "\(myLocation.coordinate.longitude)") { (data) in
                print(data.aqi)
                print(data.dominentpol)
                var dominent:String?
                self.widgetLb.numberOfLines = 0

                
                switch data.dominentpol {
                case "pm25":dominent = "pm25".localized
                case "pm10":dominent = "pm10".localized
                case "o3":dominent = "o3".localized
                case "so2":dominent = "so2".localized
                case "no2":dominent = "no2".localized
                case "co":dominent = "CO".localized
                default:
                    break
                    
                }
                
                
                switch data.alertLevel! {
                    
                case .bad:
                    self.view.backgroundColor = UIColor.unhealthyRed
                    
                    let attrS = "\(data.time)\n\(dominent ?? ""):\(data.aqi)\n".makeAttrString(font: .NotoSans(.bold, size: 14), color: .white)
                    attrS.append("badDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 14), color: .white))
                    
                    self.widgetLb.attributedText = attrS
//                    self.widgetLb.attributedText.add

                case .danger:
                    let attrS = "\(data.time)\n\(dominent ?? ""):\(data.aqi)\n".makeAttrString(font: .NotoSans(.bold, size: 14), color: .white)
                    attrS.append("dangerDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 14), color: .white))
                    
                    self.widgetLb.attributedText = attrS
                    self.view.backgroundColor = UIColor.hazardPurple
                    
                case .little:
                    let attrS = "\(data.time)\n\(dominent ?? ""):\(data.aqi)\n".makeAttrString(font: .NotoSans(.bold, size: 14), color: .white)
                    attrS.append("littleBadDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 14), color: .white))
                    
                    self.widgetLb.attributedText = attrS
                    self.view.backgroundColor = UIColor.unhealthyTangerine
                    
                case .normal:
                    let attrS = "\(data.time)\n\(dominent ?? ""):\(data.aqi)\n".makeAttrString(font: .NotoSans(.bold, size: 14), color: .white)
                    attrS.append("normalDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 14), color: .white))
                    
                    self.widgetLb.attributedText = attrS
                    self.view.backgroundColor = UIColor.normalYellow
                    
                case .safe:
                    let attrS = "\(data.time)\n\(dominent ?? ""):\(data.aqi)\n".makeAttrString(font: .NotoSans(.bold, size: 14), color: .white)
                    attrS.append("safeDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 14), color: .white))
                    
                    self.widgetLb.attributedText = attrS
                    self.view.backgroundColor = UIColor.wellGreen
                    
                case .veryBad:
                    let attrS = "\(data.time)\n\(dominent ?? ""):\(data.aqi)\n".makeAttrString(font: .NotoSans(.bold, size: 14), color: .white)
                    attrS.append("veryBadDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 14), color: .white))
                    
                    self.widgetLb.attributedText = attrS
                    self.view.backgroundColor = UIColor.unhealthyPurple
                    
                }
                
                
//
//                if let time = UserDefaults.init(suiteName: GROUPIDENTIFIER)?.string(forKey: "time"), let aqi = UserDefaults.init(suiteName: GROUPIDENTIFIER)?.string(forKey: "domimentAQI"), let text = UserDefaults.init(suiteName: GROUPIDENTIFIER)?.string(forKey: "alertText")  {
//                }
                
            }
            
            
            
            if let image = UserDefaults.init(suiteName: GROUPIDENTIFIER)?.string(forKey: "imageName") {
                print(image)
                thumnailImv.image = UIImage.init(named: "\(image)1")
                view.layoutIfNeeded()
            }
        }
        

    }
    
    @objc func moveToApp(sender:UIButton) {
        
        if let url = URL.init(string: "miseMain://") {
            
            self.extensionContext?.open(url, completionHandler: nil)
        }
        
    }
    
    
    
    
    
}
