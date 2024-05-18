//
//  GameScene.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 16/04/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    override func sceneDidLoad() {
        var bg = SKSpriteNode(imageNamed: "ForestBg")
        
        bg.zPosition = -1
        addChild(bg)
        
        run(SKAction.run {
            let gameoverScene = Level1(size: self.size)
            self.view?.presentScene(gameoverScene)
        })
    }
}
