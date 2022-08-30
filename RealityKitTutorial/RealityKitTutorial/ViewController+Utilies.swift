//
//  ViewController+Utilies.swift
//  RealityKitTutorial
//
//  Created by Park Sungmin on 2022/08/29.
//

import UIKit
import ARKit

extension ViewController {
    
    func getCurrentLocation() -> (x: Float, y: Float, z: Float) {
        guard let direction = arView.session.currentFrame?.camera.transform.translation else { return (0, 0, 0) }
        return (direction.x, direction.y, direction.z)
    }
    
}
