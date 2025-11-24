//
//  RestScreenViewController.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 19/11/25.
//

import UIKit

class RestScreenViewController: UIViewController {
    
    var onDismiss: (() -> Void)?
    private var timeLeft = 30
    private var timer: Timer?
    private let titleLabel = UILabel()
    private let timerLabel = UILabel()
    private let skipButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startTimer()
    }
    
    private func setupUI() {
        view.backgroundColor = Theme.Colors.secondaryDarkGray
        
        titleLabel.text = NSLocalizedString("rest_title", comment: "")
        titleLabel.font = Theme.Fonts.title(size: 24)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timerLabel.text = "00:\(timeLeft)"
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 60, weight: .bold)
        timerLabel.textColor = Theme.Colors.primaryOrange
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        skipButton.setTitle(NSLocalizedString("skip_rest", comment: ""), for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.backgroundColor = .gray
        skipButton.layer.cornerRadius = 8
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(timerLabel)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 150),
            skipButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeLeft -= 1
            self.timerLabel.text = String(format: "00:%02d", self.timeLeft)
            if self.timeLeft <= 0 {
                self.skipTapped()
            }
        }
    }
    
    @objc private func skipTapped() {
        timer?.invalidate()
        dismiss(animated: true) {
            self.onDismiss?()
        }
    }
}
