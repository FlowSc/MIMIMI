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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        
        
    }
    
    convenience init(title:String, value:String) {
        self.init()
        self.titleLb.text = title
        self.infoLb.text = value
    }
    
    private func setUI() {
        self.addSubview([titleLb, infoLb, divider])
        
        titleLb.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        divider.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        divider.backgroundColor = .black
        self.setBorder(color: .black, width: 1)
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
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
