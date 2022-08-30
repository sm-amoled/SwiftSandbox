//
//  ViewController.swift
//  ARSession
//
//  Created by Park Sungmin on 2022/08/30.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet private weak var sceneView: ARSCNView!
//    private var arConfiguration = ARWorldTrackingConfiguration()
    private var arConfiguration = ARFaceTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(arConfiguration)
        sceneView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
//        sun.position = SCNVector3(0, 0, -1)
//        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun-diffuse")
//        sceneView.scene.rootNode.addChildNode(sun)
//
//        let earth = SCNNode(geometry: SCNSphere(radius: 0.1))
//        earth.position = SCNVector3(1, 0, -1)
//        earth.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "earth-diffuse")
//        earth.geometry?.firstMaterial?.specular.contents = UIImage(named: "earth-specular")
//        earth.geometry?.firstMaterial?.normal.contents = UIImage(named: "earth-normal")
//        earth.geometry?.firstMaterial?.emission.contents = UIImage(named: "earth-emission")
////        sceneView.scene.rootNode.addChildNode(earth)
//
//        let earthParent = SCNNode()
//        earthParent.position = SCNVector3(1, 0, -1)
//
//        sceneView.scene.rootNode.addChildNode(earthParent)
//        earthParent.addChildNode(earth)
//
//        let moon = SCNNode(geometry: SCNSphere(radius: 0.05))
//        moon.position = SCNVector3(0.5, 0, 0)
//        moon.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "moon-diffuse")
//        earthParent.addChildNode(moon)
//
//        let sunAction = SCNAction.rotateBy(x: 0, y: 360.degree2Radians, z: 0, duration: 10)
//        let sunRepeatAction = SCNAction.repeatForever(sunAction)
//        sun.runAction(sunRepeatAction)
//
//        let earthAction = SCNAction.rotateBy(x: 0, y: 360.degree2Radians, z: 0, duration: 7)
//        let earthRepeatAction = SCNAction.repeatForever(earthAction)
//        earth.runAction(earthRepeatAction)
//
//        let earthParentAction = SCNAction.rotateBy(x: 0, y: 360.degree2Radians, z: 0, duration: 20)
//        let earthParentRepeatAction = SCNAction.repeatForever(earthParentAction)
//        earthParent.runAction(earthParentRepeatAction)
     
//        let moonAction = SCNAction.rotateBy(x: 0, y: 360.degree2Radians, z: 0, duration: 10)
//        let moonRepeatAction = SCNAction.repeatForever(moonAction)
//        earthParent.runAction(moonRepeatAction)
        
    }


}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else { return nil }
        let faceMesh = ARSCNFaceGeometry(device: device)
        let meshNode = SCNNode(geometry: faceMesh)
        
        meshNode.geometry?.firstMaterial?.fillMode = .fill
        
        return meshNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        faceGeometry.firstMaterial?.diffuse.contents = UIImage(named: "orange")
        faceGeometry.update(from: faceAnchor.geometry)
    }
}

extension Int {
    var degree2Radians: Double {
        return Double(self) * .pi / 180
    }
}
