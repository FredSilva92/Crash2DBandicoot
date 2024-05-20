//
//  Utils.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 09/05/2024.
//

import Foundation
import SpriteKit

class Utils {
    static func getTextures(name: String) -> [SKTexture] {
        let textureAtlas = SKTextureAtlas(named: name)

        // Create an array to store animation frames
        var animationFrames: [SKTexture] = []

        // Populate the array with textures from the sprite sheet
        let names = textureAtlas.textureNames
        for i in 0..<names.count {
            animationFrames.append(textureAtlas.textureNamed(names[i]))
        }
        
        return animationFrames
    }
    
    static func getAnimationAction(name: String, timePerFrame: Double, flippedImg: Bool = false) -> SKAction {
        let textureAtlas = SKTextureAtlas(named: name)

        // Create an array to store animation frames
        var animationFrames: [SKTexture] = []

        // Populate the array with textures from the sprite sheet
        let names = textureAtlas.textureNames
        for i in 0..<names.count {
            var image: SKTexture = textureAtlas.textureNamed(names[i])
            animationFrames.append(image)
        }
        
        return SKAction.animate(with: animationFrames, timePerFrame: timePerFrame)
    }
}
