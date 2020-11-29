//
//  Styles.swift
//  stockr
//
//  Created by Joschua Marz on 28.11.20.
//

import UIKit


class Headline: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.init(name: "Manrope-Bold", size: 24)
        self.textColor = .white
    }
}


class CompanyInformation: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.init(name: "Manrope-Medium", size: 12)
        self.textColor = .white
        self.alpha = 0.5
    }
}


class PriceInformation: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.init(name: "Manrope-Bold", size: 10)
        self.textColor = .white
        self.alpha = 0.5
    }
}


class Price: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.init(name: "Manrope-Medium", size: 16)
        self.textColor = .white
        self.alpha = 1
    }
}




