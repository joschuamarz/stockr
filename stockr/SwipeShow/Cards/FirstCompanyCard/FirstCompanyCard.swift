//
//  CompanyCard.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

class FirstCompanyCard: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var boxViews: [UIView]!
    
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isinLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var yearLowLabel: UILabel!
    @IBOutlet weak var yearHighLabel: UILabel!
    @IBOutlet weak var yearRange: YearRange!
    @IBOutlet weak var avg_50_day_label: UILabel!
    @IBOutlet weak var avg_200_day_label: UILabel!
    
    @IBOutlet weak var kgvLabel: UILabel!
    @IBOutlet weak var dividendYieldLabel: UILabel!
    @IBOutlet weak var netProfitLabel: UILabel!
    @IBOutlet weak var ebitdaLabel: UILabel!
    @IBOutlet weak var marktCapitalizationLabel: UILabel!
    
    
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
    
    func setStock(_ stock: Stock) {
        nameLabel.text = stock.getName()
        isinLabel.text = stock.getIsin()
        
        //PRICE??
        
        yearLowLabel.text = stock.getYearLow() + "€"
        yearHighLabel.text = stock.getYearHigh() + "€"
        
        if let yearLow = Double(stock.getYearLow()) {
            if let yearHigh = Double(stock.getYearHigh()) {
                let price = 50.57
                let ratio = (price-yearLow)/(yearHigh-yearLow)
                yearRange.setIndicator(to: ratio)
            }
        }
        
        avg_50_day_label.text = stock.getAvg50Day() + "€"
        avg_200_day_label.text = stock.getAvg200Day() + "€"
        
        kgvLabel.text = stock.getPeRatio().getRounded(to: 2)
        dividendYieldLabel.text = stock.getDividendYield().getPercentage() + "%"
        //REINGEWINN?
        ebitdaLabel.text = stock.getEbitda().getSeperated() + "€"
        marktCapitalizationLabel.text = stock.getMarketCapitalization().getSeperated() + "€"
    }

}
