//
//  UIImageView+Extension.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 26/06/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func showScaleEffectAnimated() {
        UIView.animate(withDuration: 3.0, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: nil)
    }
}
