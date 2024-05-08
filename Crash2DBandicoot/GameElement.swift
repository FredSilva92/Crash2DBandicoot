//
//  GameElement.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 08/05/2024.
//

import Foundation
import SpriteKit

class GameElement {
    internal var sprite: SKSpriteNode
    
    func getSprite() -> SKSpriteNode {
        return self.sprite
    }
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
    }
    
    func update() {}
}
