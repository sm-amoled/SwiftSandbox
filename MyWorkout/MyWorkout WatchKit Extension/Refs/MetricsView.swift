//
//  MetricsView.swift
//  MyWorkout WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/26.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date()
            )
        ) { context in
            VStack(alignment: .leading) {
                ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime ?? 0, showSubseconds: context.cadence == .live) // live 상태 (실시간으로 뷰가 계속 업데이트 되는 상태)일 때는 tic 보여주기
                    .foregroundColor(.yellow)
                
                Text(Measurement(value: workoutManager.activeEnergy,
                                 unit: UnitEnergy.kilocalories)
                    .formatted(.measurement(width: .abbreviated,
                                            usage: .workout,
                                            numberFormatStyle: .number.precision(.fractionLength(0)))))
                
                Text(workoutManager.heartRate
                    .formatted(.number.precision(.fractionLength(0))) + " bpm")
                
                Text(Measurement(value: workoutManager.distance, unit: UnitLength.meters)
                    .formatted(
                        .measurement(width: .abbreviated,
                                     usage: .road,
                                     numberFormatStyle: .number.precision(.fractionLength(0)))))
            }
        }
        .font(.system(.title, design: .rounded)
            .monospacedDigit()
            .lowercaseSmallCaps()
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea(edges: .bottom)
        .scenePadding()
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: Mode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule (
            from: self.startDate,
            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        ) // low frequency -> 1초에 한 번 / noral -> 1초에 30번
        .entries(from: startDate,
                 mode: mode
        )
    }
}
