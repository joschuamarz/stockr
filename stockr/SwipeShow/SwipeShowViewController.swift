//
//  SwipeShowViewController.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit
import AdSupport
import StoreKit

protocol StockCardDelegate {
    func trashButtonTapped()
    func addButtonTapped()
    func extendStock(_ stock: Stock)
}

protocol NetworkDelegate {
    func connectionSucceeded()
}

protocol FinishCardDelegate {
    func didResetCards()
}

protocol PremiumDelegate {
    func subsripted()
    func nothingToRestore()
}
enum GameMode {
    case downloading, adMob, afterAdMob, lastStock, finished, stocks, afterPremium
}

class SwipeShowViewController: UIViewController, StockCardDelegate, NetworkDelegate, FinishCardDelegate, PremiumDelegate {
    
    //MARK: -Outlets
    @IBOutlet weak var frontFrame: UIView!
    @IBOutlet weak var backFrame: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(ASIdentifierManager().advertisingIdentifier)
        self.view.layoutIfNeeded()
        
        findOutGameMode(reloadData: true)
        prepareGameMode()
            
        setGestures()
        

        backFrame.backgroundColor = .clear
        frontFrame.backgroundColor = .clear
        backCard.alpha = 0.8
        
        
        frontCard.setStockDelegate(self)
        backCard.setStockDelegate(self)
    }

    
    var gameMode: GameMode = .stocks
    var frontCard: CardView = StockCard()
    var backCard: CardView = StockCard()
    
    var finished = false
    var downloadCard = DownloadCard()
    var stockManager = StocksManager()
    
    var totalSwipedCards = 0
    
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
        totalSwipedCards = UserDefaults.standard.integer(forKey: "totalSwipedCards")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.setValue(totalSwipedCards, forKey: "totalSwipedCards")
    }
    
    func connectionSucceeded() {
        self.findOutGameMode(reloadData: true)
        
        if self.gameMode == .stocks || self.gameMode == .lastStock {
            self.changeToStockMode(delay: false)
        } else if self.gameMode == .finished {
            //changeToFinished
        }
    }
    
    func didResetCards() {
        findOutGameMode(reloadData: true)
        if self.gameMode == .stocks || self.gameMode == .lastStock || self.gameMode == .afterAdMob {
            self.changeToStockMode(delay: false)
        }
    }
    
    private func changeToStockMode(delay: Bool) {
        backCard.removeFromSuperview()
        if let stock = self.stockManager.getFirst() {
            self.backCard = StockCard(frame: backFrame.frame)
            self.backCard.setStock(stock)
            self.backCard.setStockDelegate(self)
            self.count += 1
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
    
    private func changeToFinished() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.backCard.removeFromSuperview()
            let finishCard = FinishCard(frame: self.backFrame.frame)
            finishCard.delegate = self
            self.backCard = finishCard
            self.view.insertSubview(self.backCard, belowSubview: self.frontCard)
            self.view.layoutIfNeeded()
            self.animateLeftOut(force: true)
        })
    }
    
    func subsripted() {
        DispatchQueue.main.async {
            self.backCard.removeFromSuperview()
            
            let thankCard = ThankForPremiumCard(frame: self.backFrame.frame)
            
            self.backCard = thankCard
            self.view.insertSubview(self.backCard, belowSubview: self.frontCard)
            self.view.layoutIfNeeded()
            self.changedToPremium = true
            self.animateLeftOut(force: true)
            
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    func nothingToRestore() {
        //
    }
    
    //MARK: - Game Mode
    var count = 1
    var changedToPremium = false
    private func findOutGameMode(reloadData: Bool) {
        if reloadData {
            self.stockManager = StocksManager()
        }
        
        if UserDefaults.standard.string(forKey: "last_update") ?? "" != Date().stripTimeString() {
            gameMode = .downloading
        } else {
            if UserDefaults.standard.bool(forKey: "premium") {
                //No ads
                if changedToPremium {
                    gameMode = .afterPremium
                    changedToPremium = false
                } else if self.stockManager.getSecond() != nil{
                    gameMode = .stocks
                } else {
                    gameMode = .lastStock
                    
                }
                if self.stockManager.getFirst() == nil {
                    gameMode = .finished
                }
            } else {
                //ads
                if count % 5 == 0 {
                    if !UserDefaults.standard.bool(forKey: "premium") {
                     gameMode = .adMob
                    }
                } else if count != 1 && (count+4)%5 == 0 {
                    gameMode = .afterAdMob
                } else if self.stockManager.getSecond() != nil{
                    gameMode = .stocks
                } else {
                    gameMode = .lastStock
                    
                }
                if self.stockManager.getFirst() == nil {
                    gameMode = .finished
                }
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
                        
                        self.findOutGameMode(reloadData: true)
                        
                        if self.gameMode == .stocks || self.gameMode == .lastStock {
                            self.changeToStockMode(delay: true)
                        } else if self.gameMode == .finished {
                            //changeToFinished
                        }
                    } else {
                        DispatchQueue.main.async {
                            if UserDefaults.standard.string(forKey: "last_update") ?? "" == "" {
                                self.changeToNoNetworkMode()
                            } else {
                                UserDefaults.standard.setValue(Date().stripTimeString(), forKey: "last_update")
                                self.changeToStockMode(delay: true)
                            }
                        }
                        
                    }
                })
            }
        case .adMob:
            self.view.addSubview(backCard)
            self.view.addSubview(frontCard)
            print("TBD")
        case .afterAdMob:
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
        case .afterPremium:
            return
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
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch sender.state {

        case .began:
            transform = frontCard.transform
            
        case .changed:
            
            //Neue Position - Front
            let x = frontFrame.center.x + translation.x
            let y = frontFrame.center.y + translation.y
            frontCard.center = CGPoint(x: x, y: y)
            
            //Rotation - Front
            let faktor = translation.x/self.view.frame.width
            transform = transform.rotated(by: -faktor*destinationAngle)
            self.currentAngle = -faktor*destinationAngle
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
        totalSwipedCards += 1
        
        //Fordere Karte weg
        frontCard.removeFromSuperview()
        //Karten tauschen
        frontCard = backCard
        //frontCard.transform = CGAffineTransform.identity
        //frontCard.frame = frontFrame.frame
        
        setGestures()
        
        findOutGameMode(reloadData: false)
        
        switch gameMode {
        case .stocks:
            backCard = StockCard(frame: backFrame.frame)
            if let stock = stockManager.getSecond() {
                backCard.setStock(stock)
            }
            backCard.alpha = 0
            backCard.setStockDelegate(self)
            count += 1
            //Neue Back Card
            self.view.insertSubview(backCard, belowSubview: frontCard)
        case .adMob:
            let view = AdMobNativCard(frame: backFrame.frame)
            view.setPremiumDelegate(self)
            view.root = self
            view.start()
            backCard = view
            self.view.insertSubview(backCard, belowSubview: frontCard)
            count += 1
        case .afterAdMob, .afterPremium:
            backCard = StockCard(frame: backFrame.frame)
            if let stock = stockManager.getFirst() {
                backCard.setStock(stock)
            }
            backCard.alpha = 0
            backCard.setStockDelegate(self)
            count += 1
            //Neue Back Card
            self.view.insertSubview(backCard, belowSubview: frontCard)
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
            let finishCard = FinishCard(frame: backFrame.frame)
            finishCard.delegate = self
            backCard = finishCard
            backCard.alpha = 0
            self.view.insertSubview(backCard, belowSubview: frontCard)
        }
       
        self.frontCard.alpha = 1
        UIView.animate(withDuration: 0.3) {
            
            self.backCard.alpha = 0.8
        }
        
        
        
        
        

        
    }

    var currentStock: Stock?
    func extendStock(_ stock: Stock) {
        currentStock = stock
        performSegue(withIdentifier: "description", sender: self)
    }
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "description" {
            if let destinationVC = segue.destination as? DescriptionViewController {
                destinationVC.givenStock = currentStock
            }
        }
        
    }
    

}
