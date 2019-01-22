//
//  LeftMenuViewController.swift
//  Mise
//
//  Created by Kang Seongchan on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import UIKit
import StoreKit


typealias MenuTuple = (image:UIImage, title:String)


class LeftMenuViewController: UIViewController, BasicViewControllerDelegate, PurchasePopupDelegate {
    
    func callAppstore(sender: UIButton) {
        
        sender.isUserInteractionEnabled = false
        
//        SKPaymentQueue().restoreCompletedTransactions()
        
        
        if let pv = sender.superview?.superview?.superview as? PurhcasePopUpView {
            
            
            
            guard let _product = product else {
                pv.removeFromSuperview()

                sender.isUserInteractionEnabled = true
                return }
            let payment = SKPayment.init(product: _product)
            SKPaymentQueue.default().add(payment)

            self.checkPro()
            
   
            if let mvc = self.parent?.parent as? MainViewController {
                mvc.viewWillAppear(true)
                mvc.checkPro()
                mvc.view.layoutIfNeeded()
            }
            
            pv.removeFromSuperview()

            // 구매 완료 후 나오는 팝업

            
            sender.isUserInteractionEnabled = true
         

            
        }
    }
    
    var product:SKProduct?
    var productId = "pro1"

    let menuTuples:[MenuTuple] = [(image:UIImage.init(named: "store")!, title:"maskStorage".localized), (image:UIImage.init(named: "config")!, title:"Config".localized)]
    let signUpBtn = BottomButton()
    let signInBtn = BottomButton()
    
    func setUI() {

        self.navigationController?.isNavigationBarHidden = true
        view.addSubview([tableView, bottomView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        bottomView.addSubview([signInBtn])
        
        signInBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.trailing.equalTo(-10)
        }
//        signUpBtn.snp.makeConstraints { (make) in
//            make.trailing.equalTo(-10)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(40)
//            make.width.equalTo(signInBtn.snp.width)
//            make.leading.equalTo(signInBtn.snp.trailing).offset(10)
//        }
        
        signInBtn.setAttributedTitle("purchasePro".localized.makeAttrString(font: .NotoSans(.bold, size: 15), color: .black), for: .normal)
        signInBtn.addTarget(self, action: #selector(callPurchase), for: .touchUpInside)
        
        
        
//        signUpBtn.setAttributedTitle("회원가입".makeAttrString(font: .NotoSans(.bold, size: 15), color: .black), for: .normal)
        
//        bottomView.backgroundColor = .red
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .white
        tableView.reloadData()
        
    }
    
    func getProductInfo() {
        
        if SKPaymentQueue.canMakePayments() {
            
            let request = SKProductsRequest.init(productIdentifiers: [self.productId])
            
            SKPaymentQueue.default().add(self)
            request.delegate = self
            request.start()
        }
        
    }
    
    func checkPro() {
        bottomView.isHidden = UserDefaults.standard.bool(forKey: "isProversion")
        view.layoutIfNeeded()
    }
    
    @objc func restorePurhcase() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @objc func callPurchase(){

        if let pv = self.parent as? UINavigationController {
            
            if let mvc = pv.navigationController?.viewControllers.filter({$0 is MainViewController}).first as? MainViewController{
                let pv = PurhcasePopUpView()
                mvc.view.addSubview(pv)
                pv.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                pv.delegate = self
            }
            
        }
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
        getProductInfo()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkPro()
        self.tableView.reloadData()
    }
    
}

extension LeftMenuViewController:UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = MenuHeaderView()
        
        headerView.setData(image: UIImage.init(named: "\(SELECTEDMASKIMAGE)1")!, title: String.init(format: "wearingMask".localized, (UserDefaults.standard.string(forKey: "maskName") ?? "기본마스크")))
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
            
            cell.setData(img: cellItem.image, title: cellItem.title, infoString: nil)
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTuples.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
            
            
        case 2:
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as? StoreViewController else {return}
            
            
            if let pv = self.parent as? UINavigationController {
                
                if let mvc = pv.navigationController?.viewControllers.filter({$0 is MainViewController}).first as? MainViewController{
                    pv.navigationController?.pushViewController(vc, animated: true)
                    mvc.dismissMenu()
                }
                
            }
        case 0:
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as? StoreViewController else {return}
            
            
            if let pv = self.parent as? UINavigationController {
                
                if let mvc = pv.navigationController?.viewControllers.filter({$0 is MainViewController}).first as? MainViewController{
                    pv.navigationController?.pushViewController(vc, animated: true)
                    mvc.dismissMenu()
                }
                
            }
        case 1:
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfigViewController") as? ConfigViewController else {return}
            
            
            if let pv = self.parent as? UINavigationController {
                
                if let mvc = pv.navigationController?.viewControllers.filter({$0 is MainViewController}).first as? MainViewController{
                    pv.navigationController?.pushViewController(vc, animated: true)
                    mvc.dismissMenu()
                }
                
                
                
                
            }
        default:
            break
            
            
        }
        

        
//        self.navigationController?.pushViewController(vc, animated: true)

        
        print(indexPath.row)
    }
    
}

extension LeftMenuViewController:SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        
        for tr in queue.transactions {
            
            if tr.payment.productIdentifier == "pro1" {
               self.afterRestored()
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for tr in transactions {
            
            switch tr.transactionState {
                
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction(tr)
                self.afterPurchased()
            case .restored:
                print("restored")
                SKPaymentQueue.default().finishTransaction(tr)
                self.afterRestored()

            case .failed:
                print("failed")
                SKPaymentQueue.default().finishTransaction(tr)

            default:
                print("XX")
                
            }
            
        }
        
    }
    
//    restore
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        
        if products.count != 0 {
            self.product = products[0]
            print(products)
            print("PRODODODO")
        }else{
            print("ERROR")
        }
        
    }
    
    func afterPurchased() {
        
        UserDefaults.standard.set(true, forKey: "isProversion")
        
        let av = UIAlertController.init(title: "purchased!".localized, message: "purchaseDesc".localized, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction.init(title: "confirm".localized, style: .cancel, handler: nil)
        
        av.addAction(action)
        
        self.present(av, animated: true, completion: nil)
        
    }
    
    func afterRestored() {
        
        UserDefaults.standard.set(true, forKey: "isProversion")
        
        let av = UIAlertController.init(title: "restored!".localized, message: "restoredDesc".localized, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction.init(title: "confirm".localized, style: .cancel, handler: nil)
        
        av.addAction(action)
        
        self.present(av, animated: true, completion: nil)
        
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
