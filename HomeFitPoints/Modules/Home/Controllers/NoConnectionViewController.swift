//
//  NoConnectionViewController.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 19/11/25.
//

import UIKit

class NoConnectionViewController: UIViewController {
    
    var onRetry: (() -> Void)?
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Colors.background
        setupUI()
    }
    
    private func setupUI() {
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)
        iconImageView.image = UIImage(systemName: "wifi.slash", withConfiguration: config)
        iconImageView.tintColor = Theme.Colors.secondaryMediumGray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = NSLocalizedString("error_no_internet", comment: "")
        titleLabel.font = Theme.Fonts.title(size: 24)
        titleLabel.textColor = Theme.Colors.primaryBlack
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.text = NSLocalizedString("no_connection_desc", comment: "Revisa tu módem o datos")
        messageLabel.font = Theme.Fonts.body(size: 16)
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        retryButton.setTitle(NSLocalizedString("retry_button", comment: ""), for: .normal)
        retryButton.backgroundColor = Theme.Colors.primaryOrange
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.titleLabel?.font = Theme.Fonts.title(size: 18)
        retryButton.layer.cornerRadius = 12
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 200),
            retryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func retryTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.retryButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.retryButton.transform = .identity
            }
        }
        
        if ConnectivityService.shared.isConnected {
            onRetry?() 
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}
