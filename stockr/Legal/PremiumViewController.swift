//
//  PremiumViewController.swift
//  stockr
//
//  Created by Joschua Marz on 28.02.21.
//

import UIKit

class PremiumViewController: UIViewController, PremiumDelegate {
    func subsripted() {
        print("Subscripted")
        let thanksView = ThankForPremiumCard(frame: self.view.frame)
        thanksView.contentView.layer.cornerRadius = 0
        thanksView.contentView.backgroundColor = .systemBackground
        self.view.addSubview(thanksView)
    }
    
    func nothingToRestore() {
        let alert = UIAlertController(title: "Fehler beim Wiederherstellen", message: "Du scheinst bisher noch nicht stockr Premium gekauft zu haben. Willst Du das jetzt nachholen?", preferredStyle: .alert)
        let doAction = UIAlertAction(title: "Jetzt kaufen", style: .default) { (_) in
            self.buyButtonTapped(self.buyButton as Any)
        }
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        alert.addAction(doAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    

    var purchaseManager = PurchaseManager()
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        purchaseManager.delegate = self
        
        if UserDefaults.standard.bool(forKey: "premium") {
            let thanksView = ThankForPremiumCard(frame: self.view.frame)
            thanksView.contentView.layer.cornerRadius = 0
            thanksView.contentView.backgroundColor = .systemBackground
            self.view.addSubview(thanksView)
        }
        
        buyButton.layer.cornerRadius = buyButton.frame.height/2
        restoreButton.layer.cornerRadius = restoreButton.frame.height/2
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buyButtonTapped(_ sender: Any) {
        purchaseManager.startPurchase()
    }
    
    @IBAction func restoreButtonTapped(_ sender: Any) {
        purchaseManager.restorePurchase()
    }


}
