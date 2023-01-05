//
//  TimerModel.swift
//  backgroundTimer_Watch Watch App
//
//  Created by Park Sungmin on 2023/01/03.
//

import SwiftUI
import HealthKit
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
        
    @Published var isScenePhaseFromBackground: Bool = false
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    
    override init() {
        super.init()
        
        // 알림 권한 요청
        self.authorizeNotification()
        
        self.startWorkout()
    }
    
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
        }
        
        // 인앱 알림을 보여주기 위한 delegate 설정이 필요함
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Start the workout.
    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .functionalStrengthTraining
        configuration.locationType = .indoor
        
        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        } catch {
            // Handle any exceptions.
            return
        }

        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
            // The workout has started.
    }

    func resetWorkout() {
        session = nil
    }
    
    func startTimer() {
        
        timerTotalStringValue = "\(totalSeconds.convertToTimeFormat())"
        timerLeftStringValue = timerTotalStringValue
        
        leftSeconds = totalSeconds
        
        setNotification(for: leftSeconds)
        timerState = .run
    }
    
    func pauseTimer() {
        timerState = .pause
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func resumeTimer() {
        timerState = .run
        setNotification(for: leftSeconds)
    }
    
    func skipTimer() {
        timerTotalStringValue = "\(totalSeconds.convertToTimeFormat())"
        timerLeftStringValue = timerTotalStringValue
        
        leftSeconds = totalSeconds
        
        timerState = .idle
        
        isScenePhaseFromBackground = false
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
    
    func setNotification(for leftSeconds: Int) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["timeout_noti"])
        
        let content = UNMutableNotificationContent()
        content.title = "운동 타이머"
        content.subtitle = "쉬는시간 종료!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "timeout_noti", content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(leftSeconds), repeats: false))
        
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
