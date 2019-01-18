//
//  ConfigViewController.swift
//  Mise
//
//  Created by Seongchan Kang on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit


var SELECTEDMASKIMAGE = UserDefaults.standard.string(forKey: "currentMask") ?? "basicMask"

class ConfigViewController: UIViewController, BasicViewControllerDelegate {
    
    typealias ConfigTuple = (image:UIImage, title:String, desc:String)
    
    let menuTuples:[ConfigTuple] = [(image:UIImage.init(named: "envelope")!, title:"askDeveloper".localized, ""), (image:UIImage.init(named: "information")!, title:"versionInfo".localized, "V 1.0")]

    
    func setUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ConfigCell")
        tableView.isScrollEnabled = false
        tableView.groupSectionHeaderElimination()
        tableView.backgroundColor = .white
        tableView.reloadData()
    }
    
    func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setAction() {
        print("action")
    }
    
    
    let tableView = UITableView.init(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDelegate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}

extension ConfigViewController:UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTuples.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell {
            
            let cellItem = menuTuples[indexPath.row]
            
            cell.setData(img: cellItem.image, title: cellItem.title, infoString: cellItem.desc)
            
            return cell
            
        }else{
            return UITableViewCell()
        }
    }
    
    
    
}

extension UITableView {
    func groupSectionHeaderElimination(){
        self.sectionHeaderHeight = 0
        self.tableHeaderView = UIView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 0, height: CGFloat.leastNormalMagnitude)))
    }
}
