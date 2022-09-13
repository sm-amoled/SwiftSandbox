//
//  ViewController.swift
//  HandAction
//
//  Created by Park Sungmin on 2022/08/30.
//

import UIKit
import SceneKit
import ARKit
import Vision
import AVFoundation
import AudioToolbox


class ViewController: UIViewController {
    
    @IBOutlet private weak var sceneView: ARSCNView!
    private var arConfiguration = ARWorldTrackingConfiguration()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    //    var videoCapture = VideoCapture()
    
    let predictor = Predictor()
    let fingerPointDetector = FingerPointDetector()
    var pointsLayer = CAShapeLayer()
    var isParsleyDetected = false
    
    
    override func viewDidLoad() {
        startSession()
        
        self.sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    private func startSession() {
        arConfiguration.planeDetection = [.horizontal]
        arConfiguration.environmentTexturing = .automatic
        
        sceneView.scene.physicsWorld.gravity = SCNVector3(x: 0, y: -0.3, z: 0)
        sceneView.session.run(arConfiguration)
        
        sceneView.delegate = self
        predictor.delegate = self
        fingerPointDetector.delegate = self
    }
}

extension ViewController: PredictorDelegate {
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        if action == "parsley" {
            if isParsleyDetected == false {
                isParsleyDetected = true
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    AudioServicesPlaySystemSound(4095)
                    let parsley = self.createParsley()


                    
                    let query: ARRaycastQuery = self.sceneView.raycastQuery(from: predictor.indexFingerTipPosition!,
                                                        allowing: .estimatedPlane,
                                                        alignment: .any)!
                    let results = self.sceneView.session.raycast(query)


                    if let firstResult = results.first {
//                        print("Parsley")
//                        let worldPos = simd_make_float3(firstResult.worldTransform.columns.3)
                        let worldPos = firstResult.worldTransform
                        print("x-\(worldPos.columns.3.x) y-\(worldPos.columns.3.y) z-\(worldPos.columns.3.z)")
                        //                        self.sceneView.scene.rootNode.addChildNode(parsley)
                        self.placeObject(object: parsley, at: worldPos)
//                        parsley.worldPosition = SCNVector3(worldPos.columns.3.x, worldPos.columns.3.y, worldPos.columns.3.z)
                    }
                    
                    self.isParsleyDetected = false
                })
            }
        } else {
//            print("none")
        }
    }
    
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoints points: [CGPoint]) {
        guard let previewLayer = previewLayer else { return }
        
        let convertedPoints = points.map {
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        let combinedPath = CGMutablePath()
        
        for point in convertedPoints {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }
        
        pointsLayer.path = combinedPath
        
        DispatchQueue.main.async {
            self.pointsLayer.didChangeValue(for: \.path)
        }
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let pixelBuffer = sceneView.session.currentFrame?.capturedImage else { return }
        
        predictor.estimation(pixelBuffer: pixelBuffer)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update only anchors and nodes set up by `renderer(_:didAdd:for:)`.
            guard let planeAnchor = anchor as? ARPlaneAnchor,
                let plane = node.childNodes.first as? Plane
                else { return }
            
            // Update ARSCNPlaneGeometry to the anchor's new estimated shape.
            if let planeGeometry = plane.meshNode.geometry as? ARSCNPlaneGeometry {
                planeGeometry.update(from: planeAnchor.geometry)
            }

            // Update extent visualization to the anchor's new bounding rectangle.
            if let extentGeometry = plane.extentNode.geometry as? SCNPlane {
                extentGeometry.width = CGFloat(planeAnchor.extent.x)
                extentGeometry.height = CGFloat(planeAnchor.extent.z)
                plane.extentNode.simdPosition = planeAnchor.center
            }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // Create a custom object to visualize the plane geometry and extent.
        
            let plane = Plane(anchor: planeAnchor, in: sceneView)
            
            // Add the visualization to the ARKit-managed node so that it tracks
            // changes in the plane anchor as plane estimation continues.
            node.addChildNode(plane)
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        if anchor.name == "parsleyAnchor" {
//            print("x - \(anchor.transform.columns.3.x) / y - \(anchor.transform.columns.3.y) / z - \(anchor.transform.columns.3.z)")
//            node.position = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
//        }
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        if anchor.name == "parsleyAnchor" {
//            print("x - \(anchor.transform.columns.3.x) / y - \(anchor.transform.columns.3.y) / z - \(anchor.transform.columns.3.z)")
//            node.position = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
//        }
//    }
}

extension ViewController {
    func fetchForceDirection(at position: CGPoint) -> simd_float3? {
        guard let hitTestResult = sceneView.raycastQuery(from: position, allowing: .existingPlaneGeometry, alignment: .any) else { return nil }
        return hitTestResult.direction
    }
    
    func createParsley() -> SCNNode {
        let parsley = SCNNode(geometry: SCNBox(width: 0.05, height: 0.02, length: 0.10, chamferRadius: 0.05))
        parsley.geometry?.firstMaterial?.diffuse.contents = UIColor.green
//        parsley.position = SCNVector3(x: sceneView.session.currentFrame?.camera.transform.columns.3.x ?? 0 + direction!.x * 5 + 100,
//                                      y: sceneView.session.currentFrame?.camera.transform.columns.3.y ?? 0 + direction!.y * 5 + 10,
//                                      z: sceneView.session.currentFrame?.camera.transform.columns.3.z ?? 0 + direction!.z * 5 + 10)
        
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: parsley.geometry!))
        physicsBody.isAffectedByGravity = true
        physicsBody.categoryBitMask = BodyType.parsley.rawValue
        physicsBody.contactTestBitMask = BodyType.parsley.rawValue
        parsley.physicsBody = physicsBody
        
//        parsley.physicsBody?.applyForce(SCNVector3(x: 1, y: 0, z: 0), asImpulse: true)
//        sceneView.scene.rootNode.addChildNode(parsley)
        
        return parsley
    }
    
    func placeObject(object: SCNNode, at location: simd_float4x4) {
        // Anchor
//        let objectAnchor = ARAnchor(name: "parsleyAnchor", transform: location)
//        sceneView.session.add(anchor: objectAnchor)
//        object.position = SCNVector3(objectAnchor.transform.columns.3.x, objectAnchor.transform.columns.3.y, objectAnchor.transform.columns.3.z)
        
//        object.worldPosition = SCNVector3(location.columns.3.x, location.columns.3.y, location.columns.3.z)
        object.position = SCNVector3(location.columns.3.x, location.columns.3.y, location.columns.3.z)
//        print(SCNVector3(location.columns.3.x, location.columns.3.y, location.columns.3.z))
        sceneView.scene.rootNode.addChildNode(object)
    }
    
}

extension ViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
            // Collision happened between contact.nodeA and contact.nodeB
        print("pop")
        
        }
}
