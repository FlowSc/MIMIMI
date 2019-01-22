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
    let aqiNoticeLb = UILabel()
    var dismissGesture = UITapGestureRecognizer()
    var locationManager:CLLocationManager!
    var canUpdated:Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    var questionImv = UIImageView.init(image: UIImage.init(named: "question")!)
    let menuBtn = UIButton()
    var infoCallGesture = UITapGestureRecognizer()
    
    @objc func callInfoPopup() {
        
        PopUp.info(vc: self, title: "AQItitle".localized, url: "aqiUrl".localized)
        
    }
    
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
        self.menuBtn.isSelected = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        getInfo()
        checkPro()
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
        
//        UserDefaults.standard.set(false, forKey: "isProversion")

        
        LoadingIndicator.start(vc: self)

        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.view.backgroundColor = UIColor.white
        
        baseScrollView.contentView.addSubview([thumImageView, locationLb, dustLb, infoStackView, infoStackView2, alertLb, mapView, bannerView, menuBtn, aqiNoticeLb, questionImv])
        view.addSubview([baseScrollView])
        baseScrollView.setScrollView(vc: self)
        
        baseScrollView.snp.remakeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-50)
        }

        
        menuBtn.addTarget(self, action: #selector(callMenu(sender:)), for: .touchUpInside)
        menuBtn.setImage(UIImage.init(named: "menu"), for: .normal)
        
        tapGesture.addTarget(self, action: #selector(shaking))
        thumImageView.addGestureRecognizer(tapGesture)
        thumImageView.isUserInteractionEnabled = true
        

        menuBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(10)
        
        }
        alertLb.snp.makeConstraints { (make) in
            make.top.equalTo(menuBtn.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.equalTo(10)
        }
        
        locationLb.snp.makeConstraints { (make) in
            make.top.equalTo(alertLb.snp.bottom).offset(20)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
        }
        

        thumImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(locationLb.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(250)
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
        
        
        
        questionImv.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.trailing.equalTo(-10)
            make.top.equalTo(dustLb.snp.bottom).offset(10)
        }
        aqiNoticeLb.snp.makeConstraints { (make) in
//            make.top.equalTo(dustLb.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(questionImv.snp.leading).offset(-10)
            make.centerY.equalTo(questionImv.snp.centerY)
        }
        
        aqiNoticeLb.addGestureRecognizer(infoCallGesture)
        questionImv.addGestureRecognizer(infoCallGesture)
        infoCallGesture.addTarget(self, action: #selector(callInfoPopup))
        aqiNoticeLb.isUserInteractionEnabled = true
        aqiNoticeLb.adjustsFontSizeToFitWidth = true
        questionImv.isUserInteractionEnabled = true
        aqiNoticeLb.isHidden = true
        questionImv.isHidden = true
        
        aqiNoticeLb.textAlignment = .right
        
        aqiNoticeLb.attributedText = "AQItitle".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
        
        dustLb.adjustsFontSizeToFitWidth = true
        infoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(aqiNoticeLb.snp.bottom).offset(10)
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

        bannerView.adUnitID = "ca-app-pub-9212649214874133/6072058333"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        checkPro()
        
    }
    
    func checkPro() {
        
        if UserDefaults.standard.bool(forKey: "isProversion") {
            bannerView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }else{
            bannerView.snp.updateConstraints { (make) in
                make.height.equalTo(50)
            }
        }
        view.layoutIfNeeded()
        
    }
    
    @objc func shaking() {
        thumImageView.shake()
        getInfo()
    }
    
    func setData(_ weatherData:WeatherData, locationName:String) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let dt = dateFormatter.date(from: weatherData.time) {
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            
            let std = dateFormatter.string(from: dt)
            UserDefaults.init(suiteName: GROUPIDENTIFIER)?.set(std, forKey: "time")
            
            if let _ = locationName.components(separatedBy: "(").first{
                
                
                if let aaa = locationName.strstr(needle: "(", beforeNeedle: true) {
                    
                    print(aaa)
                    if let bbb = locationName.strstr(needle: "(", beforeNeedle: false)?.strstr(needle: ")", beforeNeedle: true) {
                        
                        self.locationLb.attributedText = "\(aaa)\n\(bbb)\n\(std)".makeAttrString(font: .NotoSans(.bold, size: 20), color: .white)
                    }
                }else{
                    self.locationLb.attributedText = "\(locationName)\n\(std)".makeAttrString(font: .NotoSans(.bold, size: 20), color: .white)
                }
                
            }
            
            
        }else{
            self.locationLb.attributedText = "\(locationName)".makeAttrString(font: .NotoSans(.bold, size: 20), color: .white)
        }
        
        
        
        
        _ = self.infoStackView.arrangedSubviews.map({$0.removeFromSuperview()})
        _ = self.infoStackView2.arrangedSubviews.map({$0.removeFromSuperview()})
        
        
        switch weatherData.dominentpol {
            
        case "pm25":
            self.dustLb.attributedText = "\("pm25".localized): \(weatherData.aqi)".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            
        case "pm10":
            self.dustLb.attributedText = "\("pm10".localized): \(weatherData.aqi)".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            
        case "o3":
            self.dustLb.attributedText = "\("o3".localized): \(weatherData.aqi / 1000)".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            
        case "so2":
            self.dustLb.attributedText = "\("so2".localized): \(weatherData.aqi)".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            
        case "no2":
            self.dustLb.attributedText = "\("no2".localized): \(weatherData.aqi)".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            
        case "co":
            self.dustLb.attributedText = "\("CO".localized): \(weatherData.aqi)".makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
        default:
            break
            
        }
        
        
        locationLb.numberOfLines = 0
        locationLb.adjustsFontSizeToFitWidth = true
        
        switch weatherData.alertLevel! {
            
        case .bad:
            self.alertLb.attributedText = "badDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)4")
            self.view.backgroundColor = UIColor.unhealthyRed
            
        case .danger:
            self.alertLb.attributedText = "dangerDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)6")
            self.view.backgroundColor = UIColor.hazardPurple
            
        case .little:
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)3")
            self.view.backgroundColor = UIColor.unhealthyTangerine
            self.alertLb.attributedText = "littleBadDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            
        case .normal:
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)2")
            self.view.backgroundColor = UIColor.normalYellow
            self.alertLb.attributedText = "normalDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            
        case .safe:
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)1")
            self.alertLb.attributedText = "safeDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            self.view.backgroundColor = UIColor.wellGreen
            
        case .veryBad:
            self.thumImageView.image = UIImage.init(named: "\(SELECTEDMASKIMAGE)5")
            self.alertLb.attributedText = "veryBadDesc".localized.makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
            self.view.backgroundColor = UIColor.unhealthyPurple
            
            
        }
        
        UserDefaults.init(suiteName: GROUPIDENTIFIER)?.set(self.dustLb.text ?? "", forKey: "domimentAQI")
        UserDefaults.init(suiteName: GROUPIDENTIFIER)?.set(self.alertLb.text ?? "", forKey: "alertText")
        let nformatter = NumberFormatter()
        
        nformatter.maximumFractionDigits = 3
        
        let v1 = InfoView.init(title: "no2".localized, value: "\(Int(weatherData.no2 ?? -100))", tag:0) // 습도
        let v2 = InfoView.init(title: "o3".localized, value: "\(Int(weatherData.o3 ?? -100))", tag:1) // 오존
        let v3 = InfoView.init(title: "so2".localized, value: "\(Int(weatherData.so2 ?? -100))", tag:2) // 이산화황
        let v4 = InfoView.init(title: "pm25".localized, value: "\(Int(weatherData.pm25 ?? -100))", tag:3) // 초미세먼지
        let v5 = InfoView.init(title: "pm10".localized, value: "\(Int(weatherData.pm10 ?? -100))", tag:4) // 미세먼지
        //        let v6 = InfoView.init(title: "Pressure", value: "\(weatherData.pressure ?? 0)") // 기압
        //        let v7 = InfoView.init(title: "Wind", value: "\(weatherData.wind ?? 0)") // 풍향
        let v8 = InfoView.init(title: "CO".localized, value: "\(Int(weatherData.co ?? -100))", tag:5) // 일산화탄소
        let v9 = InfoView.init(title: "Temp".localized, value: "\(weatherData.temperature ?? -100) °C", tag:6) // 기온
        //        let v10 = InfoView.init(title: "rain", value: "\(weatherData.rain ?? 0)") // 강수확률
        
        
        _ = [v3, v4, v5].map({
            infoStackView.addArrangedSubview($0)
            
            if ($0.infoLb.text?.contains("-100"))! {
                    $0.infoLb.attributedText = "unchecked".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
            }
            $0.delegate = self
        })
        
        if weatherData.temperature == nil {
            _ = [v8, v2, v1].map({
                infoStackView2.addArrangedSubview($0)
                if ($0.infoLb.text?.contains("-100"))! {
                    $0.infoLb.attributedText = "unchecked".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
                }
                $0.delegate = self
            })
        }else{
            _ = [v8, v2, v1, v9].map({
                infoStackView2.addArrangedSubview($0)
                if ($0.infoLb.text?.contains("-100"))! {
                    $0.infoLb.attributedText = "unchecked".localized.makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
                }
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
    
    
    func getInfo(location:CLLocation) {
        
        
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "en")) { (places, error) in
            
            
            if let place = places?[0] {
                
                CustomAPI.getDust(lat:"\(location.coordinate.latitude)", lng: "\(location.coordinate.longitude)", completion: { (weather) in
                    
                    var weatherr = weather
                    
                    if weather.temperature == nil {
                        
                        
                        CustomAPI.getDust(city: place.administrativeArea ?? "", completion: { (weather) in
                            
                            
                            if let _weather = weather {
                                weatherr.setTemperature(_weather.temperature)
//                                UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                                self.centerMapOnLocation(location, mapView: self.mapView)
                                self.setData(weatherr, locationName: _weather.name)
                                LoadingIndicator.stop(vc: self)

                            }else{
                                CustomAPI.getDust(city: place.subAdministrativeArea ?? "", completion: { (weather) in
                                    if let _weather = weather {
//                                        UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                                        self.centerMapOnLocation(location, mapView: self.mapView)
                                        self.setData(weatherr, locationName: _weather.name)
                                        LoadingIndicator.stop(vc: self)

                                    }
                                })
                            }
                            
                            
                        })
                        
                    }else{
                        self.centerMapOnLocation(location, mapView: self.mapView)
                        LoadingIndicator.stop(vc: self)
                        self.setData(weatherr, locationName: weatherr.name)
                    }
                    
                })
            }
        }
    }
    
    func getInfo() {
        
        locationManager.startUpdatingLocation()
        
        if let myLocation = locationManager.location {
            
            CLGeocoder().reverseGeocodeLocation(myLocation, preferredLocale: Locale.init(identifier: "en")) { (places, error) in
                
                
                if let place = places?[0] {
                    
                    CustomAPI.getDust(lat:"\(myLocation.coordinate.latitude)", lng: "\(myLocation.coordinate.longitude)", completion: { (weather) in
                        
                        var weatherr = weather
                        print(weatherr)
                        self.aqiNoticeLb.isHidden = false
                        self.questionImv.isHidden = false
                        self.aqiNoticeLb.isUserInteractionEnabled = true
                        
                        _ = Locale.init(identifier: UserDefaults.standard.array(forKey: "AppleLanguages")![0] as! String == "ko" ? "ko":"en")
                        
                        if weather.temperature == nil {
                            

                            CustomAPI.getDust(city: place.administrativeArea ?? "", completion: { (weather) in
                                
                                
                                if let _weather = weather {
                                    weatherr.setTemperature(_weather.temperature)
                                    self.centerMapOnLocation(myLocation, mapView: self.mapView)
                                    self.setData(weatherr, locationName: _weather.name)
                                    self.baseScrollView.scrollView.scrollsToTop = true
                                    self.reloadMapAnnotation(self.mapView)
                                    LoadingIndicator.stop(vc: self)


                                }else{
                                    CustomAPI.getDust(city: place.subAdministrativeArea ?? "", completion: { (weather) in
                                        if let _weather = weather {
                                            weatherr.setTemperature(_weather.temperature)
                                            self.centerMapOnLocation(myLocation, mapView: self.mapView)
                                            self.setData(weatherr, locationName: _weather.name)
                                            self.baseScrollView.scrollView.scrollsToTop = true
                                            self.reloadMapAnnotation(self.mapView)
                                            LoadingIndicator.stop(vc: self)


                                        }
                                    })
                                }
                            })
                        }else{
                            self.centerMapOnLocation(myLocation, mapView: self.mapView)
                            self.reloadMapAnnotation(self.mapView)
                            self.baseScrollView.scrollView.scrollsToTop = true
                            self.setData(weatherr, locationName: weatherr.name)
                            LoadingIndicator.stop(vc: self)

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

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .authorizedAlways:
            print(" case .authorizedAlways:")
            locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.getInfo()
            }
            
        case .authorizedWhenInUse:
            print(" case .authorizedWhenInUse:")
            locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.getInfo()
            }
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
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        if let selectedLocation = view.annotation?.coordinate {
            
            let location = CLLocation.init(coordinate: selectedLocation, altitude: CLLocationDistance.init(), horizontalAccuracy: .init(), verticalAccuracy: .init(), timestamp: .init())
            self.getInfo(location:location)
            
            reloadMapAnnotation(mapView)

        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if !(annotation is MKUserLocation) {
            let annotationV = SignAnnotationView.init(annotation: annotation, reuseIdentifier: nil)
            //            annotationV.canShowCallout = true
            
            return annotationV
        }else{
            return nil
        }
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {

        reloadMapAnnotation(mapView)
    }
    
    func reloadMapAnnotation(_ mapView:MKMapView) {
        
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
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
        
        
        
    }
    
}

extension MainViewController:InfoViewDelegate {
    func callDetailPopUp(sender: Int) {
        print(sender)
        
//        switch sender {
//        case 0:
//            PopUp.info(vc: self, title: "no2".localized, url: "no2Url".localized)
//            
//        case 1:
//            PopUp.info(vc: self, title: "o3".localized, url: "o3Url".localized)
//
//        case 2:
//            PopUp.info(vc: self, title: "so2".localized, url: "so2Url".localized)
//
//        case 3:
//            PopUp.info(vc: self, title: "pm25".localized, url: "pmUrl".localized)
//
//        case 4:
//            PopUp.info(vc: self, title: "pm10".localized, url: "pmUrl".localized)
//
//        case 5:
//            PopUp.info(vc: self, title: "CO".localized, url: "coUrl".localized)
//
//        case 6:
////            PopUp.info(vc: self, title: "AQI?", url: "https://ko.m.wikipedia.org/wiki/대기질_지수")
//            break
//        default:
//            break
//            
//        }
//        PopUp.info(vc: <#T##UIViewController#>)
//        PopUp.info(vc: self)
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

extension String {
    
    func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
        guard let range = self.range(of: needle) else { return nil }
        
        if beforeNeedle {
            return self.substring(to: range.lowerBound)
        }
        
        return self.substring(from: range.upperBound)
    }
    
}
