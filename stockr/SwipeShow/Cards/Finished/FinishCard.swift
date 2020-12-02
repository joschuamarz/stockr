//
//  FinishCard.swift
//  stockr
//
//  Created by Joschua Marz on 02.12.20.
//

import UIKit

class FinishCard: UIView , CardView {
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
    @IBOutlet weak var resetButton: UIButton!
    
    var delegate: FinishCardDelegate?
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        StocksManager().resetUnwatchedStocks {
            self.delegate?.didResetCards()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("FinishCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        
        contentView.layer.cornerRadius = 20
        resetButton.layer.cornerRadius = 5
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }


}
