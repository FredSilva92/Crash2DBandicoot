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
    
    override init(size: CGSize, lives: Int) {
        rollingStone = RollingStone()
        
        super.init(size: size, lives: lives)
        
        buildLevel(levelFile: "Level1")
        
        addChild(crash)
        addChild(rollingStone)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let first = getPhysicsContact(contact)[0]
        let second = getPhysicsContact(contact)[1]
        
        if(first.categoryBitMask == BitMaskCategory.rollingStoneMovePoint &&
           second.categoryBitMask == BitMaskCategory.crash) {
            rollingStone.run()
        }
        
        if (first.categoryBitMask == BitMaskCategory.rollingStone &&
            second.categoryBitMask == BitMaskCategory.crash) {
            
            if !crash.isDead {
                onDead()
            }
            
        }
        
        if (first.categoryBitMask == BitMaskCategory.rollingStone &&
            second.categoryBitMask == BitMaskCategory.woodPath) {
            
            second.isDynamic = true
            second.affectedByGravity = true
        }
        
        if (first.categoryBitMask == BitMaskCategory.crash &&
            second.categoryBitMask == BitMaskCategory.star) {
            
            audioPlayer?.stop()
            loadingScreen()
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: 2),
                SKAction.run {
                    let reveal = SKTransition.flipVertical(withDuration: 0.5)
                    let scene = Level2(size: self.size, lives: self.crash.lives)
                    self.view?.presentScene(scene, transition: reveal)
                }
            ]))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !crash.isDead {
            
            if (crash.position.x > rollingStone.position.x * 1.4
                && crash.position.x < rollingStone.position.x * 1.5) {
                rollingStone.run()
            }
            
            rollingStone.update(deathThreshold: deathThreshold)
        }
    }
    
    override func execActions(actionsToPass: [SKAction]) {
        let resetStone = SKAction.run {
            self.rollingStone.reset()
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

