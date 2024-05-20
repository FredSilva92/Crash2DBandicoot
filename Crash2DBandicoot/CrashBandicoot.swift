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
    var isAttacking = false
    var isDead = false
    
    init(position: CGPoint, sceneSize: CGSize) {
        self.initialPosition = position
        jumpStrengh = CGVector(dx: 0, dy: sceneSize.height/6)
        
        let idleFrames = Utils.getTextures(name: Animations.Crash.idle)
        //let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.2)
        
        animations[Animations.Crash.idle] = Utils.getAnimationAction(name: Animations.Crash.idle, timePerFrame: 0.2)
        animations[Animations.Crash.walking] = Utils.getAnimationAction(name: Animations.Crash.walking, timePerFrame: 0.1)
        animations[Animations.Crash.death] = Utils.getAnimationAction(name: Animations.Crash.death, timePerFrame: 0.1)
        animations[Animations.Crash.attack] = Utils.getAnimationAction(name: Animations.Crash.attack, timePerFrame: 0.05)
        
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
        
        runAnimation(animations: animations, key: Animations.Crash.idle)
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
        }
    }
    
    func jump(touchPoint: CGPoint) {
        if physicsBody?.velocity.dy == 0 {
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
            runAnimation(animations: animations, key: Animations.Crash.walking)
            
        } else {
            self.moveRight = true
            self.moveLeft = false
            xScale = 1.0
            runAnimation(animations: animations, key: Animations.Crash.walking)
        }
    }
    
    private func getMoveDuration(touchPoint: CGPoint) -> Double {
        let distance = sqrt(pow(touchPoint.x - position.x, 2) + pow(touchPoint.y - position.y, 2))
        return TimeInterval(distance / 300) // Adjust 100 to change speed
    }
    
    func stopMoving() {
        self.moveLeft = false
        self.moveRight = false
        runAnimation(animations: animations, key: Animations.Crash.idle)
    }
    
    func getDeathAction() -> SKAction {
        self.isDead = true
        runAnimation(animations: animations, key: Animations.Crash.death, repeatAction: false)
        
        return SKAction.run {
            self.isDead = false
            self.position = self.initialPosition
            self.runAnimation(animations: self.animations, key: Animations.Crash.idle)
        }
    }
    
    func attack() {
        isAttacking = true
        runAnimation(animations: animations, key: Animations.Crash.attack)
        
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.run {
                self.isAttacking = false
                self.runAnimation(animations: self.animations, key: Animations.Crash.idle)
            }
        ]))
    }
}
