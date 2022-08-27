//
//  ViewController.swift
//  ARStudy
//
//  Created by Park Sungmin on 2022/08/26.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planeGeomery: SCNPlane!
    let planeIdentifiers = [UUID]()
    var anchors = [ARAnchor]()
    var sceneLight: SCNLight!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        /// 임의로 설정해준 sceneLight를 사용하기 위해 default light를 꺼준다.
        sceneView.autoenablesDefaultLighting = false
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        let lightNode = SCNNode()
        lightNode.light = sceneLight
        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
        
        sceneView.scene.rootNode.addChildNode(lightNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: sceneView)
        
        addNodeAtLocation(location: location!)
        
//        let hitResults = sceneView.hitTest(location!, types: .featurePoint)
//
//        if let hitTestResults = hitResults.first {
//            let transform = hitTestResults.worldTransform
//            let position = SCNVector3(x: transform.columns.3.x, y: transform.columns.3.y, z: transform.columns.3.z)
//
//            let newEarth = EarthNode()
//            newEarth.position = position
//
//            sceneView.scene.rootNode.addChildNode(newEarth)
//        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // 빛의 양을 추측해서 AR의 빛의 강도를 결정함
        if let estimate = self.sceneView.session.currentFrame?.lightEstimate {
            sceneLight.intensity = estimate.ambientIntensity
        }
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node: SCNNode?
     
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node = SCNNode()
            planeGeomery = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            planeGeomery.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            
            let planeNode = SCNNode(geometry: planeGeomery)
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            updateMaterial()
            
            node?.addChildNode(planeNode)
            anchors.append(planeAnchor)
        }
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if anchors.contains(planeAnchor) {
                if node.childNodes.count > 0 {
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
                    
                    if let plane = planeNode.geometry as? SCNPlane {
                        plane.width = CGFloat(planeAnchor.extent.x)
                        plane.height = CGFloat(planeAnchor.extent.z)
                        
                    }
                }
            }
        }
    }
    
    func updateMaterial() {
        let material = self.planeGeomery.materials.first!
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.planeGeomery.width), Float(self.planeGeomery.height), 1)
    }
    
    func addNodeAtLocation(location: CGPoint) {
        guard anchors.count > 0 else { print("아직 Anchor가 만들어지지 않았음"); return }
        
        let hitResults = sceneView.hitTest(location, types: .existingPlane)
        
        if hitResults.count > 0 {
            let result = hitResults.first!
            let newLocation = SCNVector3(x: result.worldTransform.columns.3.x, y: result.worldTransform.columns.3.y + 0.15, z: result.worldTransform.columns.3.z)
            
            let earthNode = EarthNode()
            earthNode.position = newLocation
            
            sceneView.scene.rootNode.addChildNode(earthNode)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
