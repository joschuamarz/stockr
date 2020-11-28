//
//  SwipeShowViewController.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

class SwipeShowViewController: UIViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var frontFrame: UIView!
    @IBOutlet weak var backFrame: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        
        self.view.addSubview(backCard)
        self.view.addSubview(companyCard)

        backFrame.backgroundColor = .clear
        frontFrame.backgroundColor = .clear
        
    }
    
    let companyCard = CompanyCard()
    let backCard = UIView()
    
    override func viewDidLayoutSubviews() {
        companyCard.frame = frontFrame.frame
        backCard.frame = backFrame.frame
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
