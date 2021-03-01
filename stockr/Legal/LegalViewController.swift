//
//  LegalViewController.swift
//  stockr
//
//  Created by Joschua Marz on 29.11.20.
//

import UIKit

class LegalViewController: UIViewController {

    @IBOutlet weak var impressumBoxView: UIView!
    @IBOutlet weak var dataProtectionBoxView: UIView!
    @IBOutlet weak var premiumBoxView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        setGestures()
        
    }
    

    private func setGestures() {
        let impressumTap = UITapGestureRecognizer(target: self, action: #selector(handleImpressumTap))
        impressumBoxView.addGestureRecognizer(impressumTap)
        
        let dataTap = UITapGestureRecognizer(target: self, action: #selector(handleDataTap))
        dataProtectionBoxView.addGestureRecognizer(dataTap)
        
        let premiumTap = UITapGestureRecognizer(target: self, action: #selector(handlePremiumTap))
        premiumBoxView.addGestureRecognizer(premiumTap)
    }
    
    @objc
    func handleImpressumTap() {
        performSegue(withIdentifier: "impressum", sender: self)
    }
    
    @objc
    func handleDataTap() {
        performSegue(withIdentifier: "datenschutz", sender: self)
    }
    
    @objc
    func handlePremiumTap() {
        performSegue(withIdentifier: "premium", sender: self)
    }
    
    
}
