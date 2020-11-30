//
//  SwipeShowViewController.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

protocol StockCardDelegate {
    func trashButtonTapped()
    func addButtonTapped()
}

class SwipeShowViewController: UIViewController, StockCardDelegate {
    
    //MARK: -Outlets
    @IBOutlet weak var frontFrame: UIView!
    @IBOutlet weak var backFrame: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.layoutIfNeeded()
        
        self.view.addSubview(backCard)
        self.view.addSubview(companyCard)
        
        
        if UserDefaults.standard.string(forKey: "last_update") ?? "" != Date().stripTimeString() {
            //Neu laden
            self.view.addSubview(downloadCard)
            DispatchQueue.main.async {
                ApiManager().getStocksFromAPI {
                    self.setupCompanyCards()
                    UserDefaults.standard.setValue(Date().stripTimeString(), forKey: "last_update")
                }
            }
        } else {
            //bestehende verwend
            if let stock = self.stockManager.getFirst() {
                self.companyCard.setStock(stock)
            }
            
            if let stock = self.stockManager.getSecond() {
                self.backCard.setStock(stock)
            }
            
            self.setGestures()
        }
        
        
        

        backFrame.backgroundColor = .clear
        frontFrame.backgroundColor = .clear
        backCard.alpha = 0.8
        
        
        companyCard.delegate = self
        backCard.delegate = self
        
    }
    
    var companyCard = StockCard()
    var backCard = StockCard()
    var downloadCard = DownloadCard()
    var stockManager = StocksManager()
    
    var isInitialLayout = true
    override func viewDidLayoutSubviews() {
        if isInitialLayout {
            companyCard.frame = frontFrame.frame
            backCard.frame = backFrame.frame
            downloadCard.frame = frontFrame.frame
            isInitialLayout = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isInitialLayout = true
    }
    
    private func setupCompanyCards() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animateDownloadLeftOut {
                self.downloadCard.removeFromSuperview()
                
                self.stockManager = StocksManager()
                
                if let stock = self.stockManager.getFirst() {
                    self.companyCard.setStock(stock)
                }
                
                if let stock = self.stockManager.getSecond() {
                    self.backCard.setStock(stock)
                }
                
                self.setGestures()
            }
            
           
        }
        
        
        
    }
    
    //MARK: -Gestures
    private func setGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        companyCard.addGestureRecognizer(pan)
    }
    
    var startPoint = CGPoint.zero
    let destinationAngle: CGFloat = 0.785398
    
    
    var currentAngle: CGFloat = 0
    
   
    @objc
    func handlePan(_ sender: UIPanGestureRecognizer) {
        
        //Front
        
        
        //Back
        let yOffset = frontFrame.center.y - backFrame.center.y
        let widthOffset = frontFrame.frame.width - backFrame.frame.width
        let heightOffset = frontFrame.frame.height - backFrame.frame.height
        
        
        let translation = sender.translation(in: self.companyCard)
        
        switch sender.state {
        case .changed:
            //Rotation zurücksetzen - Front
            companyCard.transform = CGAffineTransform.identity
            
            //Neue Position - Front
            let x = frontFrame.center.x + translation.x
            let y = frontFrame.center.y + translation.y
            companyCard.center = CGPoint(x: x, y: y)
            
            //Rotation - Front
            let faktor = translation.x/self.view.frame.width
            let transform = CGAffineTransform(rotationAngle: -faktor*destinationAngle)
            companyCard.transform = transform
            
            //BACK
            backCard.center.y = backFrame.center.y + abs(faktor)*yOffset
            backCard.frame.size.width = backFrame.frame.width + abs(faktor)*widthOffset
            backCard.frame.size.height = backFrame.frame.height + abs(faktor)*heightOffset
            backCard.center.x = backFrame.center.x
        
            //COLOR
            companyCard.adjustBackgroundColor(with: faktor)
            
        case .ended:
            if companyCard.center.x < self.view.frame.width/3 {
                animateLeftOut(force: false)
            } else if companyCard.center.x > 2*self.view.frame.width/3 {
                animateRightOut(force: false)
            } else {
                reset()
            }
            
        default:
            print("")
        }
        
    }
    
    //MARK: StockCardDelegate
    func trashButtonTapped() {
        animateLeftOut(force: true)
    }
    
    func addButtonTapped() {
        animateRightOut(force: true)
    }
    
    //MARK: -Animations
    private func animateLeftOut(force: Bool) {
        var duration = 0.3
        if force {
            duration = 0.5
        }
        let deltaX = frontFrame.frame.width / backCard.frame.width
        let deltaY = frontFrame.frame.height / backCard.frame.height
        
        if force {
            self.companyCard.adjustBackgroundColor(with: -0.7)
        }
        
        UIView.animate(withDuration: duration) {
            self.companyCard.center.x -= 2000
            if force {
                self.companyCard.transform = CGAffineTransform.init(rotationAngle: self.destinationAngle)
            }
            self.backCard.transform = CGAffineTransform.init(scaleX: deltaX, y: deltaY)
            self.backCard.center = self.frontFrame.center
            self.stockManager.swiped(watched: false)
            
        } completion: { (success) in
            self.presentNextCard()
        }
    }
    
    private func animateRightOut(force: Bool) {
        var duration = 0.3
        if force {
            duration = 0.5
        }
        let deltaX = frontFrame.frame.width / backCard.frame.width
        let deltaY = frontFrame.frame.height / backCard.frame.height
        
        if force {
            self.companyCard.adjustBackgroundColor(with: 0.7)
        }
        
        UIView.animate(withDuration: duration) {
            self.companyCard.center.x += 2000
            if force {
                self.companyCard.transform = CGAffineTransform.init(rotationAngle: -self.destinationAngle)
                
            }
            
            self.backCard.transform = CGAffineTransform.init(scaleX: deltaX, y: deltaY)
            self.backCard.center = self.frontFrame.center
            self.stockManager.swiped(watched: true)
        } completion: { (success) in
            self.presentNextCard()
        }
    }
    
    private func reset() {
        UIView.animate(withDuration: 0.1) {
            self.companyCard.transform = CGAffineTransform.identity
            self.companyCard.frame = self.frontFrame.frame
            self.backCard.frame = self.backFrame.frame
        } completion: { (success) in
            //
        }
        
    }
    
    //DownloadCard
    private func animateDownloadLeftOut(completion: @escaping () -> Void) {
        
        UIView.animate(withDuration: 0.3) {
            self.downloadCard.center.x -= 2000
            self.downloadCard.transform = CGAffineTransform.init(rotationAngle: self.destinationAngle)
            
        } completion: { (success) in
            completion()
        }
    }
    
    
    
    private func presentNextCard() {
        //Fordere Karte weg
        companyCard.removeFromSuperview()
        
        //Karten tauschen
        companyCard = backCard
        backCard = StockCard(frame: backFrame.frame)
        backCard.alpha = 0
        backCard.delegate = self
        
        //Neue Back Card
        self.view.insertSubview(backCard, belowSubview: companyCard)
        setGestures()
        
        
        if let stock = stockManager.getSecond() {
            backCard.setStock(stock)
        }
        
        self.companyCard.alpha = 1
        
        
        UIView.animate(withDuration: 0.3) {
            self.backCard.alpha = 0.8
        }
        
        
        
        
        

        
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
