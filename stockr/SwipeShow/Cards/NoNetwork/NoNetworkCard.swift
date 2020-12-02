//
//  NoNetworkCard.swift
//  stockr
//
//  Created by Joschua Marz on 02.12.20.
//

import UIKit

class NoNetworkCard: UIView, CardView, UIGestureRecognizerDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var delegate: NetworkDelegate?
    
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
    


    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        ApiManager().getStocksFromAPI(completion: { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                if success {
                    UserDefaults.standard.setValue(Date().stripTimeString(), forKey: "last_update")
                    self.delegate?.connectionSucceeded()
                }
            })
        })
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
        Bundle.main.loadNibNamed("NoNetworkCard", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 20
        tryAgainButton.layer.cornerRadius = 5
        activityIndicator.isHidden = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
