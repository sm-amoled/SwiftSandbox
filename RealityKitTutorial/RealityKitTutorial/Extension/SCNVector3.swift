//
//  SCNVector3.swift
//  RealityKitTutorial
//
//  Created by Park Sungmin on 2022/08/29.
//

import SceneKit

extension SCNVector3 {
    static func random(isNearby: Bool) -> SCNVector3 {
        var randomXDistance: Float = 0
        var randomZDistance: Float = 0
        var xSpacer: Float = 0
        var zSpacer: Float = 0
        let sign = Float(Bool.random() ? 1 : -1)
        if isNearby {
            randomXDistance = Float.random(in: 0.1...1) * 5
            randomZDistance = Float.random(in: 0.1...1) * 5
        } else {
            randomXDistance = Float.random(in: 0.01...1) * 30
            randomZDistance = Float.random(in: 0.01...1) * 30
        }
        xSpacer = randomXDistance * sign
        zSpacer = randomZDistance * sign
        return SCNVector3(xSpacer, 0, zSpacer)
    }
}
