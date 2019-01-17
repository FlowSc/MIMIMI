//
//  InfoView.swift
//  Mise
//
//  Created by Seongchan Kang on 15/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit

class InfoView: UIView {

    var titleLb = UILabel()
    var infoLb = UILabel()
    var info2Lb = UILabel()
    var divider = UIView()
    var tapGesture = UITapGestureRecognizer()
    var delegate:InfoViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        
        
    }
    
    convenience init(title:String, value:String, tag:Int) {
        self.init()
        self.isUserInteractionEnabled = true
        self.titleLb.attributedText = title.makeAttrString(font: .NotoSans(.bold, size: 20), color: .white)
        self.infoLb.attributedText = value.makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
        self.tag = tag
        
        if tag != 6 {
            
            if let aqi = Int(infoLb.text ?? "0") {
                
                switch aqi {
                    
                case 0...50 :
                    info2Lb.attributedText = "좋음".makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
                case 51...100:
                    info2Lb.attributedText = "보통".makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
                case 101...150:
 info2Lb.attributedText = "민감군영향".makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
                case 151...200:
 info2Lb.attributedText = "나쁨".makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
                case 201...300:
 info2Lb.attributedText = "매우나쁨".makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
                case 300...1000:
 info2Lb.attributedText = "위험".makeAttrString(font: .NotoSans(.bold, size: 18), color: .white)
                default:
                    break
                    
                }
            }else{
                info2Lb.isHidden = true
            }
            
        }
        
    }
    
    private func setUI() {
        self.addSubview([titleLb, infoLb, divider, info2Lb])
        self.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(callPopUp))
        titleLb.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(3)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        divider.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        divider.backgroundColor = UIColor.init(white: 189/255, alpha: 1)
        self.setBorder(color: UIColor.init(white: 189/255, alpha: 1), width: 0.5)
        titleLb.textAlignment = .center
        titleLb.adjustsFontSizeToFitWidth = true
        infoLb.textAlignment = .center
        infoLb.adjustsFontSizeToFitWidth = true

        info2Lb.textAlignment = .center
        info2Lb.adjustsFontSizeToFitWidth = true
        
        infoLb.snp.makeConstraints { (make) in
            make.leading.equalTo(2)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom)
        }
        info2Lb.snp.makeConstraints { (make) in
            make.leading.equalTo(2)
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLb.snp.bottom).offset(1)
            make.bottom.equalTo(-2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func callPopUp() {
        delegate?.callDetailPopUp(sender: self.tag)
    }
    
}

protocol InfoViewDelegate {
    
    func callDetailPopUp(sender:Int)
}
