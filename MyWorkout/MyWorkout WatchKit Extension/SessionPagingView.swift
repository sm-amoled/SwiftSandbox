//
//  SessionPagingView.swift
//  MyWorkout WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/26.
//


import SwiftUI
import WatchKit

struct SessionPagingView: View {
    
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controls, metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)
        }
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}
