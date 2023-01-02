//
//  backgroundTimerApp.swift
//  backgroundTimer
//
//  Created by Park Sungmin on 2022/12/22.
//

import SwiftUI

@main
struct backgroundTimerApp: App {
    
    // MARK: Background Fetching 수행을 위한 initialize
    @StateObject var timerModel: TimerModel = .init()
    
    @Environment(\.scenePhase) var phase
    
    @State var lastActiveTimeStamp: Date = Date()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
        }
        .onChange(of: phase) { newValue in
            if timerModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                
                if newValue == .active {
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    
                    if timerModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        timerModel.isStarted = false
                        timerModel.isFinished = true
                        timerModel.totalSeconds = 0
                        
                        timerModel.progress = 1
                    } else {
                        timerModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}
