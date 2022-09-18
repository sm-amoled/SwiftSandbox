//
//  SecondView.swift
//  WatchTimer WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/13.
//

import SwiftUI

struct SecondView: View {
    @Binding var secondScreenShown: Bool
    @State var timerVal: Int
    
    @State var thirdScreenShown = false
    @State var secondTimerVal: Int = 1
    
    
    var body: some View {
        VStack {
            if timerVal > 0 {
                Text("\(timerVal) seconds left")
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: self.timerVal > 0) { timer in
                            if self.timerVal > 0 {
                                self.timerVal -= 1
                            }
                        }
                    }
                
                Picker(selection: $secondTimerVal) {
                    Text("1").tag(1)
                    Text("2").tag(2)
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("20").tag(20)
                } label: {
                    Text("Second Picker")
                }
                
                NavigationLink(destination: ThirdView(thirdScreenShown: $thirdScreenShown,
                                                      timerVal: secondTimerVal),
                               isActive: $thirdScreenShown,
                               label: {Text("Go")})
            } else {
                Button {
                    self.secondScreenShown = false
                } label: {
                    Text("Done")
                }
            }
        }
    }
}

struct ThirdView: View {
    @Binding var thirdScreenShown: Bool
    @State var timerVal: Int
    
    var timer: Timer?
    
    var body: some View {
        if timerVal > 0 {
            VStack {
                Text("Time Remaining")
                    .font(.system(size: 14))
                Text("\(timerVal)")
                    .font(.system(size: 40))
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: self.timerVal > 0) { timer in
                            if self.timerVal > 0 {
                                self.timerVal -= 1
                            } else {
                                timer.invalidate()
                            }
                        }
                    }
                Text("seconds")
                    .font(.system(size: 14))
                
                Button {
                    self.thirdScreenShown = false
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
            }
        } else {
            Button {
                self.thirdScreenShown = false
            } label: {
                Text("Done")
            }
        }
    }
}
