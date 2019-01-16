//
//  ProductDetailViewController.swift
//  Mise
//
//  Created by Seongchan Kang on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    let btn = UIButton()
    var ImageTitle:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.view.addSubview([btn])
        
        btn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        btn.backgroundColor = .red
        
        if let _imgTitle = ImageTitle {
            print(_imgTitle)
        }
        btn.addTarget(self, action: #selector(buyProduct(sender:)), for: .touchUpInside)

    }
    
    func setData(title:String) {
        
        self.ImageTitle = title
        
    }
    
    @objc func buyProduct(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        if let _imgTitle = ImageTitle {
            print(_imgTitle)
            SELECTEDMASKIMAGE = _imgTitle
            
            UserDefaults.standard.set(_imgTitle, forKey: "currentMask")
            
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        
        sender.isUserInteractionEnabled = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
