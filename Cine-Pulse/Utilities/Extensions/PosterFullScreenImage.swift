//
//  PosterFullScreenImage.swift
//  Cine-Pulse
//
//  Created by Rovshan Rasulov on 22.10.25.
//

import UIKit

extension UIView {
    func posterImageTapped(_ image: UIImage) {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let backgroundView = UIVisualEffectView(effect: blurEffect)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
        backgroundView.alpha = 0
        backgroundView.isUserInteractionEnabled = true
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.contentView.addSubview(imageView)
        
        guard let parent = self.window ?? UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        parent.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: parent.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.9)
        ])
        
        UIView.animate(withDuration: 0.45) {
            backgroundView.alpha = 1
        }
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage(_:)))
        backgroundView.addGestureRecognizer(dismissTap)
    }
    
    @objc private func dismissFullscreenImage(_ gesture: UITapGestureRecognizer) {
        guard let backgroundView = gesture.view else { return }
        UIView.animate(withDuration: 0.45, animations: {
            backgroundView.alpha = 0
        }) { _ in
            backgroundView.removeFromSuperview()
        }
    }
}


