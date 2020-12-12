//
//  StockCard.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

class StockCard: UIView, CardView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var firstCard: FirstCompanyCard!
    @IBOutlet weak var secondCard: SecondCompanyCard!
    @IBOutlet weak var thirdCard: ThirdCompanyCard!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var isInitialLayout = true
    var currentPage = 0
    var pageCount = 3
    var currentCard: BackgroundColorAdjustable?
    var stock: Stock?
    
    let redStart: CGFloat = 0.043
    let redOffset: CGFloat = 0.257
    let greenStart: CGFloat = 0.043
    let greenOffset: CGFloat = 0.257
    
    let blue: CGFloat = 0.043
    
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
        
        
    }
    
    func setStock(_ stock: Stock) {
        self.stock = stock
        firstCard.setStock(stock)
        secondCard.setStock(stock)
        thirdCard.setStock(stock)
        
        if stock.getDescription().count < 100 {
            pageCount = 2
            pageControl.numberOfPages = 2
        }
    }
    
    func setStockDelegate(_ delegate: StockCardDelegate) {
        self.delegate = delegate
        thirdCard.delegate = delegate
    }
    
    func adjustBackgroundColor(with faktor: CGFloat) {
        if faktor < 0 {
            let color = UIColor(red: redStart + abs(faktor)*redOffset, green: greenStart, blue: blue, alpha: 1)
            currentCard?.setBackgroundColor(to: color)
        } else {
            let color = UIColor(red: redStart, green: greenStart + abs(faktor)*greenOffset, blue: blue, alpha: 1)
            currentCard?.setBackgroundColor(to: color)
        }
    }
    
    func swipedRight(manager: StocksManager) {
        manager.swiped(watched: true)
    }
    
    func swipedLeft(manager: StocksManager) {
        manager.swiped(watched: false)
    }
    
    
 
    private func setGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.contentView.addGestureRecognizer(tap)
    }
    
    @objc
    func handleTap() {
        currentPage = (currentPage+1)%pageCount
        
        
        pageControl.currentPage = currentPage
        setCurrentPage()
    }
    
    private func setCurrentPage() {
        switch currentPage {
        case 0:
            firstCard.isHidden = false
            secondCard.isHidden = true
            thirdCard.isHidden = true
            currentCard = firstCard
        case 1:
            firstCard.isHidden = true
            secondCard.isHidden = false
            thirdCard.isHidden = true
            currentCard = secondCard
        case 2:
            firstCard.isHidden = true
            secondCard.isHidden = true
            thirdCard.isHidden = false
            currentCard = thirdCard
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
    
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        currentPage = sender.currentPage
        setCurrentPage()
    }
}
