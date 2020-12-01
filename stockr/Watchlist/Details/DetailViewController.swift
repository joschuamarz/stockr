//
//  DetailViewController.swift
//  stockr
//
//  Created by Joschua Marz on 01.12.20.
//

import UIKit

protocol DetailDelegate {
    func didDeleteStock()
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet var boxViews: [UIView]!
    
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isinLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var yearLowLabel: UILabel!
    @IBOutlet weak var yearHighLabel: UILabel!
    @IBOutlet weak var yearRange: YearRange!
    @IBOutlet weak var avg50DayLabel: UILabel!
    @IBOutlet weak var avg200DayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var kgvLabel: UILabel!
    @IBOutlet weak var dividendYieldLabel: UILabel!
    @IBOutlet weak var netProfitLabel: UILabel!
    @IBOutlet weak var ebitdaLabel: UILabel!
    @IBOutlet weak var marktCapitalizationLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var sectorLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var employeesLabel: UILabel!
    @IBOutlet weak var foundedLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setGestures()
        setLayouts()
        setValuesToLabels()
    }
    
    var givenStock: Stock?
    var delegate: DetailDelegate?
    
    //MARK: -Values
    private func setValuesToLabels() {
        guard let stock = givenStock else {
            print("Keine Stock übergeben")
            return
        }
        
        nameLabel.text = stock.getName()
        isinLabel.text = stock.getIsin()
        
        //PRICE??
        
        yearLowLabel.text = stock.getYearLow().getRounded(to: 2) + "€"
        yearHighLabel.text = stock.getYearHigh().getRounded(to: 2) + "€"
        
        if let yearLow = Double(stock.getYearLow()) {
            if let yearHigh = Double(stock.getYearHigh()) {
                let price = 50.57
                let ratio = (price-yearLow)/(yearHigh-yearLow)
                yearRange.setIndicator(to: ratio)
            }
        }
        
        avg50DayLabel.text = stock.getAvg50Day().getRounded(to: 2) + "€"
        avg200DayLabel.text = stock.getAvg200Day().getRounded(to: 2) + "€"
        
        kgvLabel.text = stock.getPeRatio().getRounded(to: 2)
        dividendYieldLabel.text = stock.getDividendYield().getPercentage() + "%"
        //REINGEWINN?
        ebitdaLabel.text = stock.getEbitda().getSeperated() + "€"
        marktCapitalizationLabel.text = stock.getMarketCapitalization().getSeperated() + "€"
        
        countryLabel.text = stock.getCountry()
        exchangeLabel.text = stock.getExchange()
        sectorLabel.text = stock.getSector()
        //BRANCHE?
        
    }
    
    //MARK: -Layouts
    private func setLayouts() {
        bottomMenu.layer.cornerRadius = bottomMenu.frame.width/8
        indicatorView.layer.cornerRadius = indicatorView.frame.height/2
        deleteButton.layer.cornerRadius = 5
        
        for box in boxViews {
            box.layer.cornerRadius = 5
        }
    }

    
    //MARK: -Gestures
    private func setGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        blurView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        bottomMenu.addGestureRecognizer(pan)
    }
    
    var heightConstant: CGFloat = 60
    
    @objc
    func handlePan(_ sender: UIPanGestureRecognizer) {

        let translation = sender.translation(in: bottomMenu)
        let constant = heightConstant + translation.y
        
        switch sender.state {
        case .began:
            heightConstant = heightConstraint.constant
        case .changed:
            
            heightConstraint.constant = constant
            
            let faktor = abs(constant/self.view.frame.height)
            blurView.alpha = 0.7-faktor*0.5
            
            self.bottomMenu.layoutIfNeeded()
        case .ended:
            if constant > self.view.frame.height/2 {
                blurView.alpha = 0
                self.dismiss(animated: true, completion: nil)
            } else {
                heightConstraint.constant = heightConstant
                UIView.animate(withDuration: 0.3) {
                    self.bottomMenu.layoutIfNeeded()
                }
            }
        default:
            return
        }
    }
    
    @objc
    func handleTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let stock = givenStock {
            StocksManager().toUnwatched(stock: stock)
            delegate?.didDeleteStock()
        }
        
        self.dismiss(animated: true, completion: nil)
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
