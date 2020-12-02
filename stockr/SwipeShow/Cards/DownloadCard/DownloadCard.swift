//
//  DownloadCard.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

class DownloadCard: UIView, CardView {
    func adjustBackgroundColor(with faktor: CGFloat) {
        //NOT NEEDED
    }
    
    func swipedRight(manager: StocksManager) {
        //NOT NEEDED
    }
    
    func swipedLeft(manager: StocksManager) {
        //NOT NEEDED
    }
    
    func setStock(_ stock: Stock) {
        //NOT NEEDED
    }
    
    func setStockDelegate(_ delegate: StockCardDelegate) {
        //NOT NEEDED
    }
    

    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DownloadCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        
        contentView.layer.cornerRadius = 20
        self.isUserInteractionEnabled = false
    }

}
