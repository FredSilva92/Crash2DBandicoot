//
//  CrashBandicoot.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 21/04/2024.
//

import Foundation
import SpriteKit

class CrashBandicoot: SKSpriteNode {
    
    private var velocityY: CGFloat = 0.0
    private var gravity: CGFloat = 0.6
    private var playerPosY: CGFloat = 0.0
    private var onGround = true
    private var moveLeft = false
    private var moveRight = false
    private var initialPosition: CGPoint
    private var jumpStrengh: CGVector
    private var animations:[String: SKAction] = [:]
    var isDead = false
    
    init(position: CGPoint, sceneSize: CGSize) {
        self.initialPosition = position
        jumpStrengh = CGVector(dx: 0, dy: sceneSize.height/6)
        
        let idleFrames = Utils.getTextures(name: Constants.Crash.idle)
        let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.2)
        animations[Constants.Crash.idle] = Utils.getAnimationAction(name: Constants.Crash.idle, timePerFrame: 0.2)
        
        //let walkingFrames = Utils.getTextures(name: Constants.Crash.walkingRight)
        animations[Constants.Crash.walking] = Utils.getAnimationAction(name: Constants.Crash.walking, timePerFrame: 0.1)
        
        var textureSize: CGSize;
        
        if let mySize = idleFrames.first?.size() {
            textureSize = mySize
        } else {
            textureSize = CGSize(width: 1.0, height: 1.0)
        }
        
        super.init(texture: idleFrames.first, color: .clear, size: textureSize)
        
        self.name = "CrashBandicoot"
        self.zPosition = 2.0
        self.position = position
        //self.size = self.size/4
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = BitMaskCategory.crash
        self.physicsBody?.contactTestBitMask = BitMaskCategory.rollingStoneMovePoint & BitMaskCategory.rollingStone
        
        runAnimation(animations: animations, key: Constants.Crash.idle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        if isDead {return}
        
        if moveLeft {
            self.position.x -= 5
         }
         else if moveRight {
             self.position.x += 5
         } else {
             runAnimation(animations: animations, key: Constants.Crash.idle)
         }
    }
    
    func jump(touchPoint: CGPoint) {
        if physicsBody?.velocity.dy == 0 {
            // Apply impulse to make the player jump
            physicsBody?.applyImpulse(jumpStrengh)
        }
    }
    
    func run(touchPoint: CGPoint) {
        let moveAction = SKAction.move(to: CGPoint(x: touchPoint.x, y:position.y), duration: getMoveDuration(touchPoint: touchPoint))
        super.run(moveAction)
    }
    
    func run(loc: CGPoint) {
        
        if loc.x < self.position.x {
            self.moveLeft = true
            self.moveRight = false
            xScale = -1.0
            runAnimation(animations: animations, key: Constants.Crash.walking)
            
        } else {
            self.moveRight = true
            self.moveLeft = false
            xScale = 1.0
            runAnimation(animations: animations, key: Constants.Crash.walking)
        }
    }
    
    private func getMoveDuration(touchPoint: CGPoint) -> Double {
        let distance = sqrt(pow(touchPoint.x - position.x, 2) + pow(touchPoint.y - position.y, 2))
        return TimeInterval(distance / 300) // Adjust 100 to change speed
    }
    
    func stopMoving() {
        self.moveLeft = false
        self.moveRight = false
    }
    
    func reset() {
        self.position = initialPosition
    }
}
