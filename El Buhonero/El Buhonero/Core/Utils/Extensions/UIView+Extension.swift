//
//  UIView+Extension.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

protocol DesignableCorner {
    var cornerRadius: CGFloat { get set }
}

@IBDesignable extension UIView: DesignableCorner {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
}
