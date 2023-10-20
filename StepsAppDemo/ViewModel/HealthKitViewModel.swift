//
//  HealthKitViewModel.swift
//  StepsAppDemo
//
//  Created by liuhao on 18/10/2023.
//

import Foundation
import HealthKit

class HealthKitViewModel: ObservableObject {
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    var stepCount: Int = 0
    
   
    @Published var steps = [StepsModel]()
    @Published var calories = [CaloryModel]()
    @Published var distances = [DistanceWalkingModel]()
    @Published var durations = [DurationModel]()
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    var authorizationStatus: Bool {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return false}
        guard let distanceWalkingType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else { return false}
        guard let activityBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else { return false}
        guard let duration = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else { return false}
        let statusStepsCount = self.healthStore?.authorizationStatus(for: stepCountType)
        let statusDistanceWalking = self.healthStore?.authorizationStatus(for: distanceWalkingType)
        let statusActivityEnergyBurned = self.healthStore?.authorizationStatus(for: activityBurned)
        let statusExerciseDuration = self.healthStore?.authorizationStatus(for: duration)
        
        guard statusStepsCount == .sharingAuthorized else {
            return false
        }
        guard statusDistanceWalking == .sharingAuthorized else {
            return false
        }
        guard statusActivityEnergyBurned == .sharingAuthorized else {
            return false
        }
        guard statusExerciseDuration == .sharingAuthorized else {
            return false
        }
        return true
    }
    
    var currentSteps: Int {
        steps.last?.stepsCount ?? 0
    }
    
    var currentCalories: Double {
        calories.last?.calory ?? 0
    }
    
    var currentDistance: Double {
        distances.last?.distanceWalking ?? 0
    }
    
    var currentDuration: Int {
        durations.last?.duration ?? 0
    }
    
    func querySteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let anchorDate = Date.sundayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        query = HKStatisticsCollectionQuery(quantityType: stepType,
                                    quantitySamplePredicate: predicate,
                                    options: .cumulativeSum,
                                    anchorDate: anchorDate,
                                    intervalComponents: daily)
        query!.initialResultsHandler = { query, statsCollection, error in
            completion(statsCollection)
        }

        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    func queryCalories(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let calory = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let anchorDate = Date.sundayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: calory,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        query!.initialResultsHandler = { query, statsCollection, error in
            completion(statsCollection)
        }
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    func queryDistance(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        let distance = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let anchorDate = Date.sundayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: distance,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        
        query!.initialResultsHandler = { query, statsCollection, error in
            completion(statsCollection)
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    func queryExerciseTime(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        let duration = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())
        let anchorDate = Date.sundayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: duration,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        
        query!.initialResultsHandler = { query, statsCollection, error in
            completion(statsCollection)
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    func updateUIFromStats(_ statsCollection: HKStatisticsCollection) {
        DispatchQueue.main.async {
            self.steps.removeAll()
        }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let endDate = Date()
        statsCollection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
            
            let count = stats.sumQuantity()?.doubleValue(for: .count())
            let step = StepsModel(id: UUID(), date: stats.startDate, stepsCount: Int(count ?? 0))
            
            DispatchQueue.main.async {
                self.steps.append(step)
                self.stepCount = self.steps.last?.stepsCount ?? 0
            }
        }
    }
    
    func updateCalorieUIFromStats(_ statsCollection: HKStatisticsCollection) {
        DispatchQueue.main.async {
            self.calories.removeAll()
        }
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let endDate = Date()
        
        statsCollection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
           
            let caloriesBurned = stats.sumQuantity()?.doubleValue(for: .largeCalorie())
            let calory = CaloryModel(date: stats.startDate, calory: caloriesBurned ?? 0)
            
            DispatchQueue.main.async {
                self.calories.append(calory)
            }
        }
    }
    
    func updateDistanceUIFromStats(_ statsCollection: HKStatisticsCollection) {
        DispatchQueue.main.async {
            self.distances.removeAll()
        }
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let endDate = Date()
        
        statsCollection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
            
            let distanceWalked = stats.sumQuantity()?.doubleValue(for: .meter())
            let distance = DistanceWalkingModel(date: stats.startDate, distanceWalking: distanceWalked ?? 0)
            
            DispatchQueue.main.async {
                self.distances.append(distance)
            }
        }
    }
    
    func updateExerciseTimeUIFromStats(_ statsCollection: HKStatisticsCollection) {
        DispatchQueue.main.async {
            self.durations.removeAll()
        }
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let endDate = Date()
        
        statsCollection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
            let durationWalked = stats.sumQuantity()?.doubleValue(for: .minute())
            let duration = DurationModel(date: stats.startDate, duration: Int(durationWalked ?? 0))
            
            DispatchQueue.main.async {
                self.durations.append(duration)
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let calorieType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let distanceType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!
        guard let healthStore = self.healthStore else { return  completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType, calorieType, distanceType, exerciseTimeType]) { success, error in
            
            completion(success)
        }
    }
}


