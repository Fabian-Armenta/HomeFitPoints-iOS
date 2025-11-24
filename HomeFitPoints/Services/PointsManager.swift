//
//  PointsManager.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 19/11/25.
//

import Foundation

struct WorkoutLog: Codable {
    let date: Date
    let points: Int
    let routineName: String
}

class PointsManager {
    static let shared = PointsManager()
    
    private let kPointsKey = "userFitPoints"
    private let kHistoryKey = "userWorkoutHistory"
    
    var currentPoints: Int {
        return UserDefaults.standard.integer(forKey: kPointsKey)
    }
    
    var history: [WorkoutLog] {
        guard let data = UserDefaults.standard.data(forKey: kHistoryKey),
              let logs = try? JSONDecoder().decode([WorkoutLog].self, from: data) else {
            return []
        }
        return logs
    }
    
    func logWorkout(points: Int, routineName: String) {
        let newTotal = currentPoints + points
        UserDefaults.standard.set(newTotal, forKey: kPointsKey)
        
        var currentHistory = history
        let newLog = WorkoutLog(date: Date(), points: points, routineName: routineName)
        currentHistory.append(newLog)
        
        if let encoded = try? JSONEncoder().encode(currentHistory) {
            UserDefaults.standard.set(encoded, forKey: kHistoryKey)
        }
    }
    
    func isLevelUnlocked(requiredPoints: Int) -> Bool {
        return currentPoints >= requiredPoints
    }
    
    func getLast7DaysPoints() -> [(day: String, points: Int)] {
        var result: [(String, Int)] = []
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.current
        
        let today = Date()
        let logs = history
        
        for i in (0...6).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            
            let dailyPoints = logs.filter { calendar.isDate($0.date, inSameDayAs: date) }
                .reduce(0) { $0 + $1.points }
            
            let weekdayIndex = calendar.component(.weekday, from: date)
            
            let letter = getDayLetter(weekday: weekdayIndex)
            
            result.append((letter, dailyPoints))
        }
        return result
    }
    
    private func getDayLetter(weekday: Int) -> String {
        switch weekday {
        case 1: return NSLocalizedString("day_sun", comment: "")
        case 2: return NSLocalizedString("day_mon", comment: "")
        case 3: return NSLocalizedString("day_tue", comment: "")
        case 4: return NSLocalizedString("day_wed", comment: "")
        case 5: return NSLocalizedString("day_thu", comment: "")
        case 6: return NSLocalizedString("day_fri", comment: "")
        case 7: return NSLocalizedString("day_sat", comment: "")
        default: return "?"
        }
    }
    
    func getRoutineCounts() -> [(name: String, count: Int)] {
        let logs = history
        var counts: [String: Int] = [:]
        
        for log in logs {
            counts[log.routineName, default: 0] += 1
        }
        
        return counts.map { ($0.key, $0.value) }.sorted { $0.count > $1.count }
    }
    
    func getNextLevelProgress() -> (nextLevel: String, progress: Float, pointsNeeded: Int) {
        let current = currentPoints
        
        if current < 100 {
            return (NSLocalizedString("level_intermediate", comment: ""), Float(current) / 100.0, 100 - current)
        } else if current < 250 {
            let progress = Float(current - 100) / 150.0
            return (NSLocalizedString("level_advanced", comment: ""), progress, 250 - current)
        } else {
            return (NSLocalizedString("level_max", comment: ""), 1.0, 0)
        }
    }
}
