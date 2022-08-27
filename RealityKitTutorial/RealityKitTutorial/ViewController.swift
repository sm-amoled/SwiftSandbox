//
//  ViewController.swift
//  RealityKitTutorial
//
//  Created by Park Sungmin on 2022/08/27.
//

import UIKit
import RealityKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // m 단위 ... minimum bound는 20cmX20cm
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
        arView.scene.addAnchor(anchor)
        
        var cards: [Entity] = []
        for _ in 1...8 {
            
            // 형태와 질감을 결정해서 Model Entity를 생성하기 (?)
            let box = MeshResource.generateBox(width: 0.04, height: 0.002, depth: 0.04)
            let metalMaterial = SimpleMaterial(color: .gray, isMetallic: true)
            
            let model = ModelEntity(mesh: box, materials: [metalMaterial])
            model.name = "GameCard"
            model.generateCollisionShapes(recursive: true)
            
            cards.append(model)
        }
        
        for (index, card) in cards.enumerated() {
            let x = Float(index % 4)
            let z = Float(index / 4)
            
            card.position = SIMD3(x: x*0.1, y: 0, z: z*0.1)
            //            card.position = [x*0.1, 0, z*0.1]
            anchor.addChild(card)
            
            let boxSize: Float = 0.7
            let occlusionBoxMesh = MeshResource.generateBox(size: boxSize)
            let occlusionBox = ModelEntity(mesh: occlusionBoxMesh,
                                           materials: [OcclusionMaterial()])
            
            occlusionBox.position.y = -boxSize/2
            
            anchor.addChild(occlusionBox)
            
            var cancellable: AnyCancellable? = nil
            cancellable = ModelEntity.loadModelAsync(named: "01")
                .append(ModelEntity.loadModelAsync(named: "02"))
                .append(ModelEntity.loadModelAsync(named: "03"))
                .append(ModelEntity.loadModelAsync(named: "04"))
                .collect()
                .sink(receiveCompletion: { error in
                    print("Error: \(error)")
                    cancellable?.cancel()
                }, receiveValue: { entities in
                    var objects: [ModelEntity] = []
                    for entity in entities {
                        entity.setScale(SIMD3<Float>(0.002, 0.002, 0.002), relativeTo: anchor)
                        entity.generateCollisionShapes(recursive: true)
                        for _ in 1...2 {
                            objects.append(entity.clone(recursive: true))
                        }
                    }
                    
                    objects.shuffle()
                    
                    for (index, object) in objects.enumerated() {
                        cards[index].addChild(object)
                        cards[index].transform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
                    }
                    
                    cancellable?.cancel()
                })
        }
        
        
        
    }
    
    @IBAction func onTapped(_ sender: UITapGestureRecognizer) {
        
        // tap 위치에 대해 arView 상에서의 위치를 확인
        let tapLocation = sender.location(in: arView)
        
        // arView의 해당 위치에 entity가 있다면
        if let entity = arView.entity(at: tapLocation),
            let card = entity.name == "GameCard" ? entity : entity.parent {
            // 현재 회전된 각도가 얼마인지를 체크함
            // pi 는 180도 -> 반 바퀴 회전한 상태인지, 정상적인 상태인지를 체크하는 조건문
            if card.transform.rotation.angle == .pi {
                var flipDownTransform = card.transform
                
                // 만약에 반 바퀴 돌아간 상태라면
                // 0도 회전한 상태로 움직이기
                flipDownTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
                card.move(to: flipDownTransform, relativeTo: card.parent, duration: 0.25, timingFunction: .easeInOut)
            } else {
                var flipUpTransform = card.transform
                
                // 만약에 정상적인 상태라면
                // pi 만큼 / 180도 회전한 상태로 움직이기
                flipUpTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
                card.move(to: flipUpTransform, relativeTo: card.parent, duration: 0.5, timingFunction: .easeInOut)
            }
        }
    }
}
