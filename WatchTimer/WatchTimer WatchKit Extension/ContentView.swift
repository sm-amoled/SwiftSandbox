//
//  ContentView.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/12.
//

import SwiftUI

struct ContentView: View {
    @State var secondScreenShown = false
    @State var timerVal = 1
    
    @State var entireTime = WorkoutTime()
    @State var restTime = WorkoutTime(time: 30)
    
    @State var isRunning = false
    @State var isCleared = true
    
    
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
                        if isCleared {
                            isCleared = false
                            isRunning = true
                            
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: restTime.time > 0 && isRunning) { timer in
                                restTime.time -= 1
                                
                                if restTime.time == 0 {
                                    isRunning = false
                                }
                            }
                        }
                        // 타이머가 실행된 이후
                        else {
                            // 일시중지
                            if restTime.time > 0 && isRunning {
                                isRunning = false
                            }
                            // 다시 재생
                            else if restTime.time > 0 && !isRunning {
                                isRunning = true
                            }
                            // 시간이 모두 지난 이후
                            else if restTime.time == 0 {
                                restTime.time += 30
                                isRunning = true
                            }
                        }
                        
                    } label: {
                        // 초기 상태
                        if isCleared {
                            Text("시작")
                        }
                        // 타이머가 실행된 이후
                        else {
                            // 일시중지
                            if restTime.time > 0 && isRunning {
                                Text("일시정지")
                            }
                            // 다시 재생
                            else if restTime.time > 0 && !isRunning {
                                Text("재생")
                            }
                            // 시간이 모두 지난 이후
                            else if restTime.time == 0 {
                                Text("+30초")
                            }
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Text("건너뛰기")
                    }
                }
            }
            
            
            //            NavigationLink(destination: SecondView(secondScreenShown: $secondScreenShown,
            //                                                   timerVal: timerVal),
            //                           isActive: $secondScreenShown,
            //                           label: {Text("Go")})
        }
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
