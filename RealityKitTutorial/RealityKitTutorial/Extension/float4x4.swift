//
//  float4x4.swift
//  RealityKitTutorial
//
//  Created by Park Sungmin on 2022/08/29.
//

import simd

extension float4x4 {
    var translation: SIMD3<Float> {
        let translation = self.columns.3
        return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
}
