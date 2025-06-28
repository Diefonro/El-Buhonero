//
//  LoadingImageView.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit
import Kingfisher
import Lottie

class LoadingImageView: UIImageView {
    
    private var loadingAnimationView: LottieAnimationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoadingAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoadingAnimation()
    }
    
    private func setupLoadingAnimation() {
        loadingAnimationView = LottieAnimationView()
        loadingAnimationView?.loopMode = .loop
        loadingAnimationView?.contentMode = .scaleAspectFit
        loadingAnimationView?.isHidden = true
        
        if let path = Bundle.main.path(forResource: "loading-skeleton", ofType: "json") {
            loadingAnimationView?.animation = LottieAnimation.filepath(path)
        } else {
            // Fallback to programmatic animation if file not found
            createProgrammaticAnimation()
        }
        
        if let loadingView = loadingAnimationView {
            addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
                loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
                loadingView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
                loadingView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
            ])
        }
    }
    
    private func createProgrammaticAnimation() {
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        circleView.backgroundColor = .clear
        
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20),
                                    radius: 15,
                                    startAngle: 0,
                                    endAngle: 2 * CGFloat.pi,
                                    clockwise: true)
        
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 3
        circleLayer.strokeEnd = 0.7
        circleLayer.lineCap = .round
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        circleLayer.add(rotationAnimation, forKey: "rotation")
        circleView.layer.addSublayer(circleLayer)
        
        loadingAnimationView?.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: loadingAnimationView!.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: loadingAnimationView!.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 40),
            circleView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        showLoadingAnimation()
        
        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.3)),
            .cacheOriginalImage
        ]
        
        kf.setImage(with: url, placeholder: placeholder, options: options) { [weak self] result in
            self?.hideLoadingAnimation()
            switch result {
            case .success(_):
                break
            case .failure(_):
                self?.image = placeholder
            }
        }
    }
    
    private func showLoadingAnimation() {
        loadingAnimationView?.isHidden = false
        loadingAnimationView?.play()
    }
    
    private func hideLoadingAnimation() {
        loadingAnimationView?.stop()
        loadingAnimationView?.isHidden = true
    }
    
    func cleanup() {
        hideLoadingAnimation()
        kf.cancelDownloadTask()
    }
} 