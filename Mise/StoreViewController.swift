//
//  StoreViewController.swift
//  Mise
//
//  Created by Seongchan Kang on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit


typealias thumnailTuple = (image:UIImage, title:String, identifier:String)

class StoreViewController: UIViewController {
    
    let thumnails:[thumnailTuple] = [(UIImage.init(named: "basicMask1")!, "기본마스크", "basicMask"), (UIImage.init(named: "bioMask1")!, "노란머리마스크", "bioMask"), (UIImage.init(named: "fireMask1")!, "불타는열정마스크", "fireMask"), (UIImage.init(named: "madMask1")!, "기본", "미친과학자마스크"), (UIImage.init(named: "milMask1")!, "기본", "milMask"), (UIImage.init(named: "seMask1")!, "기본", "seMask"), (UIImage.init(named: "toxicMask1")!, "기본", "toxicMask"), (UIImage.init(named: "vainMask1")!, "기본", "vainMask"), (UIImage.init(named: "metwinMask1")!, "기본", "metwinMask"), (UIImage.init(named: "weaponMask1")!, "기본", "weaponMask"), (UIImage.init(named: "emerMask1")!, "기본", "emerMask"), (UIImage.init(named: "nuMask1")!, "기본", "nuMask"), (UIImage.init(named: "paintMask1")!, "기본", "paintMask"), (UIImage.init(named: "seaMask1")!, "기본", "seaMask"), (UIImage.init(named: "sfMask1")!, "기본", "sfMask"), (UIImage.init(named: "ffMask1")!, "기본", "ffMask"), (UIImage.init(named: "hazardMask1")!, "기본", "hazardMask"), (UIImage.init(named: "nuhaMask1")!, "기본", "nuhaMask"), (UIImage.init(named: "blueMask1")!, "기본", "blueMask"), (UIImage.init(named: "longMask1")!, "기본", "longMask"), (UIImage.init(named: "gasMask1")!, "기본", "gasMask")]
    
    
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
        return thumnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell

        let cellItem = thumnails[indexPath.item]
        
        cell.thumImv.image = cellItem.image
        cell.titleLb.attributedText = cellItem.title.makeAttrString(font: .NotoSans(.bold, size: 12), color: .black)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else {return}
        
        let cellItem = thumnails[indexPath.row]
        
        vc.setData(title: cellItem.identifier)
//        cellItem.image.imageAsset.map({$0.na})
        
        self.navigationController?.pushViewController(vc, animated: true)
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
