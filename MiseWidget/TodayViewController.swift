//
//  TodayViewController.swift
//  MiseWidget
//
//  Created by Seongchan Kang on 17/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit
//import Snap
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var thumnailImv: UIImageView!
    @IBOutlet weak var widgetLb: UILabel!
    @IBOutlet weak var moveToAppBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view from its nib.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
        
//        URLSession.

    }
    
    func setUI() {
        moveToAppBtn.addTarget(self, action: #selector(moveToApp(sender:)), for: .touchUpInside)
        moveToAppBtn.setAttributedTitle("앱에서\n자세히 보기".makeAttrString(font: .NotoSans(.bold, size: 12), color: .white), for: .normal)
        moveToAppBtn.titleLabel?.numberOfLines = 2
        moveToAppBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        moveToAppBtn.titleLabel?.textAlignment = .center
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        setData()

        
        completionHandler(NCUpdateResult.newData)
    }
    
    func setData() {
        let token = "7ba124cd957e5ac93963ee8aa2e8d7eb478d3c12"

        NetworkHandler.getData(url: "http://api.waqi.info/feed/geo:\(33);\(33)/?token=\(token)")
        
        if let time = UserDefaults.init(suiteName: GROUPIDENTIFIER)?.string(forKey: "time"), let aqi = UserDefaults.init(suiteName: GROUPIDENTIFIER)?.string(forKey: "domimentAQI"), let text = UserDefaults.init(suiteName: GROUPIDENTIFIER)?.string(forKey: "alertText")  {
            widgetLb.numberOfLines = 0
            widgetLb.attributedText = "\(time)\n\(aqi)\n\(text)".makeAttrString(font: .NotoSans(.bold, size: 14), color: .white)
        }
        if let image = UserDefaults.init(suiteName: GROUPIDENTIFIER)?.string(forKey: "imageName") {
            print(image)
            thumnailImv.image = UIImage.init(named: "\(image)1")
            view.layoutIfNeeded()
        }
    }
    
    @objc func moveToApp(sender:UIButton) {
        
        if let url = URL.init(string: "miseMain://") {
            
            self.extensionContext?.open(url, completionHandler: nil)
        }
        
    }
    
    
    
    
    
}

class NetworkHandler {
    
    class func getData(url:String) {
        
        let session = URLSession(configuration: .default)
        
        let request = URLRequest.init(url: URL.init(string: url)!)
        
        let task = session.dataTask(with: request) {data, response, error in
            
            
            print(data)
            
        }
        
        task.resume()
        
        
        
    }
    
}
