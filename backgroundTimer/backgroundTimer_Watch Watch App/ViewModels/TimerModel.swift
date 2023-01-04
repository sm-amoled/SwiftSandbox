//
//  TimerModel.swift
//  backgroundTimer_Watch Watch App
//
//  Created by Park Sungmin on 2023/01/03.
//

import SwiftUI
import UserNotifications

class TimerModel: NSObject, ObservableObject {
    
    // MARK: Properties
    
    @Published var timerLeftStringValue: String = "00:00"
    @Published var timerTotalStringValue: String = "00:00"
    
    @Published var minute: Int = 0
    @Published var second: Int = 0
    
    @Published var leftSeconds: Int = 0
    @Published var totalSeconds: Int = 0
    
    @Published var timerState: TimerState = .idle
    
    override init() {
        super.init()
        
        // 알림 권한 요청
        self.authorizeNotification()
    }
    
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
        }
        
        // 인앱 알림을 보여주기 위한 delegate 설정이 필요함
        UNUserNotificationCenter.current().delegate = self
    }
    
    func startTimer() {
        timerTotalStringValue = "\(totalSeconds.convertToTimeFormat())"
        timerLeftStringValue = timerTotalStringValue
        
        leftSeconds = totalSeconds
        
        addNotification()
        timerState = .run
    }
    
    func pauseTimer() {
        timerState = .pause
    }
    
    func resumeTimer() {
        timerState = .run
    }
    
    func skipTimer() {
        timerTotalStringValue = "\(totalSeconds.convertToTimeFormat())"
        timerLeftStringValue = timerTotalStringValue
        
        leftSeconds = totalSeconds
        
        timerState = .idle
    }
    
    func updateTimer() {
        leftSeconds -= 1
        timerLeftStringValue = "\(leftSeconds.convertToTimeFormat())"

        if leftSeconds == 0 {
            timerState = .finish
        }
    }
    
    func addExtraTime() {
        leftSeconds += 30
        
        timerLeftStringValue = "\(leftSeconds.convertToTimeFormat())"
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "운동 타이머"
        content.subtitle = "쉬는시간 종료!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(leftSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
}

extension TimerModel: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
}

enum TimerState {
    case idle, run, pause, finish
}
