//
//  ContentView.swift
//  backgroundTimer
//
//  Created by Park Sungmin on 2022/12/22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @EnvironmentObject var timerModel: TimerModel
    
    var body: some View {
            Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
