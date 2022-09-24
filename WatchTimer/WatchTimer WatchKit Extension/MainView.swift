//
//  MainView.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/20.
//

import SwiftUI

struct MainView: View {
    @State var timerIsShown = false
    @ObservedObject var totalTimer = TotalTimer()
    let workoutManager = WorkoutManager()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("총 운동 시간")
                .font(.system(size: 24))
            Text(totalTimer.entireTime.timeToString())
                .font(.system(size: 40))
            
            HStack {
                if totalTimer.timerState == .idle {
                    Button {
                        timerIsShown = true
                        totalTimer.startTimer()
                        workoutManager.selectedWorkout = .functionalStrengthTraining
                    } label: {
                        Text("시작")
                    }
                } else {
                    Button {
                        switch totalTimer.timerState {
                        case .isRunning:
                            totalTimer.pauseTimer()
                            workoutManager.pause()
                        case .pause:
                            totalTimer.resumeTimer()
                            workoutManager.resume()
                        default:
                            totalTimer.stopTimer()
                            totalTimer.entireTime.time = 0
                            workoutManager.endWorkout()
                        }
                    } label: {
                        switch totalTimer.timerState {
                        case .isRunning:
                            Text("일시정지")
                        case .pause:
                            Text("다시시작")
                        default:
                            Text("종료")
                        }
                    }
                    Button {
                        timerIsShown = false
                        totalTimer.stopTimer()
                    } label: {
                        Text("종료")
                    }
                }
            }
            .onAppear {
                print("request")
                workoutManager.requestAuthorization()
            }
            
            NavigationLink(destination: TimerView()
                                            .environmentObject(totalTimer),
                           isActive: $timerIsShown) {
                Text("오늘의 운동")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
