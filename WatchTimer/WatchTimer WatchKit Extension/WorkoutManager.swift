//
//  HealthKitManager.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/21.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    static let shared = HealthKitManager()
    
    let healthStore = HKHealthStore()
    
    let typeToShare = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
    let typeToRead = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
    
    private init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
          return
        }
        
        print("requestAuthorization")
        self.healthStore.requestAuthorization(toShare: [typeToShare!], read: [typeToRead!]) { success, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if success {
                    print("권한 승인 완료")
                } else {
                    print("권한 승인 실패")
                }
            }
        }
    }
    
    class func saveExerciseTime() {
        guard let exerciseTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            print("Apple Exercise Type을 찾을 수 없음")
            return
        }
        
        let exerciseQuantity = HKQuantity(unit: HKUnit.minute(), doubleValue: <#T##Double#>)
    }
    
    class func saveBodyMassIndexSample(bodyMassIndex: Double, date: Date) {
      
      //1.  Make sure the body mass type exists
      guard let bodyMassIndexType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) else {
        fatalError("Body Mass Index Type is no longer available in HealthKit")
      }
        
      //2.  Use the Count HKUnit to create a body mass quantity
      let bodyMassQuantity = HKQuantity(unit: HKUnit.count(),
                                        doubleValue: bodyMassIndex)
        
      let bodyMassIndexSample = HKQuantitySample(type: bodyMassIndexType,
                                                 quantity: bodyMassQuantity,
                                                 start: date,
                                                 end: date)
        
      //3.  Save the same to HealthKit
      HKHealthStore().save(bodyMassIndexSample) { (success, error) in
          
        if let error = error {
          print("Error Saving BMI Sample: \(error.localizedDescription)")
        } else {
          print("Successfully saved BMI Sample")
        }
      }
    }
}
