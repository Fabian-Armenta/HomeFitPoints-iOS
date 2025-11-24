//
//  WorkoutCompletedViewController.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 19/11/25.
//

import UIKit
import AVFoundation

class WorkoutCompletedViewController: UIViewController {
    
    var pointsEarned: Int = 0
    var motivationalMessageKey: String = ""
    var routineName: String = ""
    
    private var videoPlayer: AVPlayer?
    private var videoLayer: AVPlayerLayer?
    private var audioPlayer: AVAudioPlayer?
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let motivationLabel = UILabel()
    private let pointsLabel = UILabel()
    private let homeButton = UIButton(type: .system)
    private let overlayView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Colors.background
        
        setupVideoBackground() // 1 Video
        setupOverlay()         // 2 Capa
        setupUI()              // 3 Texto
        playVictorySound()     // 4 Sonido
        
        savePoints()
        navigationItem.hidesBackButton = true
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error configurando audio session: \(error)")
        }
    }
    
    private func setupVideoBackground() {
        guard let path = Bundle.main.path(forResource: "confeti", ofType: "mp4") else { return }
        let url = URL(fileURLWithPath: path)
        
        videoPlayer = AVPlayer(url: url)
        videoPlayer?.isMuted = true
        videoLayer = AVPlayerLayer(player: videoPlayer)
        videoLayer?.frame = view.bounds
        videoLayer?.videoGravity = .resizeAspectFill
        
        if let layer = videoLayer {
            view.layer.insertSublayer(layer, at: 0)
        }
        
        videoPlayer?.play()
        
        // Loop
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem, queue: .main) { [weak self] _ in
            self?.videoPlayer?.seek(to: .zero)
            self?.videoPlayer?.play()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoLayer?.frame = view.bounds
    }
    
    private func playVictorySound() {
        guard let url = Bundle.main.url(forResource: "victory", withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("No se pudo reproducir el sonido")
        }
    }
    
    private func setupOverlay() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func savePoints() {
        PointsManager.shared.logWorkout(points: pointsEarned, routineName: routineName)
    }
    
    private func setupUI() {
        titleLabel.text = NSLocalizedString("congrats_title", comment: "")
        titleLabel.font = Theme.Fonts.title(size: 32)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.text = NSLocalizedString("routine_completed_msg", comment: "")
        subtitleLabel.font = Theme.Fonts.title(size: 22)
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        motivationLabel.text = "\"\(NSLocalizedString(motivationalMessageKey, comment: ""))\""
        motivationLabel.font = UIFont.italicSystemFont(ofSize: 22)
        motivationLabel.textColor = UIColor(red: 1.00, green: 0.92, blue: 0.65, alpha: 1.00)
        motivationLabel.textAlignment = .center
        motivationLabel.numberOfLines = 0
        motivationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pointsLabel.text = String(format: NSLocalizedString("points_earned", comment: ""), pointsEarned)
        pointsLabel.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        pointsLabel.textColor = Theme.Colors.primaryOrange
        pointsLabel.textAlignment = .center
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        homeButton.setTitle(NSLocalizedString("go_home", comment: ""), for: .normal)
        homeButton.backgroundColor = Theme.Colors.primaryOrange
        homeButton.setTitleColor(.white, for: .normal)
        homeButton.layer.cornerRadius = 12
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(motivationLabel)
        view.addSubview(pointsLabel)
        view.addSubview(homeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -140),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            motivationLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            motivationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            motivationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            pointsLabel.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 30),
            pointsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            homeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeButton.widthAnchor.constraint(equalToConstant: 200),
            homeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func goHome() {
        navigationController?.popToRootViewController(animated: true)
    }
}
