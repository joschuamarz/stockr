//
//  InformationView.swift
//  stockr
//
//  Created by Joschua Marz on 01.12.20.
//

import UIKit

class InformationView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("InformationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    func setupWithInfos(headline: String, imageName: String, info: String) {
        headerLabel.text = headline
        imageView.image = UIImage(named: imageName)
        infoLabel.text = info
    }

}
