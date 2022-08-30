//
//  ViewController+Node.swift
//  RealityKitTutorial
//
//  Created by Park Sungmin on 2022/08/29.
//

import UIKit
import ARKit

extension ViewController {
    func respawnNode(type: NodeType) -> SCNNode {
        let node = generateNode(type: type)
        setPosition(node, type: type)
//        sceneView.scene.rootNode.addChildNode(node)
        planeAnchor.addChild(node)
        return node
    }

    func generateNode(type: NodeType) -> SCNNode {
        let node = SCNNode()
        node.geometry = type.geometry
        
        node.geometry?.materials = [generateMaterial(type: type)]
        node.name = type.name
        setPhysicsBody(node, type: type)
        return node
    }
    
    func setPhysicsBody(_ node: SCNNode, type: NodeType) {
        let shape = SCNPhysicsShape(geometry: node.geometry!)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        physicsBody.isAffectedByGravity = true
        physicsBody.categoryBitMask = type.categoryBitMask
        physicsBody.contactTestBitMask = type.contactTestBitMask
        physicsBody.collisionBitMask = type.collisionBitMask
        node.physicsBody = physicsBody
    }
    
    func generateMaterial(type: NodeType) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = 1.0
        material.roughness.contents = 0.0
        
        material.diffuse.contents = type.materialContents
        return material
    }
    
    func setPosition(_ node: SCNNode, type: NodeType) {
        switch type {
        case .bullet, .player:
            let (x, y, z) = getCurrentLocation()
            node.position = SCNVector3(x, y, z)
//            node.position = SCNVector3.random(isNearby: true)
        case .enemy:
            node.position = SCNVector3.random(isNearby: false)
        case .lifeBox:
            node.position = SCNVector3.random(isNearby: true)
        }
    }
}
