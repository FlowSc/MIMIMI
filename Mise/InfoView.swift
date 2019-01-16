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
    }
    
    private func setUI() {
        self.addSubview([titleLb, infoLb, divider])
        self.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(callPopUp))
        titleLb.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
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
        infoLb.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
//            make.height.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom)
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
