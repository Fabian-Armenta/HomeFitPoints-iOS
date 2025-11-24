//
//  WeeklyBarChartView.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 22/11/25.
//


import UIKit

class WeeklyBarChartView: UIView {
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.alignment = .bottom
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    func setData(_ data: [(day: String, points: Int)]) {
        mainStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let maxPoints = data.map { $0.points }.max() ?? 1
        let safeMax = maxPoints == 0 ? 1 : maxPoints
        
        for item in data {
            let bar = createBar(day: item.day, points: item.points, max: safeMax)
            mainStack.addArrangedSubview(bar)
        }
    }
    
    private func createBar(day: String, points: Int, max: Int) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 4
        container.alignment = .center
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let barView = UIView()
        barView.backgroundColor = points > 0 ? Theme.Colors.primaryOrange : .systemGray5
        barView.layer.cornerRadius = 6
        barView.translatesAutoresizingMaskIntoConstraints = false
        
        let maxHeight: CGFloat = 140
        let height = CGFloat(points) / CGFloat(max) * maxHeight
        let finalHeight = points > 0 ? Swift.max(height, 20) : 10
        
        barView.heightAnchor.constraint(equalToConstant: finalHeight).isActive = true
        barView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        let label = UILabel()
        label.text = day
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        container.addArrangedSubview(barView)
        container.addArrangedSubview(label)
        return container
    }
}
