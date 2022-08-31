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
        
        
    }
    
    private func startSession() {
        arConfiguration.planeDetection = [.horizontal]
        arConfiguration.environmentTexturing = .automatic
        
        sceneView.scene.physicsWorld.gravity = SCNVector3(x: 0, y: -1, z: 0)
        sceneView.session.run(arConfiguration)
        
        sceneView.delegate = self
        predictor.delegate = self
        fingerPointDetector.delegate = self
    }
    
    private func addParsley() {
        let direction = fetchForceDirection(at: sceneView.center)
        
        let parsley = SCNNode(geometry: SCNBox(width: 0.001, height: 0.0001, length: 0.003, chamferRadius: 0.05))
        parsley.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        parsley.position = SCNVector3(x: sceneView.session.currentFrame?.camera.transform.columns.3.x ?? 0 + direction!.x * 5 + 100,
                                      y: sceneView.session.currentFrame?.camera.transform.columns.3.y ?? 0 + direction!.y * 5 + 10,
                                      z: sceneView.session.currentFrame?.camera.transform.columns.3.z ?? 0 + direction!.z * 5 + 10)
        
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: parsley.geometry!))
        physicsBody.isAffectedByGravity = true
        
        parsley.physicsBody = physicsBody
        
//        parsley.physicsBody?.applyForce(SCNVector3(x: 0, y: -4, z: 0), asImpulse: false)
        sceneView.scene.rootNode.addChildNode(parsley)
    }
}

extension ViewController: PredictorDelegate {
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        if action == "parsley" {
            if isParsleyDetected == false {
                isParsleyDetected = true
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    AudioServicesPlayAlertSound(SystemSoundID(1300))
                    print("Parsley")
                    self.addParsley()
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
}

extension ViewController {
    func fetchForceDirection(at position: CGPoint) -> simd_float3? {
        guard let hitTestResult = sceneView.raycastQuery(from: position, allowing: .existingPlaneGeometry, alignment: .any) else { return nil }
        return hitTestResult.direction
    }
}
