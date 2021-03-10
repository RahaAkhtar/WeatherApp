//
//  UIView.swift
//  SeikME
//
//  Created by Muhammad  Akhtar on 1/2/20.
//  Copyright © 2020 Muhammad Akhtar. All rights reserved.
//

import UIKit

public extension UIView {
    
    /// Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            
            layer.borderColor = color.cgColor
        }
    }
    
    /// Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    override func prepareForInterfaceBuilder() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
    
    override func awakeFromNib() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
}
