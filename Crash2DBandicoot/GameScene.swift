//
//  GameScene.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 16/04/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var dt: TimeInterval = 0.0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var cameraMovePointPerSecond: CGFloat = 450.0
    private var cameraNode = SKCameraNode()
    private var bg = SKSpriteNode(imageNamed: "ForestBg")
    private var crash: CrashBandicoot = CrashBandicoot(position: CGPoint(x: 0.0, y: 0.0));
    private var rollingStone: RollingStone = RollingStone()
    private var deathThreshold: CGFloat = 0.0
    
    override func sceneDidLoad() {
    
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -10.0)
        self.physicsWorld.contactDelegate = self
        
        crash = CrashBandicoot(position: CGPoint(x: 0.0, y: -frame.height/18));
        
        bg.zPosition = -1
        //bg.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(bg)
        
        var currentTilePos = -100.0;
        
        for i in 0...100 {
            
            if(i == 15 ) {
                currentTilePos += 80
                continue
            }
            
            var ground: SKSpriteNode
            if (i > 20 && i < 27) {
                ground = SKSpriteNode(imageNamed: "plainDirt0")
                currentTilePos += ground.size.width;
                
                ground.name = "WoodPath"
                ground.position = CGPoint(x: currentTilePos, y: -frame.height/9)
                //ground.size = CGSize(width: ground.frame.width/2, height: ground.frame.height/2)
                ground.zPosition = 1.0
                ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
                ground.physicsBody?.isDynamic = false
                ground.physicsBody?.affectedByGravity = false
                ground.physicsBody?.categoryBitMask = BitMaskCategory.woodPath
                ground.physicsBody?.contactTestBitMask = BitMaskCategory.rollingStone
                
                deathThreshold = min(deathThreshold, -frame.height/9)
            } else {
                ground = SKSpriteNode(imageNamed: "plainDirt2")
                currentTilePos += ground.size.width;
                
                ground.name = "Ground"
                ground.position = CGPoint(x: currentTilePos, y: -frame.height/9)
                //ground.size = CGSize(width: ground.frame.width/2, height: ground.frame.height/2)
                ground.zPosition = 1.0
                ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
                ground.physicsBody?.isDynamic = false
                ground.physicsBody?.affectedByGravity = false
                
                deathThreshold = min(deathThreshold, -frame.height/9)
            }
            
            addChild(ground)
        }
        
        
        addChild(crash)
        addChild(rollingStone)
        
        var a = CGPoint(x: rollingStone.position.x + 200, y: 0)
        var startRStoneCollider: InvislbleCollider = InvislbleCollider(point: a)
        //addChild(startRStoneCollider)
        
        setupCamera()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
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
        
        if(first.categoryBitMask == BitMaskCategory.rollingStoneMovePoint &&
           second.categoryBitMask == BitMaskCategory.crash) {
            
            for childNode in self.children {
                if let physicsBody = childNode.physicsBody {
                    // Check if the physics body's category bitmask matches the bitmask we're interested in
                    if physicsBody.categoryBitMask == BitMaskCategory.rollingStoneMovePoint {
                        // This child node matches the bitmask we're looking for
                        // Remove the child node from the scene
                        childNode.removeFromParent()
                        print("Removed child node with the desired category bitmask")
                        break // Exit loop since we found and removed the child node
                    }
                }
            }
            
            rollingStone.run()
        }
        
        if (first.categoryBitMask == BitMaskCategory.rollingStone &&
            second.categoryBitMask == BitMaskCategory.crash) {
            //crash.sprite.removeFromParent()
        }
        
        if (first.categoryBitMask == BitMaskCategory.rollingStone &&
            second.categoryBitMask == BitMaskCategory.woodPath) {
            second.isDynamic = true
            second.affectedByGravity = true
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if crash.position.y < deathThreshold {
            let otherAction = SKAction.run {
                // Code to execute after the delay
                self.crash.reset()
                print("Delayed action executed")
            }

            // Combine the delay action with the action to perform
            let sequence = SKAction.sequence([SKAction.wait(forDuration: 1.5), otherAction])

            // Run the sequence on a node (for example, the scene's root node)
            run(sequence)
            
            return
        }
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        bg.position = CGPoint(x: cameraNode.position.x, y: cameraNode.position.y)
        crash.update()
        rollingStone.update()
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
        
        let distance = sqrt(pow(crash.position.x - cameraNode.position.x, 2))
        
        // Set the camera's position to gradually follow the player
        let moveSpeed: CGFloat = 0.05 // Adjust this value for desired smoothness
        cameraNode.position.x += (crash.position.x - cameraNode.position.x) * moveSpeed
    }
}
