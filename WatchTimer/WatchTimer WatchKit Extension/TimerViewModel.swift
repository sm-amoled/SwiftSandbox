//
//  TimerViewModel.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/19.
//

import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var timerVal = 1
    
    @State var entireTime = WorkoutTime()
    @Published var restTime = WorkoutTime(time: 5)
    
    @Published var timerState: TimerState = .idle
    
    @Published var timer: DispatchSourceTimer?
    
    func startTimer() {
        timerState = .isRunning
        
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)

            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: {
                
                self.restTime.time -= 1
                
                if self.restTime.time == 0 {
                        self.timerState = .stop
                        
                        self.timer?.cancel()
                        self.timer = nil
                }
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
    
    func nextTimer() {
        timerState = .idle
        
        DispatchQueue.main.async {
            self.timer?.cancel()
            self.timer?.resume()
            self.timer = nil
        }
        
        restTime.time = 5
    }
    
    func extendTimer() {
        restTime.time += 30
        startTimer()
    }
}
