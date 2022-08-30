//
//  NodeType.swift
//  RealityKitTutorial
//
//  Created by Park Sungmin on 2022/08/29.
//

import UIKit
import SceneKit

enum NodeType {
    case bullet
    case enemy
    case lifeBox
    case player
    
    var name: String {
        switch self {
        case .bullet: return "bullet"
        case .enemy: return "enemy"
        case .lifeBox: return "lifeBox"
        case .player: return "player"
        }
    }
    
    var categoryBitMask: Int {
        switch self {
        case .bullet: return 0x1
        case .enemy: return 0x2
        case .lifeBox: return 0x4
        case .player: return 0x8
        }
    }
    
    var contactTestBitMask: Int {
        switch self {
        case .bullet: return 0x2
        case .enemy: return 0x1 | 0x8
        case .lifeBox: return 0x8
        case .player: return 0x2 | 0x4
        }
    }
    
    var collisionBitMask: Int {
        switch self {
        case .bullet: return 0x2 | 0x4
        case .enemy: return 0x1 | 0x4 | 0x8
        case .lifeBox: return 0x1 | 0x2 | 0x8
        case .player: return 0x2 | 0x4
        }
    }
    
    var geometry: SCNGeometry {
        switch self {
        case .bullet: return SCNSphere(radius: 0.15)
        case .enemy:
            return SCNTube(
                innerRadius: 0.02,
                outerRadius: 0.05,
                height: 0.2)
        case .lifeBox:
            return SCNBox(
                width: 0.4,
                height: 0.4,
                length: 0.4,
                chamferRadius: 0.04)
        case .player:
            return SCNTube(
                innerRadius: 0,
                outerRadius: 0.25,
                height: 1.8)
        }
    }
    
    var materialContents: UIColor {
        switch self {
        case .bullet:
            return UIColor(
                red: 0.95,
                green: 0.75,
                blue: 0.2,
                alpha: 1.0)
        case .enemy:
            return .random ?? .orange
        case .lifeBox:
            return .cyan
        case .player:
            return .clear
        }
    }
}
