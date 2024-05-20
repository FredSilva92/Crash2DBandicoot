//
//  Level2.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 10/05/2024.
//

import SpriteKit
import GameplayKit

class Level2: LevelScene {
    
    private var spiders: [Spider] = []
    
    override init(size: CGSize){
        super.init(size: size)
        
        buildLevel(levelFile: "Level2")
        spiders = getNodes(withName: "Spider", ofType: Spider.self)
        
        addChild(crash)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if crash.isDead {return}
        
        let first = getPhysicsContact(contact)[0]
        let second = getPhysicsContact(contact)[1]
        
        if (first.categoryBitMask == BitMaskCategory.crash &&
            second.categoryBitMask == BitMaskCategory.spider) {
            
            let spider = second.node as? Spider
            
            if crash.isAttacking {
                spider?.removeFromParent()
            } else {
                spider?.xScale = -crash.xScale
                spider?.attack()
                onDead()
            }
            

        } else if (first.categoryBitMask == BitMaskCategory.crash &&
             second.categoryBitMask == BitMaskCategory.star) {
            
            audioPlayer?.stop()
            loadingScreen()
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: 2),
                SKAction.run {
                    let reveal = SKTransition.flipVertical(withDuration: 0.5)
                    let scene = MainMenu(size: self.size)
                    self.view?.presentScene(scene, transition: reveal)
                }
            ]))
         }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        for spider in spiders {
            spider.update()
        }
    }
    
    override func execActions(actionsToPass: [SKAction]) {
        let resetSpiders = SKAction.run {
            self.resetSpiders()
        }

        var actions = actionsToPass
        actions.append(resetSpiders)

        super.execActions(actionsToPass: actions)
    }
    
    private func resetSpiders() {
        
        for spider in spiders {
            spider.removeFromParent()
            spider.reset()
            self.addChild(spider)
        }
    }
}
