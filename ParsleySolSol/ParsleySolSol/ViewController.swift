//
//  ViewController.swift
//  ParsleySolSol
//
//  Created by Park Sungmin on 2022/08/26.
//

import UIKit
import AVFoundation
import AVKit
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var handImageView: UIImageView!
    
    // MARK: Camera Properties
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var devicePosition: AVCaptureDevice.Position = .front
    
    // MARK: Vision Properties
    var requests = [VNRequest]() 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupVision()
        setupPlayer()
        setupAirPlay()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
    }
    
    func setupVision() {
        let config = MLModelConfiguration()
        do { let model = try ParsleyPose(configuration: config).model } catch { print("error") }
        
        guard let visionModel = try? VNCoreMLModel(for: ParsleyPose(configuration: config).model) else {fatalError("Can't load vision ML model")}
        
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        classificationRequest.imageCropAndScaleOption = .centerCrop
        
        self.requests = [classificationRequest]
    }
    
    func setupPlayer() {
        playerView.setPlayerURL(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
        playerView.player.play()
    }
    
    func setupAirPlay() {
        
        let airplay = AVRoutePickerView(frame: CGRect(x: 0, y: 40, width: 80, height: 80))
        airplay.center.x = self.view.center.x
        airplay.tintColor = UIColor.white
        self.view.addSubview(airplay)
    }
    
    
    func handleClassification (request: VNRequest, error: Error?) {
        guard let observations = request.results else { print("no results"); return }
        
        let classifications = observations.compactMap({$0 as? VNClassificationObservation})
            .filter({$0.confidence > 0.6})
            .map({$0.identifier})
        
        print(classifications)
    }
}

