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

    @IBOutlet weak var leftMenuView: UIView!
    var bannerView: GADBannerView!
    let baseScrollView = BaseVerticalScrollView()
    let thumImageView = UIImageView()
    let locationLb = UILabel()
    let dustLb = UILabel()
    let infoStackView = UIStackView()
    let infoStackView2 = UIStackView()
    let alertLb = UILabel()
    let tapGesture = UITapGestureRecognizer()
    let emptyView = UIView()
    let mapView = MKMapView()
    var annotations:[MKAnnotation] = []
    var dismissGesture = UITapGestureRecognizer()
    var locationManager:CLLocationManager!
    var canUpdated:Bool {
            return CLLocationManager.locationServicesEnabled()
    }
    let menuBtn = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUI()
                
        UserDefaults.init(suiteName: GROUPIDENTIFIER)?.set(SELECTEDMASKIMAGE, forKey: "imageName")

        
        self.navigationController?.isNavigationBarHidden = true

        locationManager = CLLocationManager()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        dismissGesture.addTarget(self, action: #selector(dismissMenu))

    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5) {
            self.leftMenuView.snp.updateConstraints { (make) in
                make.leading.equalTo(self.view.snp.leading).offset(-self.view.bounds.width)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        getInfo()
        UserDefaults.init(suiteName: GROUPIDENTIFIER)?.set(SELECTEDMASKIMAGE, forKey: "imageName")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         getInfo()
    }
    
    @objc func callMenu(sender:UIButton) {
        
        sender.isSelected = !(sender.isSelected)
        
        if sender.isSelected {

            self.baseScrollView.contentView.addGestureRecognizer(dismissGesture)
            UIView.animate(withDuration: 0.5) {
                self.leftMenuView.snp.updateConstraints { (make) in
                    make.leading.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
        }else{
            self.baseScrollView.contentView.removeGestureRecognizer(dismissGesture)

            UIView.animate(withDuration: 0.5) {
                self.leftMenuView.snp.updateConstraints { (make) in
                    make.leading.equalTo(self.view.snp.leading).offset(-self.view.bounds.width)
                }
                self.view.layoutIfNeeded()
            }
        }


        
    }
    
    func setUI() {

        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.view.backgroundColor = UIColor.wellGreen

        baseScrollView.contentView.addSubview([thumImageView, locationLb, dustLb, infoStackView, infoStackView2, alertLb, mapView, bannerView, menuBtn])
        view.addSubview([baseScrollView])
        baseScrollView.setScrollView(vc: self)

        baseScrollView.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        
        menuBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(40)
        }
        
        menuBtn.addTarget(self, action: #selector(callMenu(sender:)), for: .touchUpInside)
        menuBtn.setImage(UIImage.init(named: "menu"), for: .normal)
        
        tapGesture.addTarget(self, action: #selector(shaking))
        thumImageView.addGestureRecognizer(tapGesture)
        thumImageView.isUserInteractionEnabled = true

        thumImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(270)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(250)
        }
        
        locationLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(thumImageView.snp.top).offset(-20)
            make.leading.equalTo(10)
//            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        alertLb.snp.makeConstraints { (make) in
            make.bottom.equalTo(locationLb.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
        }
        alertLb.textAlignment = .center
        alertLb.numberOfLines = 2
        alertLb.adjustsFontSizeToFitWidth = true
        locationLb.numberOfLines = 0
        locationLb.textAlignment = .center
        dustLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(thumImageView.snp.bottom).offset(20)
            make.leading.equalTo(10)
        }
        
        dustLb.adjustsFontSizeToFitWidth = true
        infoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(dustLb.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        infoStackView2.snp.makeConstraints { (make) in
            make.top.equalTo(infoStackView.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()

        }
        
        mapView.snp.makeConstraints { (make) in
            make.height.equalTo(400)
            make.top.equalTo(infoStackView2.snp.bottom).offset(40)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
//            make.bottom.equalTo(-20)
        }
        mapView.showsUserLocation = true

        infoStackView.axis = .horizontal
        infoStackView.distribution = .fillEqually
        infoStackView2.distribution = .fillEqually
        infoStackView2.spacing = 0
        infoStackView.spacing = 0
        dustLb.textAlignment = .center
        thumImageView.contentMode = .scaleAspectFit
        bannerView.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        leftMenuView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(-view.bounds.width)
            make.top.equalToSuperview()
        }
        
        view.bringSubviewToFront(leftMenuView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

    }
    
    @objc func shaking() {
        thumImageView.shake()
        getInfo()
    }
    
    func setData(_ weatherData:WeatherData, locationName:String) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        print(weatherData.time)
        print("TIMEIS")
        
        if let dt = dateFormatter.date(from: weatherData.time) {
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            
            let std = dateFormatter.string(from: dt)
            UserDefaults.init(suiteName: GROUPIDENTIFIER)?.set(std, forKey: "time")

                    self.locationLb.attributedText = "\(locationName)\n\(std)".makeAttrString(font: .NotoSans(.bold, size: 20), color: .white)
        }else{
                self.locationLb.attributedText = "\(locationName)".makeAttrString(font: .NotoSans(.bold, size: 20), color: .white)
        }

    

        
        _ = self.infoStackView.arrangedSubviews.map({$0.removeFromSuperview()})
        _ = self.infoStackView2.arrangedSubviews.map({$0.removeFromSuperview()})


        switch weatherData.dominentpol {
            
        case "pm25":
            self.dustLb.attributedText = "초미세먼지: \(weatherData.aqi) ㎍/m³".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)

        case "pm10":
            self.dustLb.attributedText = "미세먼지: \(weatherData.aqi) ㎍/m³".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)

        case "o3":
            self.dustLb.attributedText = "오존: \(weatherData.aqi / 1000)ppm³".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)

        case "so2":
            self.dustLb.attributedText = "이산화황: \(weatherData.aqi) ㎍/m³".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)

        case "no2":
            self.dustLb.attributedText = "이산화질소: \(weatherData.aqi) ㎍/m³".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)

        case "co":
            self.dustLb.attributedText = "일산화탄소: \(weatherData.aqi) ㎍/m³".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
        default:
            break

        }
        
        
        
//        UserDefaults.init(suiteName: <#T##String?#>)

        
        locationLb.numberOfLines = 2
        locationLb.adjustsFontSizeToFitWidth = true
        
        switch weatherData.alertLevel! {
            
        case .bad:
            self.alertLb.attributedText = "뭐, 나가도 괜찮습니다.\n목숨이 아깝지 않다면.".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)4")
            self.view.backgroundColor = UIColor.unhealthyRed

        case .danger:
            self.alertLb.attributedText = "목숨이 아깝지 않더라도\n나가지 말아야 할 때가 있습니다.".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)6")
            self.view.backgroundColor = UIColor.hazardPurple

        case .little:
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)3")
            self.view.backgroundColor = UIColor.unhealthyTangerine
            self.alertLb.attributedText = "목이 칼칼하다면\n기분탓은 아닐겁니다.".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)

        case .normal:
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)2")
            self.view.backgroundColor = UIColor.normalYellow
            self.alertLb.attributedText = "이정도는 이제 익숙해졌습니다.".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)

        case .safe:
//            self.alertLb.attributedText = "목숨이 아깝지 않더라도\n나가지 말아야 할 때가 있습니다.".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
//            self.thumImageView.image = UIImage.init(named: "basicMask6")
//            self.view.backgroundColor = UIColor.hazardPurple

            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)1")
            self.alertLb.attributedText = "산책나가는 것을\n두려워 하지 않아도 됩니다.".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            self.view.backgroundColor = UIColor.wellGreen

        case .veryBad:
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)5")
            self.alertLb.attributedText = "뭐, 나가도 괜찮습니다.\n목숨이 아깝지 않다면.".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            self.view.backgroundColor = UIColor.unhealthyPurple


        }
        
        UserDefaults.init(suiteName: GROUPIDENTIFIER)?.set(self.dustLb.text ?? "", forKey: "domimentAQI")
        UserDefaults.init(suiteName: GROUPIDENTIFIER)?.set(self.alertLb.text ?? "", forKey: "alertText")
        let nformatter = NumberFormatter()

        nformatter.maximumFractionDigits = 3
        
        
        let v1 = InfoView.init(title: "이산화질소", value: "\(weatherData.no2 ?? 0) ppm", tag:0) // 습도
        let v2 = InfoView.init(title: "오존", value: "0\(nformatter.string(from: (NSNumber.init(value: (weatherData.o3 ?? 0) / 1000))) ?? "0")ppm", tag:1) // 오존
        let v3 = InfoView.init(title: "이산화황", value: "\(weatherData.so2 ?? 0) ppm", tag:2) // 이산화황
        let v4 = InfoView.init(title: "초미세먼지", value: "\(weatherData.pm25 ?? 0) ㎍/m³", tag:3) // 초미세먼지
        let v5 = InfoView.init(title: "미세먼지", value: "\(weatherData.pm10 ?? 0) ㎍/m³", tag:4) // 미세먼지
//        let v6 = InfoView.init(title: "Pressure", value: "\(weatherData.pressure ?? 0)") // 기압
//        let v7 = InfoView.init(title: "Wind", value: "\(weatherData.wind ?? 0)") // 풍향
        let v8 = InfoView.init(title: "일산화탄소", value: "\(weatherData.co ?? 0) ㎍/m³", tag:5) // 일산화탄소
        let v9 = InfoView.init(title: "기온", value: "\(weatherData.temperature ?? 0) °C", tag:6) // 기온
//        let v10 = InfoView.init(title: "rain", value: "\(weatherData.rain ?? 0)") // 강수확률

        
        _ = [v3, v4, v5].map({
            infoStackView.addArrangedSubview($0)
            $0.delegate = self
        })
        
        if weatherData.temperature == nil {
            _ = [v8, v2, v1].map({
                infoStackView2.addArrangedSubview($0)
                $0.delegate = self
            })
        }else{
            _ = [v8, v9, v2, v1].map({
                infoStackView2.addArrangedSubview($0)
                $0.delegate = self
            })
        }


    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 12000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getInfo() {
        
        locationManager.startUpdatingLocation()


        if let myLocation = locationManager.location {

            print(myLocation, "MYLOCATION")

            CLGeocoder().reverseGeocodeLocation(myLocation, preferredLocale: Locale.init(identifier: "en")) { (places, error) in


                if let place = places?[0] {
                    
                    CustomAPI.getDust(lat:"\(myLocation.coordinate.latitude)", lng: "\(myLocation.coordinate.longitude)", completion: { (weather) in

                        var weatherr = weather

                        if weather.temperature == nil {
                            

                            CustomAPI.getDust(city: place.administrativeArea ?? "", completion: { (weather) in
                                
                                
                                if let _weather = weather {
                                    weatherr.setTemperature(_weather.temperature)
                                    print("temerature nil")
                                    UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                                    self.centerMapOnLocation(myLocation, mapView: self.mapView)
                                    self.setData(weatherr, locationName: _weather.name)
                                }else{
                                    CustomAPI.getDust(city: place.subAdministrativeArea ?? "", completion: { (weather) in
                                        if let _weather = weather {
                                            weatherr.setTemperature(_weather.temperature)
                                            print("temerature nil")
//                                            place.
                                            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                                            self.centerMapOnLocation(myLocation, mapView: self.mapView)
                                            self.setData(weatherr, locationName: _weather.name)
                                        }
                                    })
                                }
                                
                             
                            })
                            
                        }else{
                            self.centerMapOnLocation(myLocation, mapView: self.mapView)
                            
                            self.setData(weatherr, locationName: weatherr.name)
                        }
                    
                    })
                }
            }
        }
        

//            if let myLocation = locationManager.location {
//
//                UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
//
//                print(myLocation)
//
//                CLGeocoder().reverseGeocodeLocation(myLocation) { (places, error) in
//
//                    if let place = places?[0] {
//                        print(place)
//                        print("~~")
//
//                        CustomAPI.getDust(city: place.administrativeArea!, completion: { (weather) in
//                            print(weather)
//
//                            self.setData(weather, locationName: weather.name)
//                            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
//
//                        })
//                    }
//                }
//            }
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
            locationManager.startUpdatingLocation()
            getInfo()

        case .authorizedWhenInUse:
            print(" case .authorizedWhenInUse:")
            locationManager.startUpdatingLocation()
            getInfo()

        case .denied:
            print(" case .denied:")

        case .restricted:
            print(" case .restricted:")

        case .notDetermined:
//            locationManager.requestLocation()
            locationManager.requestAlwaysAuthorization()
        
//            manager.completion
        

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

extension MainViewController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if !(annotation is MKUserLocation) {
            let annotationV = SignAnnotationView.init(annotation: annotation, reuseIdentifier: nil)
            annotationV.canShowCallout = true
            
            
            return annotationV
        }else{
            return nil
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {

        CustomAPI.getDustMap(topLeft: mapView.convert(CGPoint.init(x: 0, y: 0), toCoordinateFrom: mapView), bottomRight: mapView.convert(CGPoint.init(x: mapView.bounds.width, y: mapView.bounds.height), toCoordinateFrom: mapView)) { (annos) in

            var currentAnnos:[MKAnnotation] = []
            
            _ = annos.map({
                let annotation = MKPointAnnotation.init()
                annotation.coordinate = $0.geo
                annotation.title = $0.aqi
                currentAnnos.append(annotation)
            })
            self.annotations = currentAnnos
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(self.annotations)

        }

        
    }
    
}

extension MainViewController:InfoViewDelegate {
    func callDetailPopUp(sender: Int) {
        print(sender)
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
