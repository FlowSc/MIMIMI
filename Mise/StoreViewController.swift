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
    
    let thumnails:[thumnailTuple] = [(UIImage.init(named: "basicMask1")!, "basicMask".localized, "basicMask"), (UIImage.init(named: "bioMask1")!, "yellowMask".localized, "bioMask"), (UIImage.init(named: "fireMask1")!, "fireMask".localized, "fireMask"), (UIImage.init(named: "madMask1")!, "madMask".localized, "madMask"), (UIImage.init(named: "milMask1")!, "yellowEye".localized, "milMask"), (UIImage.init(named: "seMask1")!, "welding".localized, "seMask"), (UIImage.init(named: "toxicMask1")!, "detect".localized, "toxicMask"), (UIImage.init(named: "vainMask1")!, "vain".localized, "vainMask"), (UIImage.init(named: "metwinMask1")!, "iron".localized, "metwinMask"), (UIImage.init(named: "weaponMask1")!, "wheel".localized, "weaponMask"), (UIImage.init(named: "emerMask1")!, "narrow".localized, "emerMask"), (UIImage.init(named: "nuMask1")!, "laser".localized, "nuMask"), (UIImage.init(named: "paintMask1")!, "sea".localized, "paintMask"), (UIImage.init(named: "seaMask1")!, "alien".localized, "seaMask"), (UIImage.init(named: "sfMask1")!, "cross".localized, "sfMask"), (UIImage.init(named: "ffMask1")!, "firefighter".localized, "ffMask"), (UIImage.init(named: "hazardMask1")!, "nuclear".localized, "hazardMask"), (UIImage.init(named: "nuhaMask1")!, "robot".localized, "nuhaMask"), (UIImage.init(named: "blueMask1")!, "asura".localized, "blueMask"), (UIImage.init(named: "longMask1")!, "bug".localized, "longMask"), (UIImage.init(named: "gasMask1")!, "bigEye".localized, "gasMask")]
    
    
    func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
//        collectionView.header
        collectionView.reloadData()
    }
    



    @IBOutlet weak var collectionView: UICollectionView!
    //    let collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "maskStorage".localized
        setDelegate()

        // Do any additional setup after loading the view.
    }
    

    

}

extension StoreViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    

        if kind == "UICollectionElementKindSectionHeader" {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CollectionHeaderView
            
                header.topLb.attributedText = "storeInfo".localized.makeAttrString(font: .NotoSans(.bold, size: 14), color: .black)

            return header
        }else{
            return UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if UserDefaults.standard.bool(forKey: "isProversion") {
            return CGSize.init(width: view.frame.width, height: 0)

        }else{
            return CGSize.init(width: view.frame.width, height: 60)

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell

        let cellItem = thumnails[indexPath.item]
        
        let isPro = UserDefaults.standard.bool(forKey: "isProversion")
        
        if isPro {
            cell.setData(image: cellItem.image, title: cellItem.title, isPurchased: true)

        }else{
            cell.setData(image: cellItem.image, title: cellItem.title, isPurchased: indexPath.row == 0 ? true : false)

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else {return}
        
        let cellItem = thumnails[indexPath.row]
        
        vc.setData(title: cellItem.identifier, maskName: cellItem.title)
//        cellItem.image.imageAsset.map({$0.na})
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


class ProductCollectionViewCell:UICollectionViewCell {
    
    let thumImv = UIImageView()
    let titleLb = UILabel()
    let lockImv = UIImageView.init(image: UIImage.init(named: "lock-icon"))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setData(image:UIImage, title:String, isPurchased:Bool) {
        
        self.thumImv.image = image
        self.titleLb.attributedText = title.makeAttrString(font: .NotoSans(.bold, size: 14), color: .black)
        self.lockImv.isHidden = isPurchased

    }
    
    
    private func setUI() {
        
        self.addSubview([thumImv, titleLb, lockImv])
        
        thumImv.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(100)
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(thumImv.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        lockImv.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        titleLb.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CollectionHeaderView:UICollectionReusableView {
    
    let topLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        self.addSubview(topLb)
        topLb.snp.makeConstraints { (make) in
           make.leading.equalTo(10)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        topLb.numberOfLines = 0
        topLb.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
