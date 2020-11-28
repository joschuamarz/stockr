//
//  YearRange.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

class YearRange: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("YearRange", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    
    func setIndicator(to value: Double) {
        let minX: CGFloat = 0.0
        let maxX = contentView.frame.width
        
        
        let center = contentView.frame.width * CGFloat(value)
        
        let constant = min(maxX, center-indicatorView.frame.width/2)
        
        leadingConstraint.constant = max(constant, minX)
        
        self.contentView.layoutSubviews()
    }

}
