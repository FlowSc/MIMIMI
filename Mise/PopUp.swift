//
//  PopUp.swift
//  Mise
//
//  Created by Kang Seongchan on 17/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import Foundation
import UIKit

class PopUpView:UIView {
    
    let baseView = UIView()
    let popupView = UIView()
    let removeGesture = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        self.addSubview([baseView, popupView])
        removeGesture.addTarget(self, action: #selector(removePopup))
        baseView.addGestureRecognizer(removeGesture)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        baseView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        popupView.snp.makeConstraints { (make) in
            make.center.equalTo(baseView.snp.center)
            make.width.equalTo(300)
            make.height.equalTo(400)
        }
        popupView.backgroundColor = .white
        
    }
    
    @objc func removePopup() {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

struct PopUp {
    
    static func info(vc:UIViewController) {
        
        let pv = PopUpView()
        vc.view.addSubview(pv)
        pv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}
