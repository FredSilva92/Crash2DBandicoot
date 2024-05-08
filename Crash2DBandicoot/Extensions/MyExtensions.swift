//
//  MyExtensions.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 08/05/2024.
//

import Foundation
import SpriteKit

extension SKPhysicsBody {
    // Extension to get the parent node of the physics body
    func getParentNode(scene: SKScene) -> SKNode? {
        // Iterate through all nodes in the scene
        for node in scene.children {
            // Check if the node's physics body matches the current physics body
            if node.physicsBody === self {
                // Found the parent node
                return node
            }
            // Recursively search through children
            if let parentNode = node.physicsBody?.getParentNode(scene: scene) {
                return parentNode
            }
        }
        // If not found, return nil
        return nil
    }
}
