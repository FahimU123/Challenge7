//
//  Review.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/14/25.
//

import Foundation
import StoreKit

final class ReviewManager {
    static let shared = ReviewManager()
    
    private let visitKey = "visitCount"
    private let threshold = 1
    
    private init() {}
    
    func incrementVisit() {
        let count = UserDefaults.standard.integer(forKey: visitKey)
        UserDefaults.standard.set(count + 1, forKey: visitKey)
    }
    
    func shouldRequestReview() -> Bool {
        let visits = UserDefaults.standard.integer(forKey: visitKey)
        return visits >= threshold
    }
    
    func resetCounts() {
           UserDefaults.standard.set(0, forKey: visitKey)
       }
    
}
