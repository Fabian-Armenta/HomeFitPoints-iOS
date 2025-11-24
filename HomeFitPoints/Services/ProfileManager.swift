//
//  ProfileManager.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 22/11/25.
//


import Foundation
import UIKit

struct UserProfile: Codable {
    var name: String
    var age: String
    var weight: String
    var height: String
    var goalIndex: Int
}

class ProfileManager {
    static let shared = ProfileManager()
    private let kProfileKey = "userLocalProfile"
    
    private var defaultName: String {
        return NSLocalizedString("profile_default_name", comment: "")
    }
    
    var profile: UserProfile {
        get {
            if let data = UserDefaults.standard.data(forKey: kProfileKey),
               let savedProfile = try? JSONDecoder().decode(UserProfile.self, from: data) {
                return savedProfile
            }
            return UserProfile(name: defaultName, age: "--", weight: "--", height: "--", goalIndex: 0)
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: kProfileKey)
            }
        }
    }
    
    func updateGoal(index: Int) {
        var current = profile
        current.goalIndex = index
        profile = current
    }
    
    func updateData(name: String, age: String, weight: String, height: String) {
        var current = profile
        current.name = name.isEmpty ? defaultName : name
        current.age = age
        current.weight = weight
        current.height = height
        profile = current
    }
}
