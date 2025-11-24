//
//  ExerciseLevelCell.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 19/11/25.
//

import UIKit

class ExerciseLevelCell: UITableViewCell {
    static let identifier = "ExerciseLevelCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.secondaryMediumGray
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.title(size: 20)
        label.textColor = Theme.Colors.primaryOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.body(size: 14)
        label.textColor = Theme.Colors.textWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lockIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "lock.fill")
        iv.tintColor = .gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("Error") }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(statusLabel)
        cardView.addSubview(lockIcon)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            statusLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            
            lockIcon.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            lockIcon.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            lockIcon.widthAnchor.constraint(equalToConstant: 24),
            lockIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with routine: Routine, isLocked: Bool, requiredPts: Int) {
        titleLabel.text = routine.name
        if isLocked {
            statusLabel.text = String(format: NSLocalizedString("status_locked", comment: ""), requiredPts)
            statusLabel.textColor = .gray
            lockIcon.isHidden = false
            cardView.alpha = 0.6
        } else {
            statusLabel.text = NSLocalizedString("status_available", comment: "") + " • \(routine.durationMinutes) min"
            statusLabel.textColor = Theme.Colors.textWhite
            lockIcon.isHidden = true
            cardView.alpha = 1.0
        }
    }
}
