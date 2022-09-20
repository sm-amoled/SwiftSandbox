//
//  TimeModel.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/20.
//

import Foundation

struct WorkoutTime {
    var time: Int = 0
    
    func timeToString() -> String {
        let minute = time / 60
        let second = time % 60
        
        return String(format: "%02d:%02d", minute, second)
    }    
}
