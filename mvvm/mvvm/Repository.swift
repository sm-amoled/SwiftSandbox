//
//  Repository.swift
//  mvvm
//
//  Created by Park Sungmin on 2022/10/15.
//

import Foundation

class Repository {
    func fetchNow(onCompleted: @escaping (UtcTimeModel) -> Void) {
        let url = "http://worldclockapi.com/api/json/utc/now"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] data, _, _ in
            guard let data = data else {
                print("No Data")
                return
            }
            guard let model = try? JSONDecoder().decode(UtcTimeModel.self, from: data) else { return }
            
            onCompleted(model)
            
//            let formatter: DateFormatter = {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"
//
//                return dateFormatter
//            }()
//            guard let now = formatter.date(from: model.currentDateTime) else { return }
//
//            DispatchQueue.main.async {
//                onCompleted(now)
//            }
        }.resume()
    }
}
