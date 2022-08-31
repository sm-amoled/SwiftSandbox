//
//  FingerPointDetector.swift
//  HandAction
//
//  Created by Park Sungmin on 2022/08/31.
//

import Foundation
import Vision

class FingerPointDetector {
    
    weak var delegate: PredictorDelegate?
    
    let predictionWindowSize = 60
    var posesWindow: [VNHumanHandPoseObservation] = []
    
    init() {
        posesWindow.reserveCapacity(predictionWindowSize)
    }
    
    
    func estimation(pixelBuffer: CVPixelBuffer) {
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                   orientation: .up)
        
        let request = VNDetectHumanHandPoseRequest(completionHandler: handPoseHandler)
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request with error : \(error)")
        }
    }
    
    func handPoseHandler(request: VNRequest, error: Error?) {
        guard let observation = request.results as? [VNHumanHandPoseObservation] else { return }
        
        observation.forEach {
            processObservation($0)
        }
        
        if let result = observation.first {
            storeObservation(result)
            
//            labelActionType()
            do {
                let indexFinger: [VNHumanHandPoseObservation.JointName: VNRecognizedPoint]? = try observation.first?.recognizedPoints(.indexFinger)
                let indexFingerTipPoint = indexFinger?[.indexTip]
                
                print("x: \(indexFingerTipPoint?.x) / y: \(indexFingerTipPoint?.y)")
            } catch {
                print("검지손가락을 찾을 수 없음")
            }
        }
    }
    
    
    func labelActionType() {
        guard let parsleyClassifier = try? ParsleyModel(configuration: MLModelConfiguration()),
              let poseMultiArray = prepareInputWithObservations(posesWindow),
              let predictions = try? parsleyClassifier.prediction(poses: poseMultiArray) else {
            return
        }
        
        let label = predictions.label
        let confidence = predictions.labelProbabilities[label] ?? 0
        
//        delegate?.predictor(self, didLabelAction: label, with: confidence)
    }
    
    func prepareInputWithObservations(_ observations: [VNHumanHandPoseObservation]) -> MLMultiArray? {
        let numAvailableFrames = observations.count
        let observationsNeeded = 60
        var multiArrayBuffer = [MLMultiArray]()
        
        for frameIndex in 0 ..< min(numAvailableFrames, observationsNeeded) {
            let pose = observations[frameIndex]
            do {
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArrayBuffer.append(oneFrameMultiArray)
            } catch {
                continue
            }
        }
        
        if numAvailableFrames < observationsNeeded {
            for _ in 0 ..< (observationsNeeded - numAvailableFrames) {
                do {
                    let oneFrameMultiArray = try MLMultiArray(shape: [1, 3, 21], dataType: .double)
                    try resetMultiArray(oneFrameMultiArray)
                    multiArrayBuffer.append(oneFrameMultiArray)
                } catch {
                    continue
                }
            }
        }
        
        return MLMultiArray(concatenating: [MLMultiArray](multiArrayBuffer), axis: 0, dataType: .float)
    }
    
    func resetMultiArray(_ predictionWindow: MLMultiArray, with value: Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }
    
    func storeObservation(_ observation: VNHumanHandPoseObservation) {
        if posesWindow.count >= predictionWindowSize {
            posesWindow.removeFirst()
        }
        
        posesWindow.append(observation)
    }
    
    func processObservation(_ observation: VNHumanHandPoseObservation) {
        do {
            let recognizedPoints = try observation.recognizedPoints(forGroupKey: .all)
            
            var displayedPoints = recognizedPoints.map {
                CGPoint(x: $0.value.x, y: 1 - $0.value.y)
            }
            
//            delegate?.predictor(self, didFindNewRecognizedPoints: displayedPoints)
        } catch {
            
        }
    }

}
