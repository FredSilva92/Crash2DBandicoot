//
//  LevelScene.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 11/05/2024.
//

import SpriteKit
import GameplayKit

class LevelScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var dt: TimeInterval = 0.0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var cameraNode = SKCameraNode()
    private var bg = SKSpriteNode(imageNamed: "ForestBg")
    internal var crash: CrashBandicoot = CrashBandicoot(position: CGPoint(x: 0.0, y: 0.0));
    private var deathThreshold: CGFloat = 0.0
    
    override init(size : CGSize) {
        super.init(size: CGSize(width: 100, height: 150))
    
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -10.0)
        self.physicsWorld.contactDelegate = self
        
        crash = CrashBandicoot(position: CGPoint(x: 0.0, y: -frame.height/18));
        
        bg.zPosition = -1
        //bg.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(bg)
        deathThreshold = -frame.height/9
        setupCamera()
        
        Utils.buildLevel(scene: self, levelFile: "Level1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func update(_ currentTime: TimeInterval) {
        
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        if (crash.position.y < deathThreshold && !crash.isDead) {
            
            crash.isDead = true
            
            //addChild(startRStoneCollider!)
            
            //startRStoneCollider?.physicsBody?.isDynamic = true
            
            let otherAction = SKAction.run {
                // Code to execute after the delay
                self.crash.isDead = false
                self.crash.reset()
                //self.rollingStone.reset()
                print("Delayed action executed")
            }

            // Combine the delay action with the action to perform
            let sequence = SKAction.sequence([SKAction.wait(forDuration: 1.5), otherAction])

            // Run the sequence on a node (for example, the scene's root node)
            run(sequence)
            
            return
        }

        
        bg.position = CGPoint(x: cameraNode.position.x, y: cameraNode.position.y)
        crash.update()
        //rollingStone.update()
        moveCamera()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)
            crash.run(loc: location)
            if (location.y > 50.0) {
                crash.jump(touchPoint: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        crash.stopMoving()
    }
    
    func setupCamera() {
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    func moveCamera() {
        
        //let distance = sqrt(pow(crash.position.x - cameraNode.position.x, 2))
        
        // Set the camera's position to gradually follow the player
        let moveSpeed: CGFloat = 0.05 // Adjust this value for desired smoothness
        cameraNode.position.x += (crash.position.x - cameraNode.position.x) * moveSpeed
    }
    
    func getPhysicsContact(_ contact: SKPhysicsContact) -> [SKPhysicsBody] {
        var first : SKPhysicsBody
        var second : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            first = contact.bodyA
            second  = contact.bodyB
        }
        else {
            first = contact.bodyB
            second = contact.bodyA
        }
        
        return [first, second]
    }
}
