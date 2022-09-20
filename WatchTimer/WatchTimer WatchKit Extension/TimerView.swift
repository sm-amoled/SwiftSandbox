//
//  TimerView.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/19.
//

import Foundation
import SwiftUI

struct TimerView: View {
    @StateObject var viewModel = TimerViewModel()
    
    var body: some View {
        VStack {
//            Text("총 시간 \(viewModel.entireTime.timeToString())")
            TotalTimerView()
            
            Spacer()
            
            Text("다음 운동 정보")
                .border(.blue)
            
            Spacer()
            VStack {
                Text("쉬는시간")
                    .font(.system(size: 20))
                
                Text(viewModel.restTime.timeToString())
                    .font(.system(size: 32))
                
                HStack {
                    Button {
                        // 초기 상태
                        switch viewModel.timerState {
                        case .idle:
                            viewModel.startTimer()
                            
                            // 타이머 재생 중
                        case .isRunning:
                            viewModel.pauseTimer()
                            
                            // 타이머 일시정지
                        case .pause:
                            viewModel.resumeTimer()
                            
                            // 타이머 시간이 전부 지나감
                        case .stop:
                            viewModel.extendTimer()
                        }
                        
                        
                    } label: {
                        // 초기 상태
                        switch viewModel.timerState {
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
                        viewModel.nextTimer()
                    } label: {
                        switch viewModel.timerState {
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
}
