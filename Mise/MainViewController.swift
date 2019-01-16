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
    
    var locationManager:CLLocationManager!
    var canUpdated:Bool {
            return CLLocationManager.locationServicesEnabled()
    }
    let menuBtn = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUI()

        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        

    }
    
    @objc func callMenu(sender:UIButton) {
        
        sender.isSelected = !(sender.isSelected)
        
        if sender.isSelected {
            UIView.animate(withDuration: 0.5) {
                self.leftMenuView.snp.updateConstraints { (make) in
                    make.leading.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
        }else{
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

        baseScrollView.contentView.addSubview([thumImageView, locationLb, dustLb, infoStackView, infoStackView2, alertLb, mapView, bannerView, menuBtn])
        view.addSubview([baseScrollView])
        baseScrollView.setScrollView(vc: self)

        baseScrollView.snp.remakeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        
        menuBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(50)
        }
        
        menuBtn.addTarget(self, action: #selector(callMenu(sender:)), for: .touchUpInside)
        menuBtn.setImage(UIImage.init(named: "menu"), for: .normal)
        
        tapGesture.addTarget(self, action: #selector(shaking))
        thumImageView.addGestureRecognizer(tapGesture)
        thumImageView.isUserInteractionEnabled = true

        thumImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(220)
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
        
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let dt = dateFormatter.date(from: weatherData.time)

        dateFormatter.dateFormat = "yyyy년 MM 월 dd일 hh시 mm분 기준"
        
        let std = dateFormatter.string(from: dt!)

        
        _ = self.infoStackView.arrangedSubviews.map({$0.removeFromSuperview()})
        _ = self.infoStackView2.arrangedSubviews.map({$0.removeFromSuperview()})

        self.locationLb.attributedText = "\(locationName)\n\(std)".makeAttrString(font: .NotoSans(.bold, size: 20), color: .white)
        self.dustLb.attributedText = "\(weatherData.dominentpol): \(weatherData.aqi) ㎍/m³".makeAttrString(font: .NotoSans(.bold, size: 25), color: .white)
        locationLb.numberOfLines = 2
        locationLb.adjustsFontSizeToFitWidth = true
        
        switch weatherData.alertLevel! {
            
        case .bad:
            self.alertLb.text = "나가면 죽어요,,"
            self.thumImageView.image = UIImage.init(named: "gas-mask-1")

        case .danger:
            self.alertLb.text = "나가면 죽어요,,"

            self.thumImageView.image = UIImage.init(named: "gas-mask-2")

        case .little:
            self.thumImageView.image = UIImage.init(named: "gas-mask-3")
            self.alertLb.text = "나가면 아파요,,"

        case .normal:
            self.thumImageView.image = UIImage.init(named: "gas-mask-1")
            self.view.backgroundColor = UIColor.init(red: 27/255, green: 130/255, blue: 0/255, alpha: 1)
            self.alertLb.attributedText = "그래도 살만한 세상,,".makeAttrString(font: .NotoSans(.bold, size: 25), color: .white)

        case .safe:
            self.thumImageView.image = UIImage.init(named: "gas-mask-5")
            self.alertLb.text = "오랜만에 여행갑시다,,"

        case .veryBad:
            self.thumImageView.image = UIImage.init(named: "gas-mask-1")
            self.alertLb.text = "나가면 죽어요,,"

        }
        
//        let v1 = InfoView.init(title: "Humidity", value: "\(weatherData.humidity ?? 0)") // 습도
        let v2 = InfoView.init(title: "오존", value: "\(weatherData.o3 ?? 0) ppm") // 오존
        let v3 = InfoView.init(title: "이산화황", value: "\(weatherData.so2 ?? 0) ppm") // 이산화황
        let v4 = InfoView.init(title: "초미세먼지", value: "\(weatherData.pm25 ?? 0) ㎍/m³") // 초미세먼지
        let v5 = InfoView.init(title: "미세먼지", value: "\(weatherData.pm10 ?? 0) ㎍/m³") // 미세먼지
//        let v6 = InfoView.init(title: "Pressure", value: "\(weatherData.pressure ?? 0)") // 기압
//        let v7 = InfoView.init(title: "Wind", value: "\(weatherData.wind ?? 0)") // 풍향
        let v8 = InfoView.init(title: "일산화탄소", value: "\(weatherData.co ?? 0) ㎍/m³") // 일산화탄소
        let v9 = InfoView.init(title: "기온", value: "\(weatherData.temperature ?? 0) °C") // 기온
//        let v10 = InfoView.init(title: "rain", value: "\(weatherData.rain ?? 0)") // 강수확률

        
        _ = [v3, v4, v5].map({infoStackView.addArrangedSubview($0)})
        _ = [v8, v9, v2].map({infoStackView2.addArrangedSubview($0)})

    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getInfo() {
        
        if let myLocation = locationManager.location {

            CLGeocoder().reverseGeocodeLocation(myLocation) { (places, error) in

                if let place = places?[0] {

                    CustomAPI.getDust(lat:"\(myLocation.coordinate.latitude)", lng: "\(myLocation.coordinate.longitude)", completion: { (weather) in

                        self.centerMapOnLocation(myLocation, mapView: self.mapView)

                        self.setData(weather, locationName: place.locality ?? weather.name)

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
            getInfo()

        case .authorizedWhenInUse:
            print(" case .authorizedWhenInUse:")
            getInfo()

        case .denied:
            print(" case .denied:")

        case .restricted:
            print(" case .restricted:")

        case .notDetermined:
//            locationManager.requestLocation()
            locationManager.requestAlwaysAuthorization()

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
            let annotationV = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: nil)
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
