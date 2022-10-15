//
//  Logic.swift
//  mvvm
//
//  Created by Park Sungmin on 2022/10/15.
//

import Foundation

class Service {
    
    let repository = Repository()
    var currentModel = Model(currentDateTime: Date())
    
    func fetchNow(onCompleted: @escaping (Model) -> Void) {
        repository.fetchNow { [weak self] entity in
            
            let formatter: DateFormatter = {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
                
                return dateFormatter
            }()
            
            guard let now = formatter.date(from: entity.currentDateTime) else { return }
            
            let model = Model(currentDateTime: now)
            self?.currentModel = model
            
            onCompleted(model)
        }
    }
    
    func moveDay(day: Int) {
        guard let movedDay = Calendar.current.date(byAdding: .day,
                                                   value: day,
                                                   to: currentModel.currentDateTime) else { return }
        
        currentModel.currentDateTime = movedDay
    }
}
