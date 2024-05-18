//
//  Spider.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 12/05/2024.
//

import Foundation
import SpriteKit

class Spider: SKSpriteNode {
    
    private var initialPosition: CGPoint
    private var moves: [CGFloat] = [-1, 2, -1, -1, 1]
    private var nextMove = 0
    private var moveAmount: CGFloat = 0.5
    private var destMove: CGFloat = 0.0
    private var destPoint: CGPoint
    private var animations:[String: SKAction] = [:]
    
    init(initialPos: CGPoint) {
        
        self.initialPosition = initialPos
        self.destPoint = initialPos
        // Load the sprite sheet
        let textureAtlas = SKTextureAtlas(named: Constants.Spider.idle)

        // Create an array to store animation frames
        var animationFrames: [SKTexture] = []

        // Populate the array with textures from the sprite sheet
        for i in 0..<textureAtlas.textureNames.count {
            //let textureName = "frame_\(i)"
            animationFrames.append(textureAtlas.textureNamed(textureAtlas.textureNames[i]))
        }
        
        animations[Constants.Spider.idle] = Utils.getAnimationAction(name: Constants.Spider.idle, timePerFrame: 0.1)
        animations[Constants.Spider.walking] = Utils.getAnimationAction(name: Constants.Spider.walking, timePerFrame: 0.1)
        
        var textureSize: CGSize;
        
        if let mySize = animationFrames.first?.size() {
            textureSize = mySize
        } else {
            textureSize = CGSize(width: 1.0, height: 1.0)
        }
        
        // Create an animated sprite node
        super.init(texture: animationFrames.first, color: UIColor.clear, size: textureSize)
        
        self.name = "Spider"
        self.position = initialPosition
        
        self.zPosition = 1.0
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        
        self.physicsBody?.categoryBitMask = BitMaskCategory.spider
        self.physicsBody?.contactTestBitMask = BitMaskCategory.crash
        
        runAnimation(animations: animations, key: Constants.Spider.walking)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        let startWalking = Bool.random()
        
        if compareXPos() {
            randomWalk()
        } else {
            if xScale == 1.0 {
                self.position.x += moveAmount
            } else {
                self.position.x -= moveAmount
            }
        }
        
        print("Spider pos:" + String(Float(self.position.x)))
    }
    
    func randomWalk() {
        
        destMove = moves[nextMove] * 40
        xScale = destMove > 0 ? 1 : -1
        destPoint = CGPoint(x: self.position.x + destMove, y: self.position.y)
        
        if nextMove == moves.count - 1 {
            nextMove = 0
        } else {
            nextMove += 1
        }
    }
    
    private func compareXPos() -> Bool {
        let epsilon: CGFloat = 0.1 // Adjust epsilon as needed
        return abs(self.position.x - destPoint.x) < epsilon
    }
}
