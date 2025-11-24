//
//  RoutineDetailViewController.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 19/11/25.
//

import UIKit

class RoutineDetailViewController: UIViewController {
    
    var routine: Routine?
    var exercises: [Exercise] = []
    var motivationalMessages: [String] = []
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let exercisesTitleLabel = UILabel()
    private let exercisesListLabel = UILabel()
    private let startButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
    
    private func setupUI() {
        view.backgroundColor = Theme.Colors.background
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = Theme.Fonts.title(size: 24)
        titleLabel.textColor = Theme.Colors.primaryBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = Theme.Fonts.body(size: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        exercisesTitleLabel.text = NSLocalizedString("exercises_list", comment: "")
        exercisesTitleLabel.font = Theme.Fonts.title(size: 18)
        exercisesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        exercisesListLabel.font = Theme.Fonts.body(size: 14)
        exercisesListLabel.numberOfLines = 0
        exercisesListLabel.textColor = .gray
        exercisesListLabel.translatesAutoresizingMaskIntoConstraints = false
        
        startButton.setTitle(NSLocalizedString("start_routine", comment: ""), for: .normal)
        startButton.backgroundColor = Theme.Colors.primaryOrange
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 10
        startButton.titleLabel?.font = Theme.Fonts.title(size: 18)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exercisesTitleLabel)
        view.addSubview(exercisesListLabel)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            exercisesTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            exercisesTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            exercisesListLabel.topAnchor.constraint(equalTo: exercisesTitleLabel.bottomAnchor, constant: 10),
            exercisesListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureData() {
        guard let routine = routine else { return }
        titleLabel.text = routine.name
        descriptionLabel.text = routine.description
        
        if let firstExercise = exercises.first {
            Task {
                await imageView.loadImageAsync(from: firstExercise.imageUrl)
            }
        }
        
        let exerciseNames = exercises.map { "• \($0.name)" }.joined(separator: "\n")
        exercisesListLabel.text = exerciseNames
    }
    
    @objc private func didTapStart() {
        guard !exercises.isEmpty else { return }
        
        if ConnectivityService.shared.isCellular {
            let alert = UIAlertController(
                title: NSLocalizedString("error_title", comment: ""),
                message: NSLocalizedString("warning_images_download", comment: ""),
                preferredStyle: .alert
            )
            let continuarAction = UIAlertAction(title: NSLocalizedString("continue_button", comment: ""), style: .default) { [weak self] _ in
                self?.navigateToExecution()
            }
            let cancelarAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
            
            alert.addAction(continuarAction)
            alert.addAction(cancelarAction)
            
            present(alert, animated: true)
        } else {
            navigateToExecution()
        }
    }
    
    private func navigateToExecution() {
        let executionVC = ExerciseExecutionController()
        executionVC.exercises = exercises
        executionVC.motivationalMessages = motivationalMessages
        if let routineName = routine?.name {
            executionVC.routineName = routineName
        }
        navigationController?.pushViewController(executionVC, animated: true)
    }
    
}
