//
//  Spider.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 12/05/2024.
//

import Foundation
import SpriteKit
import AVFoundation

class Spider: SKSpriteNode {
    
    private var initialPosition: CGPoint
    private var moves: [CGFloat] = [-1, 2, -1, -1, 1]
    private var nextMove = 0
    private var moveAmount: CGFloat = 0.5
    private var destMove: CGFloat = 0.0
    private var destPoint: CGPoint
    private var animations:[String: SKAction] = [:]
    private var attackSound: AVAudioPlayer?
    
    init(initialPos: CGPoint) {
        
        self.initialPosition = initialPos
        self.destPoint = initialPos
        // Load the sprite sheet
        let textureAtlas = SKTextureAtlas(named: Animations.Spider.idle)

        // Create an array to store animation frames
        var animationFrames: [SKTexture] = []

        // Populate the array with textures from the sprite sheet
        for i in 0..<textureAtlas.textureNames.count {
            //let textureName = "frame_\(i)"
            animationFrames.append(textureAtlas.textureNamed(textureAtlas.textureNames[i]))
        }
        
        animations[Animations.Spider.idle] = Utils.getAnimationAction(name: Animations.Spider.idle, timePerFrame: 0.1)
        animations[Animations.Spider.walking] = Utils.getAnimationAction(name: Animations.Spider.walking, timePerFrame: 0.1)
        animations[Animations.Spider.attack] = Utils.getAnimationAction(name: Animations.Spider.attack, timePerFrame: 0.1)
        
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
        self.anchorPoint = CGPoint(x: 0.25, y: 0.25)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height/2))
        
        self.physicsBody?.categoryBitMask = BitMaskCategory.spider
        self.physicsBody?.contactTestBitMask = BitMaskCategory.crash
        
        attackSound = Utils.getSoundEffect(name: "WebShoot", ext: "mp3")
        attackSound?.numberOfLoops = 0
        
        runAnimation(animations: animations, key: Animations.Spider.walking)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        
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
    
    func reset() {
        nextMove = 0
        self.destPoint = self.initialPosition
        self.position = initialPosition
        runAnimation(animations: animations, key: Animations.Spider.walking)
    }
    
    func attack() {
        runAnimation(animations: animations, key: Animations.Spider.attack, repeatAction: false)
        attackSound?.prepareToPlay()
        attackSound?.play()
    }
}
