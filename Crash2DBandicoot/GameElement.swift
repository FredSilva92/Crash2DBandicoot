//
//  GameElement.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 08/05/2024.
//

import Foundation
import SpriteKit

class GameElement : SKSpriteNode {
    var initialPosition: CGPoint
    
    init(imageNamed: String, name: String, initialPosition: CGPoint, ratio: CGFloat) {
        self.initialPosition = initialPosition
        
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: CGSize(width: ratio, height: ratio))
        
        self.name = name
        self.position = initialPosition
        self.zPosition = 1.0
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
