//
//  CompanyCard.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

class CompanyCard: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("CompanyCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        contentView.layer.cornerRadius = 20
        trashButton.layer.cornerRadius = trashButton.frame.width/2
        addButton.layer.cornerRadius = addButton.frame.width/2
        
    }

}
