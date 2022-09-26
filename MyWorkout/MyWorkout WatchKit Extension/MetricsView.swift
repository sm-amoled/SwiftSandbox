//
//  MetricsView.swift
//  MyWorkout WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/26.
//

import SwiftUI

struct MetricsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ElapsedTimeView()
                .foregroundColor(.yellow)
            
            Text(Measurement(value: 153.35,
                             unit: UnitEnergy.kilocalories)
                .formatted(.measurement(width: .abbreviated,
                                        usage: .workout,
                                        numberFormatStyle: .number.precision(.fractionLength(0)))))
                
            Text(100
                .formatted(.number.precision(.fractionLength(0))) + " bpm")
            
            Text(Measurement(value: 515, unit: UnitLength.meters)
                .formatted(
                    .measurement(width: .abbreviated,
                                 usage: .road,
                                 numberFormatStyle: .number.precision(.fractionLength(0)))))
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
