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
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size+padding/2, height: size))
        iconView.image = icon
        iconView.tintColor = UIColor.placeholderText
        outerView.addSubview(iconView)

        leftView = outerView
        leftViewMode = .always
      }
}
