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
                if isLuminanceReduced {
                    TimelineView(.periodic(from: .now, by: 1)) { context in
                        Text("\(timerModel.timerLeftStringValue)")
                            .font(.system(size: 60, weight: .medium))
                        
                        Spacer()
                    }
                } else {
                    VStack(spacing: -5) {
                        Text("\(timerModel.timerTotalStringValue)")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        Text("\(timerModel.timerLeftStringValue)")
                            .font(.system(size: 50, weight: .medium))
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
                    
                    if timerModel.leftSeconds - Int(currentTimeStampDifference) <= 0 {
                        timerModel.timerState = .finish
                        timerModel.leftSeconds = 0
                        
                        timerModel.skipTimer()
                    } else {
//                        timerModel.leftSeconds -= Int(currentTimeStampDifference)
                    }
                }
                
            case .background:
                print("background mode")
                if timerModel.timerState == .run
                    && scenePhase == .inactive {
                    latActiveTimeStamp = Date()
                }
                
                
            @unknown default:
                print("unknown mode")
            }
        }
    }
}

func setOneTimeNotification(timeFor: Double) {
    let content = UNMutableNotificationContent()
    content.title = "쉬는 시간 완료!"
    content.subtitle = "다음 세트를 준비해주세요"
    content.sound = UNNotificationSound.default
    if timeFor <= 1 { return }
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeFor), repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}
