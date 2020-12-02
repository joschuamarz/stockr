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

class Information: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.init(name: "Manrope-Medium", size: 14)
        self.textColor = .white
        self.alpha = 0.5
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

class SearchTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLeftIcon(UIImage(systemName: "magnifyingglass")!)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    
    let padding = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 12)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}




