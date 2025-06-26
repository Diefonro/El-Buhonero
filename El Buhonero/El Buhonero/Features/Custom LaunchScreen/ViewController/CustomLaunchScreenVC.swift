//
//  CustomLaunchScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 26/06/25.
//

import UIKit

class CustomLaunchScreenVC: UIViewController, StoryboardInfo {
    
    static var storyboard = "CustomLaunchScreen"
    static var identifier = "CustomLaunchScreenVC"

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 3.0) {
            self.imageView.alpha = 1
            self.imageView.showScaleEffectAnimated()
        }
    }

}
