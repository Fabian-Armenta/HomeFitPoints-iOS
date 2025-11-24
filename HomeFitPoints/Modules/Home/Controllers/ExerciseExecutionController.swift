//
//  ExerciseExecutionController.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 19/11/25.
//

import UIKit

class ExerciseExecutionController: UIViewController {
    
    var exercises: [Exercise] = []
    var motivationalMessages: [String] = []
    var routineName: String = ""
    
    private var currentIndex = 0
    private var totalPoints = 0
    private let exerciseImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let repsLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .bar)
    private let nextButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadExercise()
    }
    
    private func setupUI() {
        view.backgroundColor = Theme.Colors.background
        
        exerciseImageView.contentMode = .scaleAspectFit
        exerciseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = Theme.Fonts.title(size: 28)
        nameLabel.textColor = Theme.Colors.primaryBlack
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = Theme.Fonts.body(size: 16)
        descriptionLabel.textColor = Theme.Colors.secondaryDarkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        repsLabel.font = Theme.Fonts.title(size: 40)
        repsLabel.textColor = Theme.Colors.primaryOrange
        repsLabel.textAlignment = .center
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressBar.trackTintColor = .lightGray
        progressBar.progressTintColor = Theme.Colors.primaryOrange
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.setTitle(NSLocalizedString("next_exercise", comment: ""), for: .normal)
        nextButton.backgroundColor = Theme.Colors.primaryBlack
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 25
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        view.addSubview(progressBar)
        view.addSubview(exerciseImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(repsLabel)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            exerciseImageView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 15),
            exerciseImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            exerciseImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            exerciseImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            
            nameLabel.topAnchor.constraint(equalTo: exerciseImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            repsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            repsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func loadExercise() {
        guard currentIndex < exercises.count else { return }
        let exercise = exercises[currentIndex]
        
        nameLabel.text = exercise.name
        descriptionLabel.text = NSLocalizedString(exercise.descriptionKey, comment: "")
        repsLabel.text = "\(exercise.value) \(exercise.unit)"
        
        Task {
            await exerciseImageView.loadImageAsync(from: exercise.imageUrl)
        }
        
        let progress = Float(currentIndex) / Float(exercises.count)
        progressBar.setProgress(progress, animated: true)
    }
    
    @objc private func nextTapped() {
        totalPoints += exercises[currentIndex].points
        
        if currentIndex < exercises.count - 1 {
            let restVC = RestScreenViewController()
            restVC.modalPresentationStyle = .fullScreen
            restVC.onDismiss = { [weak self] in
                self?.currentIndex += 1
                self?.loadExercise()
            }
            present(restVC, animated: true)
        } else {
            let completedVC = WorkoutCompletedViewController()
            completedVC.pointsEarned = totalPoints
            completedVC.routineName = routineName
            
            if let randomMsgKey = motivationalMessages.randomElement() {
                completedVC.motivationalMessageKey = randomMsgKey
            } else {
                completedVC.motivationalMessageKey = "congrats_title"
            }
            navigationController?.pushViewController(completedVC, animated: true)
        }
    }
}
