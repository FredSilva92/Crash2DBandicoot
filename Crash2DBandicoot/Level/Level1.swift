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
        rollingStone = RollingStone()
        
        super.init(size: size)
        
        buildLevel(levelFile: "Level1")
        
        addChild(crash)
        
        startRStoneCollider = InvislbleCollider(point: CGPoint(x: rollingStone.position.x * 1.4, y: 0))

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
            onDead()
        }
        
        if (first.categoryBitMask == BitMaskCategory.rollingStone &&
            second.categoryBitMask == BitMaskCategory.woodPath) {
            second.isDynamic = true
            second.affectedByGravity = true
        }
        
        if (first.categoryBitMask == BitMaskCategory.crash &&
            second.categoryBitMask == BitMaskCategory.star) {
            run(SKAction.run {
                let gameoverScene = Level2(size: self.size)
                self.view?.presentScene(gameoverScene)
            })
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
            self.resetWoodPath()
        }

        var actions = actionsToPass
        actions.append(resetStone)

        super.execActions(actionsToPass: actions)
    }
    
    override func setPausedElements(paused: Bool) {
        super.setPausedElements(paused: paused)
        rollingStone.isPaused = paused
    }
    
    private func resetWoodPath() {
        let woodPaths = getNodes(withName: SceneElement.Names.wood, ofType: GameElement.self)
        
        for wood in woodPaths {
            wood.position = wood.initialPosition
            wood.physicsBody?.isDynamic = false
            wood.physicsBody?.affectedByGravity = false
        }
    }
}
