//
//  UserDefaultsManager.swift
//  Holy places
//
//  Created by Andrei Belyi on 14/02/25.
//


import Foundation

class UserDefaultsManager {
    static func saveSelectedCategories(_ categories: Set<HolyPlaceCategory>) {
        let categoryNames = categories.map { $0.rawValue }
        UserDefaults.standard.set(categoryNames, forKey: "selectedCategories")
    }

    static func getSavedCategories() -> Set<HolyPlaceCategory> {
        guard let categoryNames = UserDefaults.standard.array(forKey: "selectedCategories") as? [String] else {
            return []
        }
        return Set(categoryNames.compactMap { HolyPlaceCategory(rawValue: $0) })
    }
}