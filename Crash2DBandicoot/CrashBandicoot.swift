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
    var isDead = false
    
    init(position: CGPoint) {
        self.initialPosition = position
        let texture = SKTexture(imageNamed: "CrashBandicootSprite")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = "CrashBandicoot"
        self.zPosition = 5.0
        self.position = position
        self.size = CGSize(width: self.size.width/4, height: self.size.height/4)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = BitMaskCategory.crash
        self.physicsBody?.contactTestBitMask = BitMaskCategory.rollingStoneMovePoint & BitMaskCategory.rollingStone
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        /*
        velocityY += gravity
        sprite.position.y -= velocityY
        
        if sprite.position.y < playerPosY {
            sprite.position.y = playerPosY
            velocityY = 0.0
            onGround = true
        }*/
        if moveLeft {
            self.position.x -= 5
         }
         if moveRight {
             self.position.x += 5
         }
    }
    
    func jump(touchPoint: CGPoint) {
        if physicsBody?.velocity.dy == 0 {
            // Apply impulse to make the player jump
            physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
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
        } else {
            self.moveRight = true
            self.moveLeft = false
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
