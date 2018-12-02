//
//  Extentions.swift
//  Notification
//
//  Created by MacBook Pro on 16/11/2018.
//  Copyright © 2018 FatemaShams. All rights reserved.
//
//
//
//  This file contians special classes and extensions
//
//


import Foundation
import UIKit



// This class for customizable text fields

class MyCustomTextField : UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.backgroundColor = UIColor.white
        self.tintColor = UIColor.white
    }
    
}


// This class for customizable button's height and corner radios
@IBDesignable class CustomButton : UIButton {
    
    /// Custom the corner radius
    @IBInspectable var cornerRadius : Int {
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        } get {
            return Int(self.layer.cornerRadius)
        }
    }
    
    @IBInspectable var buttonHeight : CGFloat {
        set {
            self.frame.size.height = CGFloat(40)
        } get {
            return CGFloat(self.frame.size.height)
        }
    }
    
}



/// This extention implement the shadow effect
extension UIView {
    
    func setShadow() {
        
        
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        self.layer.shadowRadius = 1
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.7058823529, blue: 0.2549019608, alpha: 1)
        self.layer.shadowOpacity = 0.1
        self.layer.cornerRadius = 8
        // self.clipsToBounds = true
        
    }
    
}



extension UIViewController {
    
    // hide keyboard on tap anywhere
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}





