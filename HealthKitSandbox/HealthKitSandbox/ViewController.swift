//
//  ViewController.swift
//  HealthKitSandbox
//
//  Created by Park Sungmin on 2022/08/12.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        // Do any additional setup after loading the view.
    }
    
    func authorizeHealthKit() {
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        
        healthStore.requestAuthorization(toShare: share, read: read) { (chk, error) in
            if chk {
                print("접근 허용함")
                self.latestHeartRate()
            }
        }
    }
    
    func latestHeartRate() {
        // HealthKit에서 어떤 정보를 가져오려고 하는가? -> 심박수 데이터를 가져오기
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
//        guard let sampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        
        // 가져올 데이터에 대한 쿼리 작성 (1달 전 부터 오늘까지의 데이터를 가져오려고 한다)
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        // 가져온 데이터를 어떻게 정렬할 것인가? -> 날짜 순으로 정렬하기
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: Int(HKObjectQueryNoLimit), // 데이터 개수 제한 없이 들고옴
                                  sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            guard error == nil else { return }
            
            // 가져온 결과인 result를 가지고 작업 수행하기
            let data = result![0] as! HKQuantitySample
            let unit = HKUnit(from: "count/min")
            let latestHeartRate = data.quantity.doubleValue(for: unit)
            print("Latest Heart Rate : \(latestHeartRate)")
            
            let dateFormatter: DateFormatter = {
               let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd hh:mm:ss"
                return df
            }()
            
            let startDate = dateFormatter.string(from: data.startDate)
            let endDate = dateFormatter.string(from: data.endDate)
            print("StartDate \(startDate) : EndDate \(endDate)")
            
        }
        healthStore.execute(query)
    }
}

