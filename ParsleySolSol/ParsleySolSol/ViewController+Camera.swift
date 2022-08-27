//
//  ViewControllerCamera.swift
//  ParsleySolSol
//
//  Created by Park Sungmin on 2022/08/26.
//

import Foundation
import UIKit
import AVFoundation
import Vision

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func prepareCamera() {
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices
        captureDevice = availableDevices.first
        
    }
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print("Could not create video device input")
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .vga640x480
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let exitOrientation = self.exitOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exitOrientation, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    
    func exitOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let currentDeviceOrientation = UIDevice.current.orientation
        let exitOrientation: CGImagePropertyOrientation
        
        switch currentDeviceOrientation {
        case .unknown:
            exitOrientation = .up
        case .portrait:
            exitOrientation = .up
        case .portraitUpsideDown:
            exitOrientation = .left
        case .landscapeLeft:
            exitOrientation = .upMirrored
        case .landscapeRight:
            exitOrientation = .down
        case .faceUp:
            exitOrientation = .up
        case .faceDown:
            exitOrientation = .up
        }
        
        return exitOrientation
    }
}
