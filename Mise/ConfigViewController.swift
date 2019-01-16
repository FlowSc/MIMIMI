//
//  ConfigViewController.swift
//  Mise
//
//  Created by Seongchan Kang on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit


var SELECTEDMASKIMAGE = "nuhaMask"

class ConfigViewController: UIViewController, BasicViewControllerDelegate {
    
    let menuTuples:[MenuTuple] = [(image:UIImage.init(named: "trophy")!, title:"트로피"), (image:UIImage.init(named: "store")!, title:"store"), (image:UIImage.init(named: "config")!, title:"설정")]

    
    func setUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        tableView.isScrollEnabled = false
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
    
    
    let tableView = UITableView()
    
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
            
            cell.setData(img: cellItem.image, title: cellItem.title)
            
            return cell
            
        }else{
            return UITableViewCell()
        }
    }
    
    
    
}
