//
//  ViewController.swift
//  3DEarth
//
//  Created by Park Sungmin on 2022/08/26.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let scene = SCNScene()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        
        scene.rootNode.addChildNode(cameraNode)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 2)
        
        scene.rootNode.addChildNode(lightNode)
        
//        let stars = SCNParticleSystem(named: "StarParticle", inDirectory: nil)!
//        scene.rootNode.addParticleSystem(stars)
        
        let particleSystem = SCNParticleSystem()
        particleSystem.birthRate = 100
        particleSystem.particleSize = 0.1
        particleSystem.particleLifeSpan = 5
        particleSystem.particleColor = .white
        particleSystem.speedFactor = 1
        particleSystem.emittingDirection = SCNVector3(1,1,1)
        particleSystem.emitterShape = .some(SCNSphere(radius: 50))

//        let particlesNode = SCNNode()
//        particlesNode.scale = SCNVector3(2,2,2)
//        particlesNode.addParticleSystem(particleSystem)
//
        scene.rootNode.addParticleSystem(particleSystem)
        
        
        let earthNode = EarthNode()
        scene.rootNode.addChildNode(earthNode)
        
        let sceneView = self.view as! SCNView

        
        sceneView.scene = scene
        
        sceneView.showsStatistics = true
        sceneView.backgroundColor = .black
        sceneView.allowsCameraControl = true

    }


}

