//
//  ControlsView.swift
//  MyWorkout WatchKit Extension
//
//  Created by Park Sungmin on 2022/09/26.
//

import SwiftUI

struct ControlsView: View {
    
    
    var body: some View {
        HStack {
            VStack {
                Button {
                    // action
                    
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(Color.red)
                .font(.title2)
                Text("End")
            }
            
            VStack {
                Button {
                    // action
                    
                } label: {
                    Image(systemName: "pause")
                }
                .tint(Color.yellow)
                .font(.title2)
                Text("Pause")
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}
