//
//  Home.swift
//  backgroundTimer
//
//  Created by Park Sungmin on 2023/01/02.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var timerModel: TimerModel
    
    var body: some View {
        VStack {
            Text("My Own Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            GeometryReader { proxy in
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-40)
                        
                        Circle()
                            .trim(from: 0, to: timerModel.progress)
                            .stroke(.white.opacity(0.03), lineWidth: 80)
                            
                        
                        // 그림자 효과
                        Circle()
                            .stroke(Color(.systemPurple).opacity(0.7), lineWidth: 5)
                            .blur(radius: 15)
                            .padding(-2)
                        
                        // 배경
                        Circle()
                            .fill(Color(.systemGray5))
                        
                        Circle()
                            .trim(from: 0, to: timerModel.progress)
                            .stroke(Color(.systemPurple).opacity(0.7), lineWidth: 10)
                        
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color(.systemPurple))
                                .frame(width: 30, height: 30)
                                .overlay(content: {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                })
                                .frame(width: size.width,
                                       height: size.height,
                                       alignment: .center)
                            // View가 Rotate 되었으므로, X와 Y를 반대로 사용함
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: timerModel.progress * 360))
                        }
                        
                        Text(timerModel.timerStringValue)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: timerModel.progress)
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: timerModel.progress)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Button {
                        if timerModel.isStarted {
                            timerModel.stopTimer()
                            
                            // 타이머 취소 시 알림 삭제
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        } else {
                            timerModel.addNewTimer = true
                        }
                    } label: {
                        Image(systemName: !timerModel.isStarted ? "timer" : "stop.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background {
                                Circle()
                                    .fill(Color(.systemPurple))
                                    .shadow(color: Color(.systemPurple), radius: 8)
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .background {
            Color(.systemGray5)
                .ignoresSafeArea()
        }
        .overlay {
            ZStack {
                Color.black
                    .opacity(timerModel.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        timerModel.hour = 0
                        timerModel.minute = 0
                        timerModel.second = 0
                        
                        timerModel.addNewTimer = false
                    }
                
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: timerModel.addNewTimer ? 0 : 400)
            }
            .animation(.easeInOut, value: timerModel.addNewTimer)
        }
        .onReceive(Timer.publish(every: 1, on: .current, in: .common).autoconnect(), perform: { _ in
            if timerModel.isStarted {
                timerModel.updateTimer()
            }
        })
        .alert("타이머 완료!", isPresented: $timerModel.isFinished, actions: {
            Button("새로운 타이머 맞추기", role: .cancel) {
                timerModel.stopTimer()
                timerModel.addNewTimer = true
            }
            Button("종료", role: .destructive) {
                timerModel.stopTimer()
            }
        })
        .preferredColorScheme(.dark)
    }
    
    // MARK: 하단 타이머 시트
    
    @ViewBuilder
    func NewTimerView()->some View {
        VStack(spacing: 15) {
            Text("Add N Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            
            HStack(spacing: 15) {
                Text("\(timerModel.hour) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 12, hint: "hr") { value in
                            timerModel.hour = value
                        }
                    }
                
                Text("\(timerModel.minute) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "min") { value in
                            timerModel.minute = value
                        }
                    }
                
                Text("\(timerModel.second) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "sec") { value in
                            timerModel.second = value
                        }
                    }
            }
            .padding(.top, 20)
            
            Button {
                timerModel.startTimer()
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(Color(.systemPurple))
                    }
            }
            .disabled(timerModel.second == 0)
            .opacity(timerModel.second == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.systemGray5))
                .ignoresSafeArea()
        }
    }
    
    // MARK: Context Menu 옵션
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping(Int)->()) -> some View {
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value )
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimerModel())
    }
}
