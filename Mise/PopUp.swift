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

class PurhcasePopUpView:UIView {
    
    let baseView = UIView()
    let popupView = UIView()
    let titleLb = UILabel()
    let buttonView = UIView()
    let buyBtn = BottomButton()
    let cancelButton = BottomButton()
    var delegate:PurchasePopupDelegate?
    let infoLb = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview([baseView, popupView])
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        baseView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        popupView.snp.makeConstraints { (make) in
            make.center.equalTo(baseView.snp.center)
            make.width.equalTo(310)
            make.height.equalTo(320)
        }
        popupView.setBorder(color: .clear, width: 0.1, cornerRadius: 3)
        popupView.addSubview([buttonView, infoLb])
        buttonView.addSubview([buyBtn, cancelButton])
        
        buttonView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        infoLb.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonView.snp.top)
        }
        infoLb.numberOfLines = 0
        infoLb.attributedText = "PurchaseInfo".localized.makeAttrString(font: .NotoSans(.bold, size: 15), color: .black)
        infoLb.textAlignment = .center
        buyBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(60)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.equalTo(60)
            make.leading.equalTo(buyBtn.snp.trailing).offset(10)
            make.width.equalTo(buyBtn.snp.width)
        }
        
        cancelButton.addTarget(self, action: #selector(removePopup), for: .touchUpInside)
        cancelButton.setAttributedTitle("purchaseNo".localized.makeAttrString(font: .NotoSans(.bold, size: 15), color: .black), for: .normal)
        buyBtn.setAttributedTitle("purchaseOk".localized.makeAttrString(font: .NotoSans(.bold, size: 15), color: .black), for: .normal)
        buyBtn.addTarget(self, action: #selector(buy(sender:)), for: .touchUpInside)
        popupView.backgroundColor = .white
        
    }
    
    @objc func buy(sender:UIButton) {
        
        delegate?.callAppstore(sender: sender)
    }
    
    @objc func removePopup() {
        self.removeFromSuperview()
    }
}

protocol PurchasePopupDelegate {
    func callAppstore(sender:UIButton)
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
    
    static func purchase(vc:UIViewController) {
        let pv = PurhcasePopUpView()
        vc.parent?.view.addSubview(pv)
        pv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
