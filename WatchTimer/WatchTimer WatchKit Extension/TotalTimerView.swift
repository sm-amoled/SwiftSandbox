//
//  TotalTimerView.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/19.
//

import SwiftUI

struct TotalTimerView: View {
    
    @EnvironmentObject var totalTimer: TotalTimer
    
    var body: some View {
        HStack {
            Text("총 시간 \(totalTimer.entireTime.timeToString())")
        }
        .frame(height: 40)
    }
}
