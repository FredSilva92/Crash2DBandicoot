//
//  RollingStone.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 07/05/2024.
//

import Foundation
import SpriteKit

class RollingStone: SKSpriteNode {
    
    private var initialPosition: CGPoint
    
    init() {

        
        let texture = SKTexture(imageNamed: "RollingStone")
        
        let size = CGSize(width: texture.size().width/2, height: texture.size().height/2)
        
        let initialPosition = CGPoint(x: UIScreen.main.bounds.size.width/2 * 1.1, y: UIScreen.main.bounds.size.height - size.height/2)
        self.initialPosition = initialPosition
        
        super.init(texture: texture, color: .clear, size: size)

        self.name = "RStone"
        self.position = initialPosition
        //self.size = CGSize(width: texture.size().width, height: texture.size().height)
        self.zPosition = 5.0
        //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        setPhysiscsProps(false)
        self.physicsBody?.categoryBitMask = BitMaskCategory.rollingStone
        self.physicsBody?.contactTestBitMask = BitMaskCategory.crash
        //self.sprite.physicsBody?.mass = 1
        //self.sprite.physicsBody?.restitution = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func run() {
        setPhysiscsProps(true)
        /*let rotateAction = SKAction.rotate(byAngle: -CGFloat.pi, duration: 0.5)
        let repeatAction = SKAction.repeatForever(rotateAction)
        self.run(repeatAction, withKey: "rotateAction")*/
        //self.sprite.position.x += 5
    }
    
    func update() {
        if self.physicsBody?.affectedByGravity == true && !isPaused {
            //self.sprite.position.x += 5
            self.zRotation -= 0.2
            //self.position.x += 5
            self.physicsBody?.applyImpulse(CGVector(dx: 3.5, dy: 0))
            //print("Rock pos: " + String(Float(self.position.x)))
        }
        
    }
    
    func reset() {
        setPhysiscsProps(false)
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.zRotation = 0.0
        //self.removeAllActions()
        self.position = self.initialPosition
    }
    
    private func setPhysiscsProps(_ value: Bool) {
        self.physicsBody?.isDynamic = value
        self.physicsBody?.affectedByGravity = value
        self.physicsBody?.allowsRotation = value
    }
}
