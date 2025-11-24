//
//  FitnessModel.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 18/11/25.
//

import Foundation

struct FitnessResponse: Codable {
    let levels: [Level]
    let exercises: [Exercise]
    let motivationalMessages: [String]
    enum CodingKeys: String, CodingKey {
        case levels, exercises
        case motivationalMessages = "motivational_messages"
    }
}

struct Level: Codable {
    let levelNameKey: String
    let routines: [Routine]
    enum CodingKeys: String, CodingKey {
        case levelNameKey = "level_name_key"
        case routines
    }
    
    var requiredPoints: Int {
        switch levelNameKey {
        case "level_beginner": return 0
        case "level_intermediate": return 100
        case "level_advanced": return 250
        default: return 0
        }
    }
    
    var name: String {
        return NSLocalizedString(levelNameKey, comment: "")
    }
}


struct Routine: Codable, Identifiable {
    let id: String
    let nameKey: String
    let descriptionKey: String
    let durationMinutes: Int
    let exerciseIds: [Int]
    enum CodingKeys: String, CodingKey {
        case id
        case nameKey = "name_key"
        case descriptionKey = "description_key"
        case durationMinutes = "duration_minutes"
        case exerciseIds = "exercise_ids"
    }
    var name: String { return NSLocalizedString(nameKey, comment: "") }
    var description: String { return NSLocalizedString(descriptionKey, comment: "") }
}

struct Exercise: Codable, Identifiable {
    let id: Int
    let nameKey: String
    let descriptionKey: String
    let typeKey: String
    let imageName: String
    let imageUrl: String
    let unit: String
    let value: Int
    let points: Int

    enum CodingKeys: String, CodingKey {
        case id
        case nameKey = "name_key"
        case descriptionKey = "description_key"
        case typeKey = "type_key"
        case imageName = "image_name"
        case imageUrl = "image_url"
        case unit, value, points
    }
    var name: String { return NSLocalizedString(nameKey, comment: "") }
}
