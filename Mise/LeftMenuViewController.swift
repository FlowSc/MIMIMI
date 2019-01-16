//
//  LeftMenuViewController.swift
//  Mise
//
//  Created by Kang Seongchan on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit


typealias MenuTuple = (image:UIImage, title:String)

class LeftMenuViewController: UIViewController, BasicViewControllerDelegate {
    
    let menuTuples:[MenuTuple] = [(image:UIImage.init(named: "trophy")!, title:"트로피"), (image:UIImage.init(named: "store")!, title:"store"), (image:UIImage.init(named: "config")!, title:"설정")]
    let signUpBtn = BottomButton()
    let signInBtn = BottomButton()
    
    func setUI() {

        view.addSubview([tableView, bottomView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        bottomView.addSubview([signInBtn, signUpBtn])
        
        signInBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        signUpBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(signInBtn.snp.width)
            make.leading.equalTo(signInBtn.snp.trailing).offset(10)
        }
        
        signInBtn.setAttributedTitle("로그인".makeAttrString(font: .NotoSans(.bold, size: 15), color: .black), for: .normal)
        
        signUpBtn.setAttributedTitle("회원가입".makeAttrString(font: .NotoSans(.bold, size: 15), color: .black), for: .normal)
        
//        bottomView.backgroundColor = .red
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .white
        tableView.reloadData()
        
    }
    
    func setDelegate() {
        print("Delegate")
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.select
    }
    
    func setAction() {
        print("Action")
    }
    
    
    let tableView = UITableView.init(frame: .zero, style: .grouped)
    let bottomView = UIView()
    var delegate:BasicViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDelegate()
        setAction()
        
        
        
        
        // Do any additional setup after loading the view.
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

extension LeftMenuViewController:UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = MenuHeaderView()
        
        headerView.setData(image: UIImage.init(named: "gas-mask-1")!, title: "방독면 챙기십쇼")
//        headerView.backgroundColor = .blue
        
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell {
            
            let cellItem = menuTuples[indexPath.row]
            
            cell.setData(img: cellItem.image, title: cellItem.title)
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTuples.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

protocol BasicViewControllerDelegate {
    
    func setUI()
    func setDelegate()
    func setAction()
    
}

class MenuHeaderView:UIView {
    
    let maskImv = UIImageView()
    let titleLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    func setUI() {
        
        self.addSubview([maskImv, titleLb])
        
        maskImv.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        maskImv.setBorder(color: .clear, width: 0, cornerRadius: 50)
        maskImv.backgroundColor = .black
//        maskImv.clipsToBounds = true
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(maskImv.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        titleLb.textAlignment = .center
    }
    
    func setData(image:UIImage, title:String) {
        
        self.maskImv.image = image
        self.titleLb.attributedText = title.makeAttrString(font: .NotoSans(.medium, size: 20), color: .black)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BottomButton:UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBorder(color: .init(white: 189/255, alpha: 1), width: 0.5, cornerRadius: 3)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
