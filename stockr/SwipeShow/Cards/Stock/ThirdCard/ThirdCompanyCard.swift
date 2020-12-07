//
//  ThirdCompanyCard.swift
//  stockr
//
//  Created by Joschua Marz on 07.12.20.
//

import UIKit

class ThirdCompanyCard: UIView, BackgroundColorAdjustable {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var disclaimerBoxView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isinLabel: PriceInformation!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var extendButton: UIButton!
    
    var stock: Stock?
    var delegate: StockCardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ThirdCompanyCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 20
        disclaimerBoxView.layer.cornerRadius = 5
    
    }
    

    @IBAction func extendButtonTapped(_ sender: Any) {
        if let stock = stock {
            delegate?.extendStock(stock)
        }
        
    }
    
    
    func setBackgroundColor(to color: UIColor) {
        self.contentView.backgroundColor = color
    }
    
    func setStock(_ stock: Stock) {
        self.stock = stock
        nameLabel.text = stock.getName()
        isinLabel.text = stock.getIsin()
        
        descriptionLabel.text = stock.getDescription()
        
        
    }
    

}
