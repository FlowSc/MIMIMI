//
//  PopUp.swift
//  Mise
//
//  Created by Kang Seongchan on 17/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class PopUpView:UIView, WKUIDelegate, WKNavigationDelegate {
    
    let baseView = UIView()
    let popupView = UIView()
    let titleLb = UILabel()
    let removeGesture = UITapGestureRecognizer()
    let infoWebView = WKWebView()
    
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
            make.width.equalTo(310)
            make.height.equalTo(500)
        }
        popupView.setBorder(color: .clear, width: 0.1, cornerRadius: 3)
        popupView.addSubview([infoWebView])
        
//        titleLb.snp.makeConstraints { (make) in
//            make.leading.equalTo(10)
//            make.centerX.equalToSuperview()
//            make.top.equalTo(10)
//            make.height.equalTo(40)
//        }
        infoWebView.uiDelegate = self
        infoWebView.navigationDelegate = self
        
        infoWebView.snp.makeConstraints { (make) in
           make.edges.equalToSuperview()
        }
//        infoWebView.load
        popupView.backgroundColor = .white
        
    }
    
    func setData(title:String, url:String) {
        
        let urlRequest = URLRequest.init(url: URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        
        titleLb.attributedText = title.makeAttrString(font: .NotoSans(.bold, size: 30), color: .black)
        titleLb.textAlignment = .center
        infoWebView.load(urlRequest)
        
        
        
    }
    
    @objc func removePopup() {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

struct PopUp {
    
    static func info(vc:UIViewController, title:String, url:String) {
        
        let pv = PopUpView()
        vc.view.addSubview(pv)
        pv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        pv.setData(title: title, url: url)
        
    }
}
