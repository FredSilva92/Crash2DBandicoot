//
//  Level1.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 11/05/2024.
//

import Foundation
import SpriteKit

class Level1: LevelScene{
    private var rollingStone: RollingStone = RollingStone()
    private var startRStoneCollider: InvislbleCollider?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        addChild(crash)
        
        startRStoneCollider = InvislbleCollider(point: CGPoint(x: rollingStone.position.x + 200, y: 0))

        addChild(rollingStone)
        addChild(startRStoneCollider!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var first : SKPhysicsBody
        var second : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            first = contact.bodyA
            second  = contact.bodyB
        }
        else {
            first = contact.bodyB
            second = contact.bodyA
        }
        
        if(first.categoryBitMask == BitMaskCategory.rollingStoneMovePoint &&
           second.categoryBitMask == BitMaskCategory.crash) {
            
            startRStoneCollider?.removeFromParent()
            
            rollingStone.run()
        }
        
        if (first.categoryBitMask == BitMaskCategory.rollingStone &&
            second.categoryBitMask == BitMaskCategory.crash) {
            //crash.sprite.removeFromParent()
        }
        
        if (first.categoryBitMask == BitMaskCategory.rollingStone &&
            second.categoryBitMask == BitMaskCategory.woodPath) {
            second.isDynamic = true
            second.affectedByGravity = true
        }
    }
}

