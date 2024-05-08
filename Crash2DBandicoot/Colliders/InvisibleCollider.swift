//
//  InvisibleCollider.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 08/05/2024.
//

import Foundation
import SpriteKit

class InvislbleCollider: SKNode {
    
    init(point: CGPoint) {
        super.init()
        
        // Create start point physics body
        let startPointBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 200))
        startPointBody.isDynamic = false
        startPointBody.categoryBitMask = BitMaskCategory.rollingStoneMovePoint // Set a category bitmask
        startPointBody.contactTestBitMask = BitMaskCategory.crash // Set a contact test bitmask
        
        position  = point
        physicsBody = startPointBody
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
