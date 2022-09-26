//
//  MyWorkoutApp.swift
//  MyWorkout WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/26.
//

import SwiftUI

@main
struct MyWorkoutApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
