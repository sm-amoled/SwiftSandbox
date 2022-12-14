//
//  ActivityRingsView.swift
//  MyWorkout WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/26.
//

import Foundation
import HealthKit
import SwiftUI

struct ActivityRingsView: WKInterfaceObjectRepresentable {

    let healthStore: HKHealthStore
    
    func makeWKInterfaceObject(context: Context) -> some WKInterfaceObject {
        let activityRingsObject = WKInterfaceActivityRing()
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day], from: Date())
        components.calendar = calendar
        
        let predicate = HKQuery.predicateForActivitySummary(with: components)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { query, summaries, error in
            DispatchQueue.main.async {
                activityRingsObject.setActivitySummary(summaries?.first, animated: true)
            }
        }
        
        healthStore.execute(query)
        
        return activityRingsObject
    }
    
    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceObjectType, context: Context) {
         
    }
    
    func getValue() {
        let stepType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let monday = getMondayDate()
        let daily = DateComponents(day: 1)
        
        let exactlySevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let oneWeekAgo = HKQuery.predicateForSamples(withStart: exactlySevenDaysAgo, end: nil, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: stepType,
                                                 quantitySamplePredicate: oneWeekAgo,
                                                 options: .cumulativeSum,
                                                 anchorDate: monday,
                                                 intervalComponents: daily)
        
        query.initialResultsHandler = { query, statisticsCollection, error in
            // ????????? statisticsCollection??? handler??? ????????????.
            // ?????????, nil ?????? ??? ?????? ????????? ????????? ????????????.
            
            if let statisticsCollection = statisticsCollection { 
                // statisticsCollection ???????????? ????????? ?????? ??????
                
            }
        }
    }
    
    func getMondayDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-e-EEEE"    //e??? 1~7(sun~sat)

        let day = formatter.string(from:Date())
        let today = day.components(separatedBy: "-") // [0] = MMM, [1] = dd, [2] = e(1), [3] = EEEE(Sunday)
        
        guard let interval = Double(today[2]) else { return Date() }
        
        return Date(timeIntervalSinceNow: -(86400 * (interval-1))) //??????????????? ??????????????? -1??????
    }
}
