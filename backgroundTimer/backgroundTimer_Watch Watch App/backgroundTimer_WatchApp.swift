//
//  backgroundTimer_WatchApp.swift
//  backgroundTimer_Watch Watch App
//
//  Created by Park Sungmin on 2023/01/03.
//

import SwiftUI

@main
struct backgroundTimer_Watch_Watch_AppApp: App {
    
    @StateObject var timerModel: TimerModel = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
        }
    }
}
