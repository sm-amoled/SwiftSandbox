//
//  ContentView.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/12.
//  https://velog.io/@tony1803/iOS-뽀모도로-타이머-앱-만들기

import SwiftUI

struct ContentView: View {
    @State var secondScreenShown = false
    @State var timerVal = 1
    
    @State var entireTime = WorkoutTime()
    @State var restTime = WorkoutTime(time: 5)
    
    @State var timerState: TimerState = .idle
    
    @State var timer: DispatchSourceTimer? = nil
    
    var body: some View {
        VStack {
            Text("총 시간 \(entireTime.timeToString())")
            
            Spacer()
            
            Text("다음 운동 정보")
                .border(.blue)
            
            Spacer()
            VStack {
                Text("쉬는시간")
                    .font(.system(size: 20))
                
                Text(restTime.timeToString())
                    .font(.system(size: 32))
                
                HStack {
                    Button {
                        
                        // 초기 상태
                        switch timerState {
                        case .idle:
                            timerState = .isRunning
                            startTimer()
                            
                            // 타이머 재생 중
                        case .isRunning:
                            timerState = .pause
                            pauseTimer()
                            
                            // 타이머 일시정지
                        case .pause:
                            timerState = .isRunning
                            resumeTimer()
                            
                            // 타이머 시간이 전부 지나감
                        case .stop:
                            restTime.time += 30
                            timerState = .isRunning
                            startTimer()
                        }
                        
                        
                    } label: {
                        // 초기 상태
                        switch timerState {
                        case .idle:
                            Text("시작")
                            
                            // 타이머 재생 중
                        case .isRunning:
                            Text("일시정지")
                            
                            // 타이머 일시정지
                        case .pause:
                            Text("계속")
                            
                            // 타이머 시간이 전부 지나감
                        case .stop:
                            Text("30초 추가")
                        }
                    }
                    
                    Button {
                        nextTimer()   
                    } label: {
                        switch timerState {
                        case .stop:
                            Text("넘어가기")
                            
                        default:
                            Text("건너뛰기")
                        }
                        
                    }
                }
            }
        }
    }
    
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: {
                restTime.time -= 1
                
                if restTime.time == 0 {
                    timerState = .stop
                    
                    timer?.cancel()
                    self.timer = nil
                }
            })
            self.timer?.resume()
        }
    }
    
    func pauseTimer() {
        timer?.suspend()
    }
    
    func resumeTimer() {
        timer?.resume()
    }
    
    func nextTimer() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WorkoutTime {
    var time: Int = 0
    
    func timeToString() -> String {
        let minute = time / 60
        let second = time % 60
        
        return String(format: "%02d:%02d", minute, second)
    }
    
}
