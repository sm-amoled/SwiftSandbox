//
//  TimerModel.swift
//  backgroundTimer
//
//  Created by Park Sungmin on 2023/01/02.
//

import SwiftUI

class TimerModel: NSObject, ObservableObject {
    
    // MARK: Properties
    
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var minute: Int = 0
    @Published var second: Int = 0
    
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    @Published var isFinished: Bool = false
    
    
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
        withAnimation(.easeInOut(duration: 0.25)) { isStarted = true }
        
        // 타이머 프로퍼티 초기 설정
        timerStringValue = "\(hour == 0 ? "" : "\(hour):") \(minute >= 10 ? "\(minute)" : "0\(minute)"):\(second >= 10 ? "\(second)" : "0\(second)")"
        totalSeconds = hour * 3600 + minute * 60 + second
        staticTotalSeconds = totalSeconds
        
        addNewTimer = false
        
        addNotification()
    }
    
    func stopTimer() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isStarted = false
            
            hour = 0
            minute = 0
            second = 0
            
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        
        timerStringValue = "00:00"
    }
    
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        
        hour = totalSeconds / 3600
        minute = (totalSeconds / 60) % 60
        second = totalSeconds % 60

        timerStringValue = "\(hour == 0 ? "" : "\(hour):") \(minute >= 10 ? "\(minute)" : "0\(minute)"):\(second >= 10 ? "\(second)" : "0\(second)")"

        if hour == 0 && second == 0 && minute == 0 {
            isStarted = false
            print("finished")
            isFinished = true
        }
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.subtitle = "타이머 종료!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
}

extension TimerModel: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
}
