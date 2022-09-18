//
//  ContentView.swift
//  WatchTimer
//
//  Created by Park Sungmin on 2022/09/12.
//

import SwiftUI

struct ContentView: View {
    @State var count1: Int = 20
    @State var count2: Int = 5
    @State var navigationBool = true
    
    @State var isRunning: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text("\(count1)")
                    .onAppear {
                        startTimer()
                    }
                
                NavigationLink(destination: NextView(shownBool: $navigationBool),
                               isActive: $navigationBool,
                               label: {Text("Go")})
            }
        }
    }
    
    func startTimer() {
        if !isRunning {
            isRunning = true
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: count1 > 0) { _ in
                if count1 > 0 {
                    count1 -= 1
                }
            }
        }
    }
}

struct NextView: View {
    @State var count2: Int = 5
    @Binding var shownBool: Bool
    
    @State var isRunning: Bool = false
    
    var body: some View {
        VStack {
            if count2 > 0 {
                Text("\(count2)")
                    .onAppear {
                        startTimer()
                    }
            } else {
                Button {
                    shownBool.toggle()
                } label: {
                    Text("Back")
                }
            }
            
        }
    }
    
    func startTimer() {
        if !isRunning {
            isRunning = true
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: count2 > 0) { _ in
                if count2 > 0 {
                    count2 -= 1
                }
            }
        }
    }
}
