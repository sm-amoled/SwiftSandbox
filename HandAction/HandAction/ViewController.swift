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


class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet private weak var sceneView: ARSCNView!
    private var arConfiguration = ARWorldTrackingConfiguration()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var videoCapture = VideoCapture()
    
    var pointsLayer = CAShapeLayer()
    var isParsleyDetected = false
    
    
    override func viewDidLoad() {
        setupVideoPreview()
        videoCapture.predictor.delegate = self
        
//        sceneView.session.run(arConfiguration)
        sceneView.delegate = self
        
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        sun.position = SCNVector3(0, 0, -1)
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun-diffuse")
        sceneView.scene.rootNode.addChildNode(sun)
    }
    
    private func setupVideoPreview() {
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        
        guard let previewLayer = previewLayer else {
            return
        }
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame

        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.green.cgColor
    }
}

extension ViewController: PredictorDelegate {
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        if action == "parsley" {
            isParsleyDetected = true
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                self.isParsleyDetected = false
            })
            
            DispatchQueue.main.async {
                AudioServicesPlayAlertSound(SystemSoundID(1300))
                print("Parsley")
            }
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
