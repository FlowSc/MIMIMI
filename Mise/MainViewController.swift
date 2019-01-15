//
//  MainViewController.swift
//  Mise
//
//  Created by Seongchan Kang on 15/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit
import GoogleMobileAds

//import URWeatherView

class MainViewController: UIViewController {

    var bannerView: GADBannerView!
    let baseScrollView = BaseVerticalScrollView()
    let thumImageView = UIImageView()
    let locationLb = UILabel()
    let dustLb = UILabel()
    let infoStackView = UIStackView()
    let infoStackView2 = UIStackView()
    let alertLb = UILabel()
    let tapGesture = UITapGestureRecognizer()

    var locationManager:CLLocationManager!
    var canUpdated:Bool {
            return CLLocationManager.locationServicesEnabled()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUI()
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        

    }
    
    func setUI() {

        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        baseScrollView.addSubview([thumImageView, locationLb, dustLb, infoStackView, infoStackView2, alertLb])
        view.addSubview([baseScrollView, bannerView])

        baseScrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        tapGesture.addTarget(self, action: #selector(shaking))
        thumImageView.addGestureRecognizer(tapGesture)
        thumImageView.isUserInteractionEnabled = true

        thumImageView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
            make.width.equalToSuperview().multipliedBy(0.7)
            
            make.height.equalTo(250)
        }
        
        locationLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(thumImageView.snp.top).offset(-20)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        alertLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(locationLb.snp.top).offset(-10)
            make.centerX.equalToSuperview()
//            make.
        }
        locationLb.numberOfLines = 0
        locationLb.textAlignment = .center
        dustLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(thumImageView.snp.bottom).offset(20)
            make.leading.equalTo(10)
        }
        
        infoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(dustLb.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        infoStackView2.snp.makeConstraints { (make) in
            make.top.equalTo(infoStackView.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        infoStackView.axis = .horizontal
        infoStackView.distribution = .fillEqually
        infoStackView2.distribution = .fillEqually
        infoStackView2.spacing = 0
        infoStackView.spacing = 0
        dustLb.textAlignment = .center
        thumImageView.contentMode = .scaleAspectFit
        bannerView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
//        bannerView.adUnitID = "ca-app-pub-9212649214874133/6072058333"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
//        thumImageView

    }
    
    @objc func shaking() {
        thumImageView.shake()
        getInfo()
    }
    
    func setData(_ weatherData:WeatherData, locationName:String) {
        
        _ = self.infoStackView.arrangedSubviews.map({$0.removeFromSuperview()})
        _ = self.infoStackView2.arrangedSubviews.map({$0.removeFromSuperview()})

        self.locationLb.text = "\(locationName)\n\(weatherData.time)"
        self.dustLb.text = "\(weatherData.dominentpol): \(weatherData.aqi)"
        locationLb.numberOfLines = 0
        
        switch weatherData.alertLevel! {
            
        case .bad:
            self.alertLb.text = "나가면 죽어요,,"
            self.thumImageView.image = UIImage.init(named: "gas-mask-1")

        case .danger:
            self.alertLb.text = "나가면 죽어요,,"

            self.thumImageView.image = UIImage.init(named: "gas-mask-2")

        case .little:
            self.thumImageView.image = UIImage.init(named: "gas-mask-3")
            self.alertLb.text = "나가면 죽어요,,"

        case .normal:
            self.thumImageView.image = UIImage.init(named: "gas-mask-4")
            self.alertLb.text = "나가면 죽어요,,"

        case .safe:
            self.thumImageView.image = UIImage.init(named: "gas-mask-5")
            self.alertLb.text = "나가면 죽어요,,"

        case .veryBad:
            self.thumImageView.image = UIImage.init(named: "gas-mask-1")
            self.alertLb.text = "나가면 죽어요,,"

        }
        
        let v1 = InfoView.init(title: "Humidity", value: "\(weatherData.humidity!)") // 습도
        let v2 = InfoView.init(title: "O3", value: "\(weatherData.o3!)") // 오존
        let v3 = InfoView.init(title: "SO2", value: "\(weatherData.so2!)") // 이산화황
        let v4 = InfoView.init(title: "PM2.5", value: "\(weatherData.pm25!)") // 초미세먼지
        let v5 = InfoView.init(title: "PM10", value: "\(weatherData.pm10!)") // 미세먼지
        let v6 = InfoView.init(title: "Pressure", value: "\(weatherData.pressure!)") // 기압
        let v7 = InfoView.init(title: "Wind", value: "\(weatherData.wind!)") // 풍향
        let v8 = InfoView.init(title: "CO", value: "\(weatherData.co!)") // 일산화탄소
        let v9 = InfoView.init(title: "Temp", value: "\(weatherData.temperature!)") // 기온
        let v10 = InfoView.init(title: "rain", value: "\(weatherData.rain!)") // 강수확률

        
        _ = [v1, v2, v3, v4, v5].map({infoStackView.addArrangedSubview($0)})
        _ = [v6, v7, v8, v9, v10].map({infoStackView2.addArrangedSubview($0)})

    }
    
    func getInfo() {
        
//        if let myLocation = locationManager.location {
//
//            CLGeocoder().reverseGeocodeLocation(myLocation) { (places, error) in
//
//                if let place = places?[0] {
//
//                    CustomAPI.getDust(lat:"\(myLocation.coordinate.latitude)", lng: "\(myLocation.coordinate.longitude)", completion: { (weather) in
//                        print(weather)
//
//                        self.setData(weather, locationName: place.locality ?? weather.name)
//
//                    })
//                }
//            }
        
            if let myLocation = locationManager.location {
                
                UserDefaults.standard.set(["en"], forKey: "AppleLanguages")

                CLGeocoder().reverseGeocodeLocation(myLocation) { (places, error) in
                    
                    if let place = places?[0] {
                        
                        CustomAPI.getDust(city: place.administrativeArea!, completion: { (weather) in
                            print(weather)
                            
                            self.setData(weather, locationName: weather.name)
                            UserDefaults.standard.removeObject(forKey: "AppleLanguages")

                        })
                    }
                }
            }
    }
}

extension MainViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .authorizedAlways:
            print(" case .authorizedAlways:")
            getInfo()

        case .authorizedWhenInUse:
            print(" case .authorizedWhenInUse:")
            getInfo()

        case .denied:
            print(" case .denied:")

        case .restricted:
            print(" case .restricted:")

        case .notDetermined:
            print(" case .notDetermined:")
            
        }
    }
    
//    locatio
    
}

extension MainViewController:GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("RECIED")
    }
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("WILL")
    }
}


extension UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
    
}
