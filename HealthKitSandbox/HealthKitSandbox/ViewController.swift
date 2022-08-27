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
            
            let dateFormatter: DateFormatter = {
               let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd hh:mm:ss"
                return df
            }()
            
            print("분당 심박수가 100 이상일 때")
            guard let result = result else { return }
            
            print(Calendar.current.dateComponents([.day], from: startDate!, to: Date()).day ?? Int(31))
            var listOnDate: [[HKQuantitySample]] = Array.init(repeating: [], count: 32)
            
            let unit = HKUnit(from: "count/min")
            
            for sample in result {
                let data = sample as! HKQuantitySample
                if data.quantity.doubleValue(for: unit) >= 100 {
                    listOnDate[Calendar.current.dateComponents([.day], from: data.startDate).day ?? 30].append(data)
                }
            }
            
            var count = Array.init(repeating: 0, count: 24)
            
            for dataOnDay in listOnDate {
                var exist = Array.init(repeating: false, count: 24)
                
                for data in dataOnDay {
                    exist[Calendar.current.dateComponents([.hour], from: data.startDate).hour ?? 0] = true
                }
                
                for idx in 0..<24 {
                    count[idx] = count[idx] + (exist[idx] ? 1 : 0)
                }
            }
            
            print(count)
        }
        healthStore.execute(query)
    }
}

