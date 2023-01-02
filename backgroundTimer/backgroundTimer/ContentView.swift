//
//  ContentView.swift
//  backgroundTimer
//
//  Created by Park Sungmin on 2022/12/22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
            HomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomeView: View {
    
    @State var start = false
    @State var to: CGFloat = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var count: Int = 0
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
            
            
            
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 35, lineCap: .round, lineJoin: .round))
                        .frame(width: 280, height: 280)
                    
                    Circle()
                        .trim(from: 0, to: to)
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 35, lineCap: .round, lineJoin: .round))
                        .frame(width: 280, height: 280)
                        .rotationEffect(.init(degrees: -90))
                    
                    VStack(alignment: .center) {
                        Text("\(count)")
                            .font(.system(size: 65))
                            .fontWeight(.bold)
                        
                        Text("Of \(15)")
                            .font(.title)
                            
                    }
                }
                
                HStack(spacing: 20) {
                    Button {
                        if self.count == 15 {
                            self.count = 0
                            withAnimation {
                                self.to = 0
                            }
                        }
                        self.start.toggle()
                        
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: self.start ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                            Text(self.start ? "일시정지" : "시작")
                                .foregroundColor(.white)

                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .shadow(radius: 6)
                    }
                    
                    Button {
                        self.count = 0
                        withAnimation {
                            self.to = 0
                        }
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.red)
                            Text("Restart")
                                .foregroundColor(.red)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(
                            Capsule()
                                .stroke(Color.red, lineWidth: 2)
                        )
                        .shadow(radius: 6)
                    }
                }
                .padding(.top, 55)
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, _) in
                
            }
        }
        .onReceive(self.time) { (_) in
            if self.start {
                if self.count != 15 {
                    
                    self.count += 1
                    
                    withAnimation {
                        self.to = CGFloat(self.count) / 15
                    }
                } else {
                    notify()
                    
                    withAnimation {
                        self.to = 0
                    }
                    
                    self.start.toggle()
                }
            }
        }
    }
    
    func notify() {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.body = "Timer is completed"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
