//
//  StoreViewController.swift
//  Mise
//
//  Created by Seongchan Kang on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        collectionView.reloadData()
    }
    



    @IBOutlet weak var collectionView: UICollectionView!
    //    let collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setDelegate()

        // Do any additional setup after loading the view.
    }

}

extension StoreViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        cell.thumImv.image = UIImage.init(named: "basicMask1")
        cell.titleLb.text = "BASIC"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 150)
    }

}


class ProductCollectionViewCell:UICollectionViewCell {
    
    let thumImv = UIImageView()
    let titleLb = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    
    func setUI() {
        
        self.addSubview([thumImv, titleLb])
        
        thumImv.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(100)
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(thumImv.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLb.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
