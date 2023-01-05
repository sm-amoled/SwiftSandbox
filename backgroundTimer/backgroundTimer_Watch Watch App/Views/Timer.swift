//
//  Timer.swift
//  backgroundTimer_Watch Watch App
//
//  Created by Park Sungmin on 2023/01/04.
//

import SwiftUI
import WatchKit
import UserNotifications

struct TimerView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    @EnvironmentObject var timerModel: TimerModel
    
    @State var latActiveTimeStamp: Date = Date()
    
    var totalTime: Int = 0
    
    init(totalTime: Int) {
        self.totalTime = totalTime
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 8) {
                
                Spacer()
                
                // Time Labels
                TimelineView(.periodic(from: .now, by: 0.5)) { context in
                    if context.cadence == .live {
                        VStack(spacing: -5) {
                            Text("\(timerModel.timerTotalStringValue)")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                            Text("\(timerModel.timerLeftStringValue)")
                                .font(.system(size: 50, weight: .medium))
                        }
                    } else {
                        TimelineView(.periodic(from: .now, by: 1)) { context in
                            Text("\(timerModel.timerLeftStringValue)")
                                .font(.system(size: 60, weight: .medium))
                            
                            Spacer()
                        }
                    }
                }
                
                // Skip Add Button
                HStack {
                    Button("Skip") {
                        timerModel.skipTimer()
                    }
                    Button("+30s") {
                        timerModel.addExtraTime()
                    }
                }
                
                // StartPauseReset Button
                Button {
                    switch timerModel.timerState {
                    case .idle:
                        timerModel.startTimer()
                    case .run:
                        timerModel.pauseTimer()
                    case .pause:
                        timerModel.resumeTimer()
                    case .finish:
                        timerModel.skipTimer()
                    }
                } label: {
                    switch timerModel.timerState {
                    case .idle:
                        Text("Start")
                    case .run:
                        Text("Pause")
                    case .pause:
                        Text("Resume")
                    case .finish:
                        Text("Reset")
                    }
                }
                .frame(height: 44)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onReceive(Timer.publish(every: 1, on: .current, in: .common).autoconnect(), perform: { _ in
            if timerModel.timerState == .run {
                timerModel.updateTimer()
            }
        })
        .onAppear {
            timerModel.totalSeconds = totalTime
            timerModel.skipTimer()
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .inactive:
                print("inactive mode")
                
            case .active:
                print("active mode")
                
                if timerModel.timerState == .run {
                    let currentTimeStampDifference = Date().timeIntervalSince(latActiveTimeStamp)
                    print("stamp 2")
                    print(currentTimeStampDifference)
                    
                    if timerModel.leftSeconds - Int(currentTimeStampDifference) <= 0 {
                        timerModel.timerState = .finish
                        timerModel.leftSeconds = 0
                        
                        timerModel.skipTimer()
                    } else {
                        if timerModel.isScenePhaseFromBackground {
                            timerModel.leftSeconds -= Int(currentTimeStampDifference)
                            timerModel.isScenePhaseFromBackground = false
                        }
                        
                        timerModel.setNotification(for: timerModel.leftSeconds)
                    }
                }
                
            case .background:
                print("background mode")
                
                if !timerModel.isScenePhaseFromBackground {
                    print("stamp 1")
                    latActiveTimeStamp = Date()
                }
                
                timerModel.isScenePhaseFromBackground = true
                
            @unknown default:
                print("unknown mode")
            }
        }
    }
}
