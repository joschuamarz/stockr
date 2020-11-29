//
//  DownloadCard.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit

class DownloadCard: UIView {

    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DownloadCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        
        contentView.layer.cornerRadius = 20
    }

}
