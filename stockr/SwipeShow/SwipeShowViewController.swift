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

enum GameMode {
    case downloading, adMob, finished, stocks
}

class SwipeShowViewController: UIViewController, StockCardDelegate {
    
    //MARK: -Outlets
    @IBOutlet weak var frontFrame: UIView!
    @IBOutlet weak var backFrame: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.layoutIfNeeded()
        
        
        
        
        if UserDefaults.standard.string(forKey: "last_update") ?? "" != Date().stripTimeString() {
            frontCard = DownloadCard(frame: frontFrame.frame)
            self.view.addSubview(backCard)
            self.view.addSubview(frontCard)
            DispatchQueue.main.async {
                ApiManager().getStocksFromAPI {
                    self.setupCompanyCards()
                    UserDefaults.standard.setValue(Date().stripTimeString(), forKey: "last_update")
                }
            }
        } else {
            //bestehende verwenden
            if let stock = self.stockManager.getFirst() {
                self.frontCard.setStock(stock)
            }
            
            if let stock = self.stockManager.getSecond() {
                self.backCard.setStock(stock)
            }
            
            self.view.addSubview(backCard)
            self.view.addSubview(frontCard)
        }
        
        
        
        setGestures()
        

        backFrame.backgroundColor = .clear
        frontFrame.backgroundColor = .clear
        backCard.alpha = 0.8
        
        
        frontCard.setStockDelegate(self)
        backCard.setStockDelegate(self)
        
    }
    
    var frontCard: CardView = StockCard()
    var backCard: CardView = StockCard()
    
    var finished = false
    var downloadCard = DownloadCard()
    var stockManager = StocksManager()
    
    var isInitialLayout = true
    override func viewDidLayoutSubviews() {
        if isInitialLayout {
            frontCard.frame = frontFrame.frame
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
        self.stockManager = StocksManager()
        if let stock = self.stockManager.getFirst(){
            self.backCard.setStock(stock)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.animateLeftOut(force: true)
        }
        
        
        
    }
    
    //MARK: -Gestures
    private func setGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        frontCard.addGestureRecognizer(pan)
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
        
        
        let translation = sender.translation(in: self.frontCard)
        
        switch sender.state {
        case .changed:
            //Rotation zurücksetzen - Front
            frontCard.transform = CGAffineTransform.identity
            
            //Neue Position - Front
            let x = frontFrame.center.x + translation.x
            let y = frontFrame.center.y + translation.y
            frontCard.center = CGPoint(x: x, y: y)
            
            //Rotation - Front
            let faktor = translation.x/self.view.frame.width
            let transform = CGAffineTransform(rotationAngle: -faktor*destinationAngle)
            frontCard.transform = transform
            
            //BACK
            backCard.center.y = backFrame.center.y + abs(faktor)*yOffset
            backCard.frame.size.width = backFrame.frame.width + abs(faktor)*widthOffset
            backCard.frame.size.height = backFrame.frame.height + abs(faktor)*heightOffset
            backCard.center.x = backFrame.center.x
        
            //COLOR
            frontCard.adjustBackgroundColor(with: faktor)
            
        case .ended:
            if frontCard.center.x < self.view.frame.width/3 {
                animateLeftOut(force: false)
            } else if frontCard.center.x > 2*self.view.frame.width/3 {
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
            self.frontCard.adjustBackgroundColor(with: -0.7)
        }
        
        UIView.animate(withDuration: duration) {
            self.frontCard.center.x -= 2000
            if force {
                self.frontCard.transform = CGAffineTransform.init(rotationAngle: self.destinationAngle)
            }
            self.backCard.transform = CGAffineTransform.init(scaleX: deltaX, y: deltaY)
            self.backCard.center = self.frontFrame.center
            self.frontCard.swipedLeft(manager: self.stockManager)
            
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
            self.frontCard.adjustBackgroundColor(with: 0.7)
        }
        
        UIView.animate(withDuration: duration) {
            self.frontCard.center.x += 2000
            if force {
                self.frontCard.transform = CGAffineTransform.init(rotationAngle: -self.destinationAngle)
                
            }
            
            self.backCard.transform = CGAffineTransform.init(scaleX: deltaX, y: deltaY)
            self.backCard.center = self.frontFrame.center
            self.frontCard.swipedRight(manager: self.stockManager)
        } completion: { (success) in
            self.presentNextCard()
        }
    }
    
    private func reset() {
        UIView.animate(withDuration: 0.1) {
            self.frontCard.adjustBackgroundColor(with: 0)
            self.frontCard.transform = CGAffineTransform.identity
            self.frontCard.frame = self.frontFrame.frame
            self.backCard.frame = self.backFrame.frame
        } completion: { (success) in
            //
        }
        
    }
    
    
    
    
    
    
    private func presentNextCard() {
        guard !finished else {
            //Finished Karte zeigen
            return
        }
        
        //Fordere Karte weg
        frontCard.removeFromSuperview()
        
        //Karten tauschen
        frontCard = backCard
        backCard = StockCard(frame: backFrame.frame)
        backCard.alpha = 0
        backCard.setStockDelegate(self)
        
        //Neue Back Card
        self.view.insertSubview(backCard, belowSubview: frontCard)
        setGestures()
        
        
        if let stock = stockManager.getSecond() {
            backCard.setStock(stock)
        } else {
            finished = true
            //backCard = finishCard
        }
        
        self.frontCard.alpha = 1
        
        
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
