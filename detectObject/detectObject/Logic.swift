//
//  Scene.swift
//  detectObject
//
//  Created by Sky Xu on 10/26/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import SpriteKit
import ARKit
import Vision
import Dispatch
import CoreML

class Scene: SKScene {
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            DispatchQueue.global(qos: .background).async {
                do {
                    let model = try VNCoreMLModel(for: Inceptionv3().model)
                    let request = VNCoreMLRequest(model: model, completionHandler:{(request, error) in
                        
                        DispatchQueue.main.async {
                            guard let results = request.results as? [VNClassificationObservation], let result = results.first else {
                                print("no results")
                                return
                            }
                // Create a transform with a translation of 0.4 meters in front of the camera
                        var translation = matrix_identity_float4x4
                        translation.columns.3.z = -0.6
                        let transform = simd_mul(currentFrame.camera.transform, translation)
                            // Add a new anchor as! @convention(block) () -> Void to the session
                        let anchor = ARAnchor(transform: transform)
                       
                // set the identifier
                        ARBridge.shared.anchorsToIdentifiers[anchor] = result.identifier
                            sceneView.session.add(anchor: anchor)
                        }
                    })
                    let handler = VNImageRequestHandler(cvPixelBuffer: currentFrame.capturedImage, options: [:])
                    try handler.perform([request])
                } catch {}
            }
  
        }
    }
}
