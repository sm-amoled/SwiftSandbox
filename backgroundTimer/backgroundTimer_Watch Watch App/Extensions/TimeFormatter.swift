//
//  Double+.swift
//  backgroundTimer_Watch Watch App
//
//  Created by Park Sungmin on 2023/01/04.
//

import Foundation

extension Double {
    func convertToTimeFormat() -> String {
        let minute = Int(self) / 60
        let second = Int(self) % 60
        
        return String(format: "%02d:%02d", minute, second)
    }
}

extension Int {
    func convertToTimeFormat() -> String {
        let minute = self / 60
        let second = self % 60
        
        return String(format: "%02d:%02d", minute, second)
    }
}
