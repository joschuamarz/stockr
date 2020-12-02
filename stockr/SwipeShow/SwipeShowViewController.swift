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

protocol NetworkDelegate {
    func connectionSucceeded()
}

protocol FinishCardDelegate {
    func didResetCards()
}
enum GameMode {
    case downloading, adMob, lastStock, finished, stocks
}

class SwipeShowViewController: UIViewController, StockCardDelegate, NetworkDelegate, FinishCardDelegate {
    
    //MARK: -Outlets
    @IBOutlet weak var frontFrame: UIView!
    @IBOutlet weak var backFrame: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.layoutIfNeeded()
        let view = AdMobNativCard(frame: frontFrame.frame)
        self.view.addSubview(view)
        /*
        findOutGameMode()
        prepareGameMode()
            
        setGestures()
        

        backFrame.backgroundColor = .clear
        frontFrame.backgroundColor = .clear
        backCard.alpha = 0.8
        
        
        frontCard.setStockDelegate(self)
        backCard.setStockDelegate(self)
        */
    }
    
    var gameMode: GameMode = .stocks
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
    
    func connectionSucceeded() {
        self.findOutGameMode()
        
        if self.gameMode == .stocks || self.gameMode == .lastStock {
            self.changeToStockMode(delay: false)
        } else if self.gameMode == .finished {
            //changeToFinished
        }
    }
    
    func didResetCards() {
        findOutGameMode()
        if self.gameMode == .stocks || self.gameMode == .lastStock {
            self.changeToStockMode(delay: false)
        }
    }
    
    private func changeToStockMode(delay: Bool) {
        backCard.removeFromSuperview()
        if let stock = self.stockManager.getFirst() {
            self.backCard = StockCard(frame: backFrame.frame)
            self.backCard.setStock(stock)
            self.backCard.setStockDelegate(self)
            self.view.insertSubview(self.backCard, belowSubview: self.frontCard)
        }
        
        var deadline: DispatchTime = .now()
        if delay {
            deadline = .now() + 2
        }
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            
            self.animateLeftOut(force: true)
        
        }
    }
    
    private func changeToNoNetworkMode() {
        if UserDefaults.standard.string(forKey: "last_update") ?? "" == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.backCard.removeFromSuperview()
                let networkCard = NoNetworkCard(frame: self.backCard.frame)
                networkCard.delegate = self
                self.backCard = networkCard
                self.view.insertSubview(self.backCard, belowSubview: self.frontCard)
                self.view.layoutIfNeeded()
                self.animateLeftOut(force: true)
            })
            
        }
    }
    
    //MARK: - Game Mode
    private func findOutGameMode() {
        self.stockManager = StocksManager()
        if UserDefaults.standard.string(forKey: "last_update") ?? "" != Date().stripTimeString() {
            gameMode = .downloading
        } else {
            if self.stockManager.getSecond() != nil{
                gameMode = .stocks
            } else {
                gameMode = .lastStock
                
            }
            if self.stockManager.getFirst() == nil {
                gameMode = .finished
            }
        }
    }
    
    private func prepareGameMode() {
        switch gameMode {
        case .stocks:
            //Werte bereitstellen
            if let stock = self.stockManager.getFirst() {
                self.frontCard.setStock(stock)
                self.frontCard.setStockDelegate(self)
            }
            
            if let stock = self.stockManager.getSecond() {
                self.backCard.setStock(stock)
                self.backCard.setStockDelegate(self)
            }
            
            self.view.addSubview(backCard)
            self.view.addSubview(frontCard)
        case .downloading:
            //Download starten
            frontCard = DownloadCard(frame: frontFrame.frame)
            self.view.addSubview(backCard)
            self.view.addSubview(frontCard)
            DispatchQueue.main.async {
                ApiManager().getStocksFromAPI(completion: { (success) in
                    if success {
                        UserDefaults.standard.setValue(Date().stripTimeString(), forKey: "last_update")
                        
                        self.findOutGameMode()
                        
                        if self.gameMode == .stocks || self.gameMode == .lastStock {
                            self.changeToStockMode(delay: true)
                        } else if self.gameMode == .finished {
                            //changeToFinished
                        }
                    } else {
                        self.changeToNoNetworkMode()
                    }
                })
            }
        case .adMob:
            self.view.addSubview(backCard)
            self.view.addSubview(frontCard)
            print("TBD")
        case .finished:
            let finishCard = FinishCard(frame: backFrame.frame)
            finishCard.delegate = self
            frontCard = finishCard
            
            self.view.addSubview(frontCard)
        case .lastStock:
            if let stock = self.stockManager.getFirst() {
                self.frontCard.setStock(stock)
                self.frontCard.setStockDelegate(self)
            }
            
            let finishCard = FinishCard(frame: backFrame.frame)
            finishCard.delegate = self
            backCard = finishCard
            self.view.addSubview(backCard)
            self.view.addSubview(frontCard)
        }
    }
    
    //MARK: -Gestures
    private func setGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = frontCard
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
        //Fordere Karte weg
        frontCard.removeFromSuperview()
        //Karten tauschen
        frontCard = backCard
        setGestures()
        
        findOutGameMode()
        
        switch gameMode {
        case .stocks:
            backCard = StockCard(frame: backFrame.frame)
            if let stock = stockManager.getSecond() {
                backCard.setStock(stock)
            }
            backCard.alpha = 0
            backCard.setStockDelegate(self)
            
            //Neue Back Card
            self.view.insertSubview(backCard, belowSubview: frontCard)
        case .adMob:
            print("ADMOB")
        case .lastStock:
            print("Last")
            let finishCard = FinishCard(frame: backFrame.frame)
            finishCard.delegate = self
            backCard = finishCard
            
            backCard.alpha = 0
            self.view.insertSubview(backCard, belowSubview: frontCard)
            //backCard = FinishedCard
        case .downloading:
            backCard = StockCard(frame: backFrame.frame)
            
            backCard.alpha = 0
            backCard.setStockDelegate(self)
            
            //Neue Back Card
            self.view.insertSubview(backCard, belowSubview: frontCard)
        case .finished:
            backCard = StockCard()
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
