//
//  ProgressViewController.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 22/11/25.
//

import UIKit

class ProgressViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let totalCard = UIView()
    private let totalLabel = UILabel()
    
    private let levelLabel = UILabel()
    private let levelProgress = UIProgressView(progressViewStyle: .bar)
    private let nextLevelLabel = UILabel()
    
    private let chartTitle = UILabel()
    private let chartView = WeeklyBarChartView()
    
    private let statsTitle = UILabel()
    private let statsTable = UITableView()
    
    private let emptyView = UIView()
    private var statsData: [(name: String, count: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Colors.background
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    private func reload() {
        if PointsManager.shared.history.isEmpty {
            scrollView.isHidden = true
            emptyView.isHidden = false
        } else {
            scrollView.isHidden = false
            emptyView.isHidden = true
            
            let total = PointsManager.shared.currentPoints
            totalLabel.text = "\(NSLocalizedString("points_total", comment: "")): \(total)"
            
            let lvl = PointsManager.shared.getNextLevelProgress()
            if lvl.progress >= 1.0 {
                levelLabel.text = NSLocalizedString("level_expert", comment: "")
                nextLevelLabel.text = NSLocalizedString("level_max", comment: "")
                levelProgress.progress = 1.0
            } else {
                let levelKey = PointsManager.shared.isLevelUnlocked(requiredPoints: 100) ? "level_intermediate" : "level_beginner"
                let name = NSLocalizedString(levelKey, comment: "")
                levelLabel.text = "\(NSLocalizedString("level_current", comment: "")): \(name)"
                nextLevelLabel.text = String(format: NSLocalizedString("points_missing", comment: ""), lvl.pointsNeeded)
                levelProgress.progress = lvl.progress
            }
            
            chartView.setData(PointsManager.shared.getLast7DaysPoints())
            
            statsData = PointsManager.shared.getRoutineCounts()
            statsTable.reloadData()
            
            let h = CGFloat(statsData.count * 60)
            statsTable.constraints.first { $0.firstAttribute == .height }?.constant = max(h, 50)
        }
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        totalCard.backgroundColor = Theme.Colors.primaryBlack
        totalCard.layer.cornerRadius = 16
        totalCard.translatesAutoresizingMaskIntoConstraints = false
        
        let trophy = UIImageView(image: UIImage(systemName: "trophy.fill"))
        trophy.tintColor = Theme.Colors.primaryOrange
        trophy.translatesAutoresizingMaskIntoConstraints = false
        
        totalLabel.font = Theme.Fonts.title(size: 22)
        totalLabel.textColor = .white
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        totalCard.addSubview(trophy)
        totalCard.addSubview(totalLabel)
        
        levelLabel.font = .boldSystemFont(ofSize: 16)
        levelLabel.textColor = Theme.Colors.primaryBlack
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        levelProgress.trackTintColor = .systemGray5
        levelProgress.progressTintColor = Theme.Colors.primaryOrange
        levelProgress.layer.cornerRadius = 6
        levelProgress.clipsToBounds = true
        levelProgress.translatesAutoresizingMaskIntoConstraints = false
        
        nextLevelLabel.font = .systemFont(ofSize: 12)
        nextLevelLabel.textColor = .gray
        nextLevelLabel.textAlignment = .right
        nextLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        chartTitle.text = NSLocalizedString("chart_week", comment: "")
        chartTitle.font = Theme.Fonts.title(size: 18)
        chartTitle.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        statsTitle.text = NSLocalizedString("chart_favorites", comment: "")
        statsTitle.font = Theme.Fonts.title(size: 18)
        statsTitle.translatesAutoresizingMaskIntoConstraints = false
        
        statsTable.dataSource = self
        statsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        statsTable.isScrollEnabled = false
        statsTable.backgroundColor = .clear
        statsTable.separatorStyle = .none
        statsTable.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(totalCard)
        contentView.addSubview(levelLabel)
        contentView.addSubview(levelProgress)
        contentView.addSubview(nextLevelLabel)
        contentView.addSubview(chartTitle)
        contentView.addSubview(chartView)
        contentView.addSubview(statsTitle)
        contentView.addSubview(statsTable)
        
        setupEmptyView()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            totalCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            totalCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            totalCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            totalCard.heightAnchor.constraint(equalToConstant: 80),
            
            trophy.leadingAnchor.constraint(equalTo: totalCard.leadingAnchor, constant: 20),
            trophy.centerYAnchor.constraint(equalTo: totalCard.centerYAnchor),
            trophy.widthAnchor.constraint(equalToConstant: 30),
            trophy.heightAnchor.constraint(equalToConstant: 30),
            
            totalLabel.leadingAnchor.constraint(equalTo: trophy.trailingAnchor, constant: 15),
            totalLabel.centerYAnchor.constraint(equalTo: totalCard.centerYAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: totalCard.bottomAnchor, constant: 30),
            levelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            levelProgress.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 10),
            levelProgress.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            levelProgress.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            levelProgress.heightAnchor.constraint(equalToConstant: 12),
            
            nextLevelLabel.topAnchor.constraint(equalTo: levelProgress.bottomAnchor, constant: 8),
            nextLevelLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            chartTitle.topAnchor.constraint(equalTo: nextLevelLabel.bottomAnchor, constant: 30),
            chartTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            chartView.topAnchor.constraint(equalTo: chartTitle.bottomAnchor, constant: 10),
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalToConstant: 180),
            
            statsTitle.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 30),
            statsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            statsTable.topAnchor.constraint(equalTo: statsTitle.bottomAnchor, constant: 10),
            statsTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statsTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statsTable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            statsTable.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupEmptyView() {
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        
        let icon = UIImageView(image: UIImage(systemName: "dumbbell.fill"))
        icon.tintColor = .systemGray4
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = NSLocalizedString("empty_title", comment: "")
        label.font = Theme.Fonts.title(size: 22)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let btn = UIButton(type: .system)
        btn.setTitle(NSLocalizedString("btn_go_train", comment: ""), for: .normal)
        btn.backgroundColor = Theme.Colors.primaryOrange
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        
        emptyView.addSubview(icon)
        emptyView.addSubview(label)
        emptyView.addSubview(btn)
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            icon.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -50),
            icon.widthAnchor.constraint(equalToConstant: 80),
            icon.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            
            btn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            btn.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            btn.widthAnchor.constraint(equalToConstant: 180),
            btn.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func goHome() {
        tabBarController?.selectedIndex = 0
    }
}

extension ProgressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let item = statsData[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.textLabel?.text = item.name
        cell.textLabel?.font = Theme.Fonts.body(size: 16)
        cell.detailTextLabel?.text = "\(item.count)"
        cell.detailTextLabel?.textColor = Theme.Colors.primaryOrange
        
        cell.imageView?.image = UIImage(systemName: "rosette")
        cell.imageView?.tintColor = indexPath.row == 0 ? .systemYellow : .gray
        
        return cell
    }
}
