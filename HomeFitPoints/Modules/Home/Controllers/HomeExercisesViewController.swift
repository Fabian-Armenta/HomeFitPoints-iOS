//
//  HomeExercisesViewController.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 19/11/25.
//

import UIKit

class HomeExercisesViewController: UIViewController {
    
    private let tableView = UITableView()
    private let service = ExerciseService()
    private var levels: [Level] = []
    private var fitnessData: FitnessResponse?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupView() {
        title = NSLocalizedString("home_title", comment: "")
        view.backgroundColor = Theme.Colors.background
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(ExerciseLevelCell.self, forCellReuseIdentifier: ExerciseLevelCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func fetchData() {
        if !refreshControl.isRefreshing {
            activityIndicator.startAnimating()
        }
        
        if ConnectivityService.shared.isCellular {
            let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""),
                                          message: NSLocalizedString("warning_data", comment: ""),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { _ in
                self.performRequest()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { _ in
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }))
            present(alert, animated: true)
        } else {
            performRequest()
        }
    }
    
    // CORUTINAS
    private func performRequest() {
        Task {
            do {
                let response = try await service.getFitnessData()
                self.fitnessData = response
                self.levels = response.levels
                self.tableView.reloadData()
                
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                
            } catch {
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                self.showError(error)
            }
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""),
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension HomeExercisesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return levels[section].name.uppercased()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels[section].routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseLevelCell.identifier, for: indexPath) as? ExerciseLevelCell else { return UITableViewCell() }
        
        let level = levels[indexPath.section]
        let routine = level.routines[indexPath.row]
        let isLocked = !PointsManager.shared.isLevelUnlocked(requiredPoints: level.requiredPoints)
        
        cell.configure(with: routine, isLocked: isLocked, requiredPts: level.requiredPoints)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let level = levels[indexPath.section]
        let routine = level.routines[indexPath.row]
        
        if PointsManager.shared.isLevelUnlocked(requiredPoints: level.requiredPoints) {
            let detailVC = RoutineDetailViewController()
            
            let routineExercises = routine.exerciseIds.compactMap { id in
                return fitnessData?.exercises.first(where: { $0.id == id })
            }
            
            detailVC.routine = routine
            detailVC.exercises = routineExercises
            detailVC.motivationalMessages = fitnessData?.motivationalMessages ?? []
            
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let msg = String(format: NSLocalizedString("status_locked", comment: ""), level.requiredPoints)
            let alert = UIAlertController(title: "Bloqueado", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
