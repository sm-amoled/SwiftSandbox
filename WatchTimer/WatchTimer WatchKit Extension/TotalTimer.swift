//
//  TotalTimer.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/20.
//

import Foundation
import SwiftUI

class TotalTimer: ObservableObject {
    
    @Published var timerVal = 1
    @Published var entireTime = WorkoutTime()
    @Published var timerState: TimerState = .idle
    
    @Published var timer: DispatchSourceTimer?
    
    func startTimer() {
        timerState = .isRunning
        
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)

            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: {
                
                self.entireTime.time += 1
            })
            self.timer?.resume()
        }
    }
    
    func pauseTimer() {
        timerState = .pause
        
        timer?.suspend()
    }
    
    func resumeTimer() {
        timerState = .isRunning
        
        timer?.resume()
    }
    
    func stopTimer() {
        timerState = .idle
        
        timer?.cancel()
        self.timer = nil
    }
}
