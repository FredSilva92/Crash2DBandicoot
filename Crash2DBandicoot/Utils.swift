//
//  Utils.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 09/05/2024.
//

import Foundation
import SpriteKit
import AVFoundation

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
    
    static func getSoundEffect(name: String, ext: String) -> AVAudioPlayer? {
        var sound: AVAudioPlayer?
        
        if let soundURL = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                sound = try AVAudioPlayer(contentsOf: soundURL)
                sound?.numberOfLoops = -1 // Loop indefinitely
                //sound?.volume = 1.5
                //walkingSound?.play()
            } catch {
                print("Error: Could not find or play the sound file.")
            }
        }
        
        return sound
    }
    
    static func getChildNode(named name: String, in node: SKNode) -> SKNode? {
        if node.name == name {
            return node
        }
        
        for child in node.children {
            if let foundNode = getChildNode(named: name, in: child) {
                return foundNode
            }
        }
        
        return nil
    }
    
    static func getAspectRatio(screenSize: CGSize) -> CGSize{
        
        let aspectRatio = screenSize.width / screenSize.height
        
        let baseAspectRatio: CGFloat = 16.0 / 9.0
 
        if aspectRatio > baseAspectRatio {
            return CGSize(width: screenSize.height * baseAspectRatio, height: screenSize.height)
        }
            
        return CGSize(width: screenSize.width, height: screenSize.width / baseAspectRatio)
        
    }
}


