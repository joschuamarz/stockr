//
//  DescriptionViewController.swift
//  stockr
//
//  Created by Joschua Marz on 07.12.20.
//

import UIKit

class DescriptionViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var disclaimerBoxView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayouts()
        setGestures()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let stock = givenStock {
            descriptionLabel.text = stock.getDescription()
        }
    }
    var givenStock: Stock?
    
    //MARK: -Layouts
    private func setLayouts() {
        
        
        bottomMenu.layer.cornerRadius = bottomMenu.frame.width/10
        bottomMenu.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        indicatorView.layer.cornerRadius = indicatorView.frame.height/2
        disclaimerBoxView.layer.cornerRadius = 5
        
    }
    
    
    //MARK: -Gestures
    private func setGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        blurView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        bottomMenu.addGestureRecognizer(pan)
    }
    
    var heightConstant: CGFloat = 60
    
    @objc
    func handlePan(_ sender: UIPanGestureRecognizer) {

        let translation = sender.translation(in: bottomMenu)
        let location = sender.location(in: self.view)
        let constant = heightConstant + translation.y
        
        switch sender.state {
        case .began:
            heightConstant = heightConstraint.constant
        case .changed:
            if translation.y > 0 {
                heightConstraint.constant = constant
                
                let faktor = abs(constant/self.view.frame.height)
                blurView.alpha = 0.7-faktor*0.5
                
                self.bottomMenu.layoutIfNeeded()
            }
        case .ended:
            if constant > self.view.frame.height/3 || (constant > self.view.frame.height/5 && location.y > self.view.frame.width*0.6){
                
                blurView.alpha = 0
                self.dismiss(animated: true, completion: nil)
                
            } else {
                heightConstraint.constant = heightConstant
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
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
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (scrollView.contentOffset.y == 0 || (scrollView.contentOffset.y < 50 && scrollView.isBouncing))
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
