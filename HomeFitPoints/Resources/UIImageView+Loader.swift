//
//  UIImageView.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 23/11/25.
//

import UIKit

let globalImageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    @MainActor
    func loadImageAsync(from urlString: String) async {
        let imageKey = NSString(string: urlString)
        
        self.image = nil
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .gray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        spinner.startAnimating()
        
        if let cachedImage = globalImageCache.object(forKey: imageKey) {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                globalImageCache.setObject(image, forKey: imageKey)
                
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                self.alpha = 0
                self.image = image
                UIView.animate(withDuration: 0.3) { self.alpha = 1 }
            }
        } catch {
            print("Error cargando imagen: \(error)")
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            self.image = UIImage(systemName: "photo")
            self.tintColor = .gray
        }
    }
}
