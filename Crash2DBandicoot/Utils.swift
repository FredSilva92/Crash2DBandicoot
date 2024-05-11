//
//  Utils.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 09/05/2024.
//

import Foundation
import SpriteKit

class Utils {
    static func buildLevel(scene: SKScene, levelFile: String) {
        guard let levelURL = Bundle.main.url(forResource: levelFile, withExtension: ".txt") else {return}
        guard let levelString = try? String(contentsOf: levelURL) else {return}
        let lines = levelString.components(separatedBy: "\n")
        var currentTileYPos = -scene.frame.height/9
        
        for (_, line) in lines.reversed().enumerated() {
            
            if  line.isEmpty {
                continue
            }
            
            var currentTileXPos = -UIScreen.main.bounds.width
            
            for(_, letter) in line.enumerated() {
                currentTileXPos += SpriteSize.width;
                
                if letter == SceneElement.platform {
                    let element = buildElement(assetName: "plainDirt2",
                                               name: "Ground",
                                               position: CGPoint(x: currentTileXPos, y: currentTileYPos))
                    element.physicsBody = SKPhysicsBody(rectangleOf: element.size)
                    element.physicsBody?.isDynamic = false
                    element.physicsBody?.affectedByGravity = false
                    
                    scene.addChild(element)
                    
                    //scene.deathThreshold = min(scene.deathThreshold, -scene.frame.height/9)
                    
                } else if letter == SceneElement.wood {
                    
                    let element = buildElement(assetName: "plainDirt0",
                                               name: "WoodPath",
                                               position: CGPoint(x: currentTileXPos, y: currentTileYPos))
                    element.physicsBody = SKPhysicsBody(rectangleOf: element.size)
                    element.physicsBody?.isDynamic = false
                    element.physicsBody?.affectedByGravity = false
                    element.physicsBody?.categoryBitMask = BitMaskCategory.woodPath
                    element.physicsBody?.contactTestBitMask = BitMaskCategory.rollingStone
                    scene.addChild(element)
                    
                    //scene.deathThreshold = min(scene.deathThreshold, -scene.frame.height/9)
                } else if letter == SceneElement.star {
                    
                    let element = buildElement(assetName: "Star",
                                               name: "Star",
                                               position: CGPoint(x: currentTileXPos, y: currentTileYPos))
                    element.physicsBody = SKPhysicsBody(rectangleOf: element.size)
                    element.physicsBody?.isDynamic = false
                    element.physicsBody?.affectedByGravity = false
                    scene.addChild(element)
                }
            }
            
            currentTileYPos += SpriteSize.height
        }
    }
    
    static func buildElement(assetName: String, name: String, position: CGPoint) -> SKSpriteNode {
        let element = SKSpriteNode(imageNamed: assetName)
        
        element.name = name
        element.position = position
        element.size = CGSize(width: SpriteSize.width, height: SpriteSize.height)
        element.zPosition = 1.0
        
        return element
    }
}
