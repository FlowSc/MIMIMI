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
    var maskName:String?
    var scrollView = BaseHorizontalScrollView()
    let horizontalStackView = UIStackView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.view.addSubview([btn, scrollView])
        
//        Horizontal
        scrollView.setScrollViewMiddle(vc: self)
        

        

        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 0
        scrollView.contentView.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        btn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeArea.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        btn.setAttributedTitle("구매하기".makeAttrString(font: .NotoSans(.bold, size: 20), color: .white), for: .normal)
        btn.setBackgroundColor(color: .black, forState: .normal)
        btn.addTarget(self, action: #selector(buyProduct(sender:)), for: .touchUpInside)

        view.bringSubviewToFront(btn)
        
        if let _imgTitle = ImageTitle, let _maskName = maskName {
            print(_imgTitle)
            
            for i in 1...6 {
                
                
                let pdv = ProductInfoView()
                
                pdv.setData(image: UIImage.init(named: "\(_imgTitle)\(i)")!, title: _maskName, desc: "", tag: i)
//                pdv.
//                pdv.titleLb.text =
                
                horizontalStackView.addArrangedSubview(pdv)
                
                pdv.snp.makeConstraints { (make) in
                    make.width.equalTo(view.bounds.width)
                    make.height.equalToSuperview()
                }
            }
        }
        

    }
    
    func setData(title:String, maskName:String) {
        
        self.ImageTitle = title
        self.maskName = maskName
        
    }
    
    @objc func buyProduct(sender:UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        if let _imgTitle = ImageTitle {
            print(_imgTitle)
            SELECTEDMASKIMAGE = _imgTitle
            
            UserDefaults.standard.set(_imgTitle, forKey: "currentMask")
            UserDefaults.init(suiteName: GROUPIDENTIFIER)?.set(SELECTEDMASKIMAGE, forKey: "imageName")
            
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

class ProductInfoView:UIView {
    
    let thumnailImv = UIImageView()
    let titleLb = UILabel()
    let descLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        
        self.addSubview([thumnailImv, titleLb, descLb])
        
        thumnailImv.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        thumnailImv.contentMode = .scaleAspectFit
        titleLb.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(thumnailImv.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        titleLb.textAlignment = .center
        descLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    
    func setData(image:UIImage, title:String, desc:String, tag:Int) {
        
        self.thumnailImv.image = image
        self.titleLb.attributedText = title.makeAttrString(font: .NotoSans(.bold, size: 30), color: .white)
        self.descLb.text = desc
        
        
        switch tag {
            
        case 1:
            self.backgroundColor = .wellGreen
        case 2:
            self.backgroundColor = .normalYellow
            
        case 3:
            self.backgroundColor = .unhealthyTangerine
            
        case 4:
            self.backgroundColor = .unhealthyRed
            
        case 5:
            self.backgroundColor = .unhealthyPurple
        case 6:
            self.backgroundColor = .hazardPurple
        default:
            break
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
