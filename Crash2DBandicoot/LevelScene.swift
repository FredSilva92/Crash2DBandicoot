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
    internal var crash: CrashBandicoot
    private var deathThreshold: CGFloat = 0.0
    private var ratio = 0.0
    
    override init(size : CGSize) {
        
        // Get device screen size
        let screenSize = UIScreen.main.bounds.size
        
        // Calculate aspect ratio
        let aspectRatio = screenSize.width / screenSize.height
        
        // Set base aspect ratio (you can adjust this according to your game)
        let baseAspectRatio: CGFloat = 16.0 / 9.0
        
        // Calculate scene size based on device aspect ratio
        var sceneSize: CGSize
        if aspectRatio > baseAspectRatio {
            sceneSize = CGSize(width: screenSize.height * baseAspectRatio, height: screenSize.height)
        } else {
            sceneSize = CGSize(width: screenSize.width, height: screenSize.width / baseAspectRatio)
        }
        
        ratio = sceneSize.width / 12
        crash = CrashBandicoot(position: CGPoint(x: screenSize.width/2, y: sceneSize.height/3), sceneSize: sceneSize);
        super.init(size: sceneSize)
        
        scaleMode = .aspectFill
        self.anchorPoint = CGPoint(x: 0, y: 0)

        
        print("Size1:" +  String(Float(self.size.width)) + " " + String(Float(self.size.width)))
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -10.0)
        self.physicsWorld.contactDelegate = self
        
        bg.zPosition = -1
        bg.size = sceneSize
        addChild(bg)
        
        deathThreshold = 0.0
        setupCamera()
        
        buildLevel(levelFile: "Level1")

    }
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
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
            
            let resetCrash = SKAction.run {
                self.crash.isDead = false
                self.crash.reset()
            }
            
            execActions(actionsToPass: [SKAction.wait(forDuration: 1.5), resetCrash])
            
            return
        }

        
        bg.position = CGPoint(x: cameraNode.position.x, y: cameraNode.position.y)
        crash.update()
        moveCamera()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)
            crash.run(loc: location)
            if (location.y > self.size.height/2) {
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
        let moveSpeed: CGFloat = 0.05
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
    
    func buildLevel(levelFile: String) {
        guard let levelURL = Bundle.main.url(forResource: levelFile, withExtension: ".txt") else {return}
        guard let levelString = try? String(contentsOf: levelURL) else {return}
        let lines = levelString.components(separatedBy: "\n")
        var currentTileYPos = ratio
        
        for (_, line) in lines.reversed().enumerated() {
            
            if  line.isEmpty {
                continue
            }
            
            var currentTileXPos = 0.0
            
            for(_, letter) in line.enumerated() {
                currentTileXPos += ratio;
                
                if letter == SceneElement.platform {
                    let element = buildElement(assetName: "plainDirt2",
                                               name: "Ground",
                                               position: CGPoint(x: currentTileXPos, y: currentTileYPos))
                    
                    print("PLatfor size: " + String(Float(element.size.width)) + " " + String(Float(element.size.height)))
                    
                    element.physicsBody = SKPhysicsBody(rectangleOf: element.size)
                    element.physicsBody?.isDynamic = false
                    element.physicsBody?.affectedByGravity = false
                    
                    self.addChild(element)
                    
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
                    self.addChild(element)
                    
                    //scene.deathThreshold = min(scene.deathThreshold, -scene.frame.height/9)
                } else if letter == SceneElement.star {
                    
                    let element = buildElement(assetName: "star",
                                               name: "Star",
                                               position: CGPoint(x: currentTileXPos, y: currentTileYPos))
                    print()
                    print("Star size: " + String(Float(element.size.width)) + " " + String(Float(element.size.height)))
                    element.physicsBody = SKPhysicsBody(rectangleOf: element.size)
                    element.physicsBody?.isDynamic = false
                    element.physicsBody?.affectedByGravity = false
                    self.addChild(element)
                }
            }
            
            currentTileYPos += ratio
        }
    }
    
    func buildElement(assetName: String, name: String, position: CGPoint) -> SKSpriteNode {
        let element = SKSpriteNode(imageNamed: assetName)
        
        element.name = name
        element.position = position
        element.size = CGSize(width: ratio, height: ratio)
        element.zPosition = 1.0
        
        return element
    }
    
    func execActions(actionsToPass: [SKAction]) {
        
        let actions: [SKAction] = actionsToPass
        
        let sequence = SKAction.sequence(actionsToPass)
        run(SKAction.sequence(actions))
    }
}
