//
//  ViewModel.swift
//  mvvm
//
//  Created by Park Sungmin on 2022/10/15.
//

import Foundation
import RxRelay

class ViewModel {
    
    let dateTimeString = BehaviorRelay(value: "Loading...")
    
    let service = Service()
    
    private func dateToString(date: Date) -> String {
        let formatter: DateFormatter = {
           let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
            return formatter
        }()
        
        return formatter.string(from: date)
    }
    
    func reload() {
        service.fetchNow { [weak self] model in
            guard let self = self else { return }
            
            let dateString = self.dateToString(date: model.currentDateTime)
            self.dateTimeString.accept(dateString)
        }
    }
    
    func moveDay(day: Int) {
        service.moveDay(day: day)
        dateTimeString.accept(dateToString(date: service.currentModel.currentDateTime))
    }
}
