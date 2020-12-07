//
//  Extensions.swift
//  stockr
//
//  Created by Joschua Marz on 29.11.20.
//

import UIKit


extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = .white
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    
    
    
    func setLeftIcon(_ icon: UIImage) {

        let padding = 8
        let size = 22

        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+2*padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size+padding/4, height: size))
        iconView.image = icon
        iconView.tintColor = UIColor.placeholderText
        outerView.addSubview(iconView)

        leftView = outerView
        leftViewMode = .always
      }
}


class LinkUILabel: UILabel{
    
    @IBInspectable
    var url: String?{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onLabelClic(sender:)))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(tap)
        }
    }
    
    override var text: String? {
        didSet {
            guard let _ = text else { return }
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        // Tap serviceConditions handler
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onLabelClic(sender:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    private func openUrl(urlString: String!) {
        var url = URL(string: urlString)!
        if(!urlString.starts(with: "http") && !urlString.starts(with: "mailto")){
            url = URL(string: "http://" + urlString)!
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func onLabelClic(sender:UITapGestureRecognizer) {
        self.openUrl(urlString: url)
    }
}


extension String {
    func getRounded(to places: Int) -> String {
        let value = Double(self.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.locale = NSLocale.current
        
        return formatter.string(from: NSNumber(value: value.withTwoDecimals())) ?? "err"
    }
    
    func getSeperatedWithoutDecimals() -> String {
        let value = Int(Double(self) ?? 0)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.locale = NSLocale.current
        
        return formatter.string(from: NSNumber(value: value)) ?? "err"
    }
    
    func getPercentage() -> String {
        let value = Double(self) ?? 0.0
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.locale = NSLocale.current
        
        return formatter.string(from: NSNumber(value: value.withTwoDecimals())) ?? "err"
    }
}

extension Double {
    
    func withTwoDecimals() -> Double {
        return ((self*100).rounded())/100
    }
    
    func withTwoDecimalsString() -> String {
        let value = self.withTwoDecimals()
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.locale = NSLocale.current
        
        return formatter.string(from: NSNumber(value: value)) ?? "err"
    }
    
    func withoutDecimalsString() -> String {
        let value = self.withTwoDecimals()
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 0
        formatter.locale = NSLocale.current
        
        return formatter.string(from: NSNumber(value: value)) ?? "err"
    }
    
    func formattedReadable() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.locale = NSLocale.current
        
        if Int(self/1000000000000) > 0 {
            return (formatter.string(from: NSNumber(value: (self/1000000000000).withTwoDecimals())) ?? "err") + " Bio."
        } else if Int(self/1000000000) > 0 {
            return (formatter.string(from: NSNumber(value: (self/1000000000).withTwoDecimals())) ?? "err") + " Mrd."
        } else if Int(self/1000000) > 0 {
            return (formatter.string(from: NSNumber(value: (self/1000000).withTwoDecimals())) ?? "err") + " Mio."
        } else {
            return self.withoutDecimalsString()
        }
    }
}


extension UIScrollView {
    var isBouncing: Bool {
        var isBouncing = false
        if contentOffset.y >= (contentSize.height - bounds.size.height) {
            // Bottom bounce
            isBouncing = true
        } else if contentOffset.y < contentInset.top {
            // Top bounce
            isBouncing = true
        }
        return isBouncing
    }
}


extension UILabel {

    var isTruncated: Bool {

        guard let labelText = text else {
            return false
        }

        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font ?? UIFont.systemFont(ofSize: 12)],
            context: nil).size

        return labelTextSize.height > bounds.size.height
    }
}



