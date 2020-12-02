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
    }
    
    @objc
    func handleImpressumTap() {
        performSegue(withIdentifier: "impressum", sender: self)
    }
    
    @objc
    func handleDataTap() {
        shouldPerformSegue(withIdentifier: "datenschutz", sender: self)
    }
    
}
