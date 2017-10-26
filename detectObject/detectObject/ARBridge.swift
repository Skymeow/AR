//
//  ARBridge.swift
//  detectObject
//
//  Created by Sky Xu on 10/26/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class ARBridge {
    
    static let shared = ARBridge()
//  To store the ARAnchor and String assigned to that ARAnchor 
    var anchorsToIdentifiers = [ARAnchor : String]()
    
}
