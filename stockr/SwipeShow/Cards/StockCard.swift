//
//  StockCard.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

class StockCard: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var firstCard: FirstCompanyCard!
    @IBOutlet weak var secondCard: UIView!
    @IBOutlet weak var thirdCard: UIView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var isInitialLayout = true
    var currentPage = 0
    var stock: LoadedStock?
    
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
        Bundle.main.loadNibNamed("StockCard", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 20
        
        trashButton.layer.cornerRadius = trashButton.frame.width/2
        addButton.layer.cornerRadius = addButton.frame.width/2
        
        
        setGestures()
        setCurrentPage()
        
        if let stock = stock {
            firstCard.setStock(stock)
        }
    }
    
    func setStock(_ stock: LoadedStock) {
        self.stock = stock
        firstCard.setStock(stock)
    }
    
 
    private func setGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.contentView.addGestureRecognizer(tap)
    }
    
    @objc
    func handleTap() {
        currentPage = (currentPage+1)%3
        
        pageControl.currentPage = currentPage
        setCurrentPage()
    }
    
    private func setCurrentPage() {
        switch currentPage {
        case 0:
            firstCard.isHidden = false
            secondCard.isHidden = true
            thirdCard.isHidden = true
        case 1:
            firstCard.isHidden = true
            secondCard.isHidden = false
            thirdCard.isHidden = true
        case 2:
            firstCard.isHidden = true
            secondCard.isHidden = true
            thirdCard.isHidden = false
        default:
            print("Out of range")
        }
    }
    @IBAction func trashButtonTapped(_ sender: Any) {
        delegate?.trashButtonTapped()
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.addButtonTapped()
    }
}
