//
//  Level1.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 11/05/2024.
//

import Foundation
import SpriteKit

class Level1: LevelScene {
    private var rollingStone: RollingStone
    private var startRStoneCollider: InvislbleCollider?
    
    override init(size: CGSize) {
        rollingStone = RollingStone(screenSize: size)
        
        super.init(size: size)
        
        addChild(crash)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -10.0)
        self.physicsWorld.contactDelegate = self
        
        
        startRStoneCollider = InvislbleCollider(point: CGPoint(x: rollingStone.position.x * 1.1, y: 0))

        addChild(rollingStone)
        addChild(startRStoneCollider!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let first = getPhysicsContact(contact)[0]
        let second = getPhysicsContact(contact)[1]
        
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
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !crash.isDead {
            rollingStone.update()
        }
    }
    
    override func execActions(actionsToPass: [SKAction]) {
        let resetStone = SKAction.run {
            self.rollingStone.reset()
            self.addChild(self.startRStoneCollider!)
            print("Delayed 1")
        }

        var actions = actionsToPass
        actions.append(resetStone)

        super.execActions(actionsToPass: actions)
    }
}

