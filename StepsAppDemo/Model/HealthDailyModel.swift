//
//  HealthDailyModel.swift
//  StepsAppDemo
//
//  Created by liuhao on 19/10/2023.
//

import Foundation
struct HealthDailyModel: Identifiable {
    let id = UUID()
    
    let date: Date
    let stepsCount: Double
    let calories: Double
    let distanceWalking: Double
    let duration: Double
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyy")
        return formatter.string(from: date)
    }
}

struct StepsModel: Identifiable {
    var id = UUID()
    
    let date: Date
    let stepsCount: Int
}

struct DistanceWalkingModel {
    let date: Date
    let distanceWalking: Double
}

struct CaloryModel {
    let date: Date
    let calory: Double
}

struct DurationModel {
    let date: Date
    let duration: Int
}

