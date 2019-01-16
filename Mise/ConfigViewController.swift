//
//  ConfigViewController.swift
//  Mise
//
//  Created by Seongchan Kang on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    
    let btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        btn.addTarget(self, action: #selector(popView), for: .touchUpInside)
        
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        btn.setBackgroundColor(color: .red, forState: .normal)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
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
