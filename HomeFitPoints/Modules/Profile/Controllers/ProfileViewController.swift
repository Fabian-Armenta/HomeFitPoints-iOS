//
//  ProfileViewController.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 21/11/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let levelBadgeLabel = UILabel()
    private let dataCard = UIView()
    private let ageLabel = UILabel()
    private let weightLabel = UILabel()
    private let heightLabel = UILabel()
    private let editButton = UIButton(type: .system)
    private let goalTitleLabel = UILabel()
    private let goalSegmentedControl = UISegmentedControl(items: ["", "", ""])
    private let accountButton = UIButton(type: .system)
    private let versionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLevelDisplay()
        updateProfileUI()
    }
    
    private func loadData() {
        let profile = ProfileManager.shared.profile
        nameLabel.text = profile.name
        
        ageLabel.text = "\(NSLocalizedString("profile_age", comment: "")): \(profile.age)"
        weightLabel.text = "\(NSLocalizedString("profile_weight", comment: "")): \(profile.weight) kg"
        heightLabel.text = "\(NSLocalizedString("profile_height", comment: "")): \(profile.height) cm"
        
        goalSegmentedControl.selectedSegmentIndex = profile.goalIndex
    }
    
    private func updateLevelDisplay() {
        let levelData = PointsManager.shared.getNextLevelProgress()
        let currentLevelName: String
        
        if levelData.progress >= 1.0 {
            currentLevelName = NSLocalizedString("level_expert", comment: "")
        } else {
            let key = PointsManager.shared.isLevelUnlocked(requiredPoints: 100) ? "level_intermediate" : "level_beginner"
            currentLevelName = NSLocalizedString(key, comment: "")
        }
        
        levelBadgeLabel.text = " \(currentLevelName)  "
    }
    
    private func setupUI() {
        view.backgroundColor = Theme.Colors.background
        title = NSLocalizedString("profile_title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = .systemGray4
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = Theme.Colors.primaryOrange.cgColor
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = Theme.Fonts.title(size: 24)
        nameLabel.textColor = Theme.Colors.primaryBlack
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        levelBadgeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        levelBadgeLabel.textColor = .white
        levelBadgeLabel.backgroundColor = Theme.Colors.primaryOrange
        levelBadgeLabel.layer.cornerRadius = 12
        levelBadgeLabel.clipsToBounds = true
        levelBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dataCard.backgroundColor = .systemGray6
        dataCard.layer.cornerRadius = 12
        dataCard.translatesAutoresizingMaskIntoConstraints = false
        
        let stackData = UIStackView(arrangedSubviews: [ageLabel, weightLabel, heightLabel])
        stackData.axis = .horizontal
        stackData.distribution = .fillEqually
        stackData.translatesAutoresizingMaskIntoConstraints = false
        
        [ageLabel, weightLabel, heightLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .darkGray
            $0.textAlignment = .center
        }
        
        editButton.setTitle(NSLocalizedString("profile_edit", comment: ""), for: .normal)
        editButton.setTitleColor(Theme.Colors.primaryOrange, for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        
        dataCard.addSubview(stackData)
        dataCard.addSubview(editButton)
        
        goalTitleLabel.text = NSLocalizedString("profile_goal", comment: "")
        goalTitleLabel.font = Theme.Fonts.title(size: 18)
        goalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        goalSegmentedControl.setTitle(NSLocalizedString("goal_weight", comment: ""), forSegmentAt: 0)
        goalSegmentedControl.setTitle(NSLocalizedString("goal_muscle", comment: ""), forSegmentAt: 1)
        goalSegmentedControl.setTitle(NSLocalizedString("goal_endurance", comment: ""), forSegmentAt: 2)
        
        goalSegmentedControl.selectedSegmentTintColor = Theme.Colors.primaryOrange
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        goalSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        goalSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        goalSegmentedControl.addTarget(self, action: #selector(goalChanged), for: .valueChanged)
        
        accountButton.setTitle(NSLocalizedString("profile_login", comment: ""), for: .normal)
        accountButton.backgroundColor = Theme.Colors.primaryBlack
        accountButton.setTitleColor(.white, for: .normal)
        accountButton.layer.cornerRadius = 10
        accountButton.translatesAutoresizingMaskIntoConstraints = false
        accountButton.addTarget(self, action: #selector(authTapped), for: .touchUpInside)
        
        versionLabel.text = "v1.0.0"
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        versionLabel.textColor = .lightGray
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(levelBadgeLabel)
        contentView.addSubview(dataCard)
        contentView.addSubview(goalTitleLabel)
        contentView.addSubview(goalSegmentedControl)
        contentView.addSubview(accountButton)
        contentView.addSubview(versionLabel)
        
        // CONSTRAINTS
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 15),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            levelBadgeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            levelBadgeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            levelBadgeLabel.heightAnchor.constraint(equalToConstant: 26),
            
            dataCard.topAnchor.constraint(equalTo: levelBadgeLabel.bottomAnchor, constant: 30),
            dataCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dataCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dataCard.heightAnchor.constraint(equalToConstant: 100),
            
            stackData.topAnchor.constraint(equalTo: dataCard.topAnchor, constant: 20),
            stackData.leadingAnchor.constraint(equalTo: dataCard.leadingAnchor, constant: 10),
            stackData.trailingAnchor.constraint(equalTo: dataCard.trailingAnchor, constant: -10),
            
            editButton.bottomAnchor.constraint(equalTo: dataCard.bottomAnchor, constant: -10),
            editButton.centerXAnchor.constraint(equalTo: dataCard.centerXAnchor),
            
            goalTitleLabel.topAnchor.constraint(equalTo: dataCard.bottomAnchor, constant: 30),
            goalTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            goalSegmentedControl.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 15),
            goalSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            goalSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            accountButton.topAnchor.constraint(equalTo: goalSegmentedControl.bottomAnchor, constant: 50),
            accountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            accountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            accountButton.heightAnchor.constraint(equalToConstant: 50),
            
            versionLabel.topAnchor.constraint(equalTo: accountButton.bottomAnchor, constant: 20),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    @objc private func goalChanged() {
        ProfileManager.shared.updateGoal(index: goalSegmentedControl.selectedSegmentIndex)
    }
    
    @objc private func authTapped() {
        if AuthManager.shared.isUserLoggedIn {
            AuthManager.shared.logout { _ in
                self.updateProfileUI()
            }
            return
        }
        
        let loginVC = LoginViewController()
        loginVC.onLoginSuccess = { [weak self] in
            self?.updateProfileUI()
        }
        
        present(loginVC, animated: true)
    }
    
    private func updateProfileUI() {
        loadData()
        let btnTitle = AuthManager.shared.isUserLoggedIn ? NSLocalizedString("logout_btn", comment: "") : NSLocalizedString("profile_login", comment: "")
        let btnColor = AuthManager.shared.isUserLoggedIn ? UIColor.systemRed : Theme.Colors.primaryBlack
        
        accountButton.setTitle(btnTitle, for: .normal)
        accountButton.backgroundColor = btnColor
        
        if let email = AuthManager.shared.currentUserEmail {
            nameLabel.text = email
        }
    }
    
    @objc private func editTapped() {
        let alert = UIAlertController(title: NSLocalizedString("profile_edit_title", comment: ""), message: nil, preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = NSLocalizedString("profile_name_ph", comment: "")
            tf.text = ProfileManager.shared.profile.name
        }
        alert.addTextField { tf in
            tf.placeholder = NSLocalizedString("profile_age", comment: "")
            tf.keyboardType = .numberPad
            tf.text = ProfileManager.shared.profile.age == "--" ? "" : ProfileManager.shared.profile.age
        }
        alert.addTextField { tf in
            tf.placeholder = NSLocalizedString("profile_ph_weight", comment: "")
            tf.keyboardType = .decimalPad
            tf.text = ProfileManager.shared.profile.weight == "--" ? "" : ProfileManager.shared.profile.weight
        }
        alert.addTextField { tf in
            tf.placeholder = NSLocalizedString("profile_ph_height", comment: "")
            tf.keyboardType = .numberPad
            tf.text = ProfileManager.shared.profile.height == "--" ? "" : ProfileManager.shared.profile.height
        }
        
        let saveAction = UIAlertAction(title: NSLocalizedString("save", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else { return }
            let name = alert.textFields?[0].text ?? ""
            let age = alert.textFields?[1].text ?? "--"
            let weight = alert.textFields?[2].text ?? "--"
            let height = alert.textFields?[3].text ?? "--"
            
            ProfileManager.shared.updateData(name: name, age: age, weight: weight, height: height)
            self.loadData()
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
}
