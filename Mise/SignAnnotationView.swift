//
//  SignAnnotationView.swift
//  Mise
//
//  Created by Kang Seongchan on 17/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit
import MapKit

class SignAnnotationView: MKAnnotationView {
    
    let baseView = UIView()
    let signImageView = UIImageView()
    let aqiLb = UILabel()
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setUI()
        self.isUserInteractionEnabled = true

        setData(annotation: annotation!)

    }
    
    func setData(annotation:MKAnnotation) {

        
        if let aqiInt = annotation.title?.flatMap({Int($0)}) {
            
                      aqiLb.attributedText = "\(aqiInt)".makeAttrString(font: .NotoSans(.bold, size: 10), color: .white)
            
            switch aqiInt {
                
            case 0...50 :
                signImageView.image = UIImage.init(named: "sign-3")
            case 51...100:
                signImageView.image = UIImage.init(named: "sign")
            case 101...150:
               signImageView.image = UIImage.init(named: "sign-5")
            case 151...200:
               signImageView.image = UIImage.init(named: "sign-4")
            case 201...300:
               signImageView.image = UIImage.init(named: "sign-2")
            case 300...1000:
               signImageView.image = UIImage.init(named: "sign-6")
            default:
                break
            }
            
        }
        
//
//        annotation?.
    
//        if let aqiInt = Int(annotation.title ?? "0") {
//
//        }
//
    }
    
    func setUI() {
        
        self.addSubview(baseView)
        self.baseView.addSubview([signImageView, aqiLb])
        
        baseView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        signImageView.image = UIImage.init(named: "flags")
        signImageView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        aqiLb.snp.makeConstraints { (make) in
            make.top.equalTo(signImageView.snp.top).offset(2)
            make.leading.equalTo(signImageView.snp.leading).offset(5)
            make.trailing.equalTo(signImageView.snp.trailing).offset(-5)
            make.height.equalTo(10)
        }
//        signImageView.backgroundColor = .white
        aqiLb.textAlignment = .center
        aqiLb.numberOfLines = 1
        aqiLb.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
