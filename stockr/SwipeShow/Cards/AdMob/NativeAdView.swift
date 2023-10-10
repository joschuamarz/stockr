//
//  NativeAdView.swift
//  stockr
//
//  Created by Joschua Marz on 03.12.20.
//

import UIKit
import GoogleMobileAds

class NativeAdView: UIView {

    @IBOutlet var contentView: GADNativeAdView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    

    func commonInit() {
        Bundle.main.loadNibNamed("NativeAdView", owner: self, options: nil)
        layoutIfNeeded()
        contentView.frame = self.bounds
        addSubview(contentView)
        
    }

}
