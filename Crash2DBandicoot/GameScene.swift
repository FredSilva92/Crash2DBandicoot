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
        
        run(SKAction.run {
            let mainMenu = MainMenu(size: self.size)
            self.view?.presentScene(mainMenu)
        })
    }
}
