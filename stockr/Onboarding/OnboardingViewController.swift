//
//  OnboardingViewController.swift
//  stockr
//
//  Created by Joschua Marz on 30.11.20.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var scrollHeight: CGFloat = 0.0
    var scrollWidth: CGFloat = 0.0
    
    var titles = ["Willkommen bei stockr", "Swipe Game", "stockr Watchlist", "Wir sind nicht perfekt"]
    
    var descriptions = [
        "Mit der stockr App kannst Du ganz einfach neue Werte für Deine Watchlist entdecken und so noch bessere Investmententscheidungen treffen!",
        "Erhalte Informationen zu einem Unternehmen und entscheide durch Swipen, ob Du den Wert zu Deiner Watchlist hinzufügen möchtest.",
        "Auf der Watchlist kannst Du ganz einfach alle Unternehmen einsehen. die Du über das Swipe Game nach Rechts gewischt hast.",
        "Das ist die erste Version von stockr, daher kann es hier und da noch zu kleineren Fehlern in den angezeigten Werten kommen. Wir arbeiten hart daran, die Qualität unserer Werte zu verbessern."]
    
    var assetNames = ["Make it rain-bro", "Charts-bro", "Checklist-bro", "Co-workers-bro"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
           
    }

    override func viewDidLayoutSubviews() {
            scrollWidth = scrollView.frame.size.width
            scrollHeight = scrollView.frame.size.height
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createSlides()
    }
    
    private func createSlides() {
        self.view.layoutIfNeeded()
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        nextButton.layer.cornerRadius = 5
        
        for index in 0..<titles.count {
            
            frame.origin.x = self.scrollView.frame.width * CGFloat(index)
            frame.size = CGSize(width: self.scrollView.frame.width, height: scrollHeight)
           
           
            
            let slide = InformationView(frame: frame)
            slide.setupWithInfos(headline: titles[index], imageName: assetNames[index], info: descriptions[index])
            scrollView.addSubview(slide)
            
            
          

        }
        
        //set width of scrollview to accomodate all the slides
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollView.contentSize.height = 1.0

        //initial state
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let page = pageControl.currentPage
        
        if page == titles.count-1 {
            let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "root") as! UITabBarController
            rootVC.tabBar.backgroundImage = UIImage()
            rootVC.tabBar.shadowImage = UIImage()
            rootVC.tabBar.clipsToBounds = true
            rootVC.modalPresentationStyle = .overFullScreen
            present(rootVC, animated: true, completion: nil)
            UserDefaults.standard.setValue(true, forKey: "Onboarded")
        } else {
            pageControl.currentPage = (page+1)%4
            pageChanged(self)
        }
    }
    
    
    @IBAction func pageChanged(_ sender: Any) {
        scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
        updateButton()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
        updateButton()
    }
    
    func setIndiactorForCurrentPage()  {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
        
    }
    
    private func updateButton() {
        
        if pageControl.currentPage == titles.count-1 {
            nextButton.backgroundColor = UIColor(named: "green")
            nextButton.setTitle("Los geht's", for: .normal)
        } else {
            nextButton.backgroundColor = UIColor(red: 41/255, green: 43/255, blue: 43/255, alpha: 1)
            nextButton.setTitle("Weiter", for: .normal)
        }
    }

    
    

}
