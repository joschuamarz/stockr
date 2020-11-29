//
//  CompanyCard.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

class FirstCompanyCard: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("FirstCompanyCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        
        contentView.layer.cornerRadius = 20
        trashButton.layer.cornerRadius = trashButton.frame.width/2
        addButton.layer.cornerRadius = addButton.frame.width/2
        
    }
    
    func setStock(_ stock: LoadedStock) {
        nameLabel.text = stock.name ?? "Fehler"
    }

}
