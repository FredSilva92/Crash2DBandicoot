//
//  RollingStone.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 07/05/2024.
//

import Foundation
import SpriteKit
import AVFoundation

class RollingStone: SKSpriteNode {
    
    private var initialPosition: CGPoint
    private var rollSound: AVAudioPlayer?
    var impulseDx: Double = 3.5
    
    
    init() {

        
        let texture = SKTexture(imageNamed: "RollingStone")
        
        let size = CGSize(width: texture.size().width/1.5, height: texture.size().height/1.5)
        
        let initialPosition = CGPoint(x: UIScreen.main.bounds.size.width/2 * 1.1, y: UIScreen.main.bounds.size.height - size.height/1.5)
        self.initialPosition = initialPosition
        
        super.init(texture: texture, color: .clear, size: size)

        self.name = "RStone"
        self.position = initialPosition
        //self.size = CGSize(width: texture.size().width, height: texture.size().height)
        self.zPosition = 1.0
        //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/1.75)
        setPhysiscsProps(false)
        self.physicsBody?.categoryBitMask = BitMaskCategory.rollingStone
        self.physicsBody?.contactTestBitMask = BitMaskCategory.crash
        
        rollSound = Utils.getSoundEffect(name: "RollStone", ext: "wav")
        rollSound?.volume = 1.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func run() {
        setPhysiscsProps(true)
    }
    
    func update(deathThreshold: CGFloat) {
        
        if self.physicsBody?.affectedByGravity == true && !isPaused {
            self.zRotation -= 0.2
            
            self.position.x += 3.75
            self.physicsBody?.applyImpulse(CGVector(dx: 0.25, dy: 14) )
            rollSound?.play()
        }
        
        if (position.y < deathThreshold) {
            rollSound?.stop()
        }
        if (position.y < deathThreshold - 100) {
            setPhysiscsProps(false)
        }
    }
    
    func reset() {
        
        setPhysiscsProps(false)
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.zRotation = 0.0
        self.position = self.initialPosition
        rollSound?.stop()
    }
    
    private func setPhysiscsProps(_ value: Bool) {
        self.physicsBody?.isDynamic = value
        self.physicsBody?.affectedByGravity = value
        self.physicsBody?.allowsRotation = value
    }
}
