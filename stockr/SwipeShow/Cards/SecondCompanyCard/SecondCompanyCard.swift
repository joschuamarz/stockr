//
//  SecondCompanyCard.swift
//  stockr
//
//  Created by Joschua Marz on 29.11.20.
//

import UIKit

class SecondCompanyCard: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isinLabel: UILabel!
    @IBOutlet weak var regionImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var sectorLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("SecondCompanyCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 20
    
    }

    
    func setStock(_ stock: Stock) {
        nameLabel.text = stock.getName()
        isinLabel.text = stock.getIsin()
        countryLabel.text = stock.getCountry()
        exchangeLabel.text = stock.getExchange()
        sectorLabel.text = stock.getSector()
        //BRANCHE?
    }
}
