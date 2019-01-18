//
//  IndicatorView.swift
//  Mytom
//
//  Created by TJ Enjoy on 2018. 9. 12..
//  Copyright © 2018년 TJ Enjoy. All rights reserved.
//

import UIKit
import SnapKit

class IndicatorView: UIView {
    
    
    let centerImageView = UIImageView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        buildUI()
        addStyle()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addStyle() {
        centerImageView.image = UIImage.gifImageWithName("copper-loader")
        centerImageView.contentMode = .scaleAspectFit
        
        self.backgroundColor = UIColor.white
        
    }
    
    
    func buildUI() {
        self.addSubviewsAtOnce(centerImageView)
        
        centerImageView.snp.makeConstraints({(make) in
           
           
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
            
        })
    }
    
}

struct LoadingIndicator {
    
    static func start(vc:UIViewController) {
        
//        UIApplication().keyWindow
        
//        if let window = UIApplication().keyWindow {
        
            let v = IndicatorView()
            
            vc.view.addSubview(v)
            v.tag = 77
            v.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            v.layer.zPosition = 100
//        }
        
        
        
    }
    
    static func stop(vc:UIViewController) {
        
//        if let window = UIApplication().keyWindow {
        
        if let lv = vc.view.subviews.filter({$0 is IndicatorView}).first {
            
            print("LVISHERE")
            lv.removeFromSuperview()
            
        }
        
            _ = vc.view.subviews.map{
                
                if $0.tag == 77 {
                    $0.removeFromSuperview()
                }
                
            }
            
//        }
        
    }
}
