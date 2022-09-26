//
//  StartView.swift
//  MyWorkout WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/26.
//

import SwiftUI
import HealthKit

struct StartView: View {
    
    var workoutTypes: [HKWorkoutActivityType] = [.cycling, .running, .walking]
    
    var body: some View {
        List(workoutTypes) { workoutType in
            NavigationLink(workoutType.name, destination: Text(workoutType.name))
                .padding(
                    EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5)
                )
        }
        .listStyle(.carousel)
        .navigationTitle("My Workout")
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}


extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .running:
            return "Run"
        case .cycling:
            return "Bike"
        case .walking:
            return "Walk"
        default:
            return "NONE"
        }
    }
}
