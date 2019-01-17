//
//  MenuTableViewCell.swift
//  Mise
//
//  Created by Seongchan Kang on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewCell:UITableViewCell {
    
    let leftImv = UIImageView()
    let titleLb = UILabel()
    let infoLb = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(img:UIImage, title:String, infoString:String?) {
        self.leftImv.image = img
        self.titleLb.attributedText = title.makeAttrString(font: .NotoSans(.bold, size: 15), color: .black)

        
        if let _info = infoString {
            infoLb.isHidden = false
            self.infoLb.attributedText = _info.makeAttrString(font: .NotoSans(.bold, size: 13), color: .black)

        }else{
            infoLb.isHidden = true
        }
        
        
    }
    
    private func setUI() {
    
        self.selectionStyle = .none
        self.addSubview([leftImv, titleLb, infoLb])
        
        leftImv.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(40)
        }
        titleLb.snp.makeConstraints { (make) in
            make.left.equalTo(leftImv.snp.right).offset(25)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
        infoLb.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
            make.trailing.equalTo(-20)
        }
        infoLb.isHidden = true
        infoLb.textAlignment = .right

    }
    
}
