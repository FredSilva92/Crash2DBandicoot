//
//  LevelScene.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 11/05/2024.
//

import SpriteKit
import GameplayKit
import AVFoundation

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
    internal var deathThreshold: CGFloat = 0.0
    private var ratio = 0.0
    private var hudNode: SKNode
    private var isGamePaused = false
    internal var audioPlayer: AVAudioPlayer?
    
    init(size : CGSize, lives: Int) {
        
        let sceneSize = Utils.getAspectRatio(screenSize: UIScreen.main.bounds.size)
        
        ratio = sceneSize.width / 12
        crash = CrashBandicoot(position: CGPoint(x: sceneSize.width/2, y: sceneSize.height/3),
                               sceneSize: sceneSize,
                               lives: lives);
        
        hudNode = SKNode()
        hudNode.zPosition = 10000
        
        super.init(size: sceneSize)
        
        scaleMode = .aspectFill
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -10.0)
        
        bg.zPosition = -1
        bg.size = sceneSize
        addChild(bg)
        
        deathThreshold = 0.0
        setupCamera()
        
        setupHud(screenSize: sceneSize)
        
        audioPlayer = Utils.getSoundEffect(name: "LevelSound", ext: "mp3")
        audioPlayer?.volume = 0.25
        audioPlayer?.play()
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
        
        setPausedElements(paused: isGamePaused)
        
        if isGamePaused {
            return
        }
        
        lastUpdateTime = currentTime
        
        if (crash.position.y < deathThreshold && !crash.isDead) {
            onDead()
            return
        }

        bg.position = CGPoint(x: cameraNode.position.x, y: cameraNode.position.y)
        crash.update()
        moveCamera()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (crash.isDead) {return}

        for touch in touches {
            let location = touch.location(in: self)
            
            if isGamePaused {
                return
            }
            
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
        cameraNode.addChild(hudNode)
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
            
            if line.isEmpty {
                continue
            }
            
            var currentTileXPos = 0.0
            
            for(_, letter) in line.enumerated() {
                
                currentTileXPos += ratio;
                let pos =  CGPoint(x: currentTileXPos, y: currentTileYPos);
                
                if letter == SceneElement.platform {
                    
                    let element = GameElement(imageNamed: "Ground",
                                              name: SceneElement.Names.platform,
                                              initialPosition: pos,
                                              ratio: ratio)
                    
                    self.addChild(element)
                    
                } else if letter == SceneElement.wood {
                    
                    let element = GameElement(imageNamed: "Wood",
                                              name: SceneElement.Names.wood,
                                              initialPosition: pos,
                                              ratio: ratio)
                    
                    element.physicsBody?.categoryBitMask = BitMaskCategory.woodPath
                    element.physicsBody?.contactTestBitMask = BitMaskCategory.rollingStone
                    self.addChild(element)
                    
                } else if letter == SceneElement.star {
                    
                    let element = GameElement(imageNamed: "star",
                                              name: SceneElement.Names.star,
                                              initialPosition: pos,
                                              ratio: ratio)
                    
                    element.physicsBody = SKPhysicsBody(rectangleOf: element.size/4)
                    element.physicsBody?.isDynamic = false
                    element.physicsBody?.affectedByGravity = false
                    element.physicsBody?.categoryBitMask = BitMaskCategory.star
                    element.physicsBody?.contactTestBitMask = BitMaskCategory.crash
                    
                    self.addChild(element)
                    
                } else if letter == SceneElement.enemy {
                    let spider = Spider(initialPos: pos)
                    spider.size = CGSize(width: ratio, height: ratio)
                    addChild(spider)
                }
            }
            
            currentTileYPos += ratio
        }
    }
    
    func execActions(actionsToPass: [SKAction]) {
        run(SKAction.sequence(actionsToPass))
    }
    
    func onDead() {
        
        let resetCrash = crash.getDeathAction()
        
        
        if let specificNode = Utils.getChildNode(named: SceneElement.Hud.lives, in: hudNode) as? SKLabelNode {
            // Now you can use specificNode as an SKLabelNode
            specificNode.text = String(self.crash.lives)
        }
        
        execActions(actionsToPass: [SKAction.wait(forDuration: 1.5), resetCrash])
        
        if crash.lives == 0 {

            
            execActions(actionsToPass: [SKAction.run{
                let GameOverScreen = ScreenOverlay(labelText: "Game over", layoutName: "GameOverLayout")
                self.isGamePaused = true
                self.audioPlayer?.stop()
                
                self.hudNode.addChild(GameOverScreen)
            },
            SKAction.wait(forDuration: 2),
            SKAction.run {
                let reveal = SKTransition.flipVertical(withDuration: 0.5)
                let scene = MainMenu(size: self.size)
                self.view?.presentScene(scene, transition: reveal)
            }])
        }
    }
    
    func pauseGame() {
         isGamePaused = true
        audioPlayer?.pause()
        
        let screenSize = UIScreen.main.bounds.size
        let buttonPausePos = CGPoint(x: 0, y: 0)
        let pauseLabel = ButtonNode(size: CGSize(width: 90, height: 30), labelText: "Paused", position: buttonPausePos)
        pauseLabel.name = "pausedLabel"
        pauseLabel.action = { (touches: Set<UITouch>) in
            
            self.resumeGame()
            print("resume!")
        }
        
        var borderNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: -screenSize.width/2, y: -screenSize.height/2), size: CGSize(width: 2000, height: 3000)), cornerRadius: 10)
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        borderNode.fillColor = color
        borderNode.name = "pausedLayout"
        borderNode.addChild(pauseLabel)
        
        hudNode.addChild(borderNode)
     }
     
     func resumeGame() {
         isGamePaused = false
         audioPlayer?.play()
         
         hudNode.enumerateChildNodes(withName: "pausedLayout") { node, _ in
             node.removeFromParent()
         }
     }
    
    func setPausedElements(paused: Bool) {
        crash.isPaused = paused
        self.physicsWorld.speed = isGamePaused ? 0 : 1
        
        hudNode.enumerateChildNodes(withName: "AttackBtn") { node, _ in
            node.isHidden = paused
        }
        
        hudNode.enumerateChildNodes(withName: "PauseBtn") { node, _ in
            node.isHidden = paused
        }
    }
    
    
    func getNodes<T>(withName name: String, ofType type: T.Type) -> [T] {
        var nodesOfType = [T]()
        for child in self.children {
            if let namedNode = child as? T, child.name == name {
                nodesOfType.append(namedNode)
            }
        }
        return nodesOfType
    }
    
    func setupHud(screenSize: CGSize) {
        let buttonSize = CGSize(width: 90, height: 30)
        
        let buttonAttackPos = CGPoint(x: screenSize.width/5.5, y: -screenSize.height/6)
        let buttonAttack = ButtonNode(size: buttonSize, labelText: "Attack", position: buttonAttackPos)
        buttonAttack.name = "AttackBtn"

        buttonAttack.action = {(touches: Set<UITouch>) in
            if self.isGamePaused {
                return
            }
            // Add action here
            self.crash.attack()
            print("Attack!")
        }
        
        let buttonPausePos = CGPoint(x: -screenSize.width/4.5, y: screenSize.height/5.5)
        let buttonPause = ButtonNode(size: buttonSize, labelText: "Pause", position: buttonPausePos)
        buttonPause.name = "PauseBtn"
        
        buttonPause.action = { (touches: Set<UITouch>) in
            // Add action here
            
            if(!self.isGamePaused) {
                self.pauseGame()
            }
            print("Pause!")
        }
        
        let liveNode = SKNode()
        liveNode.position = CGPoint(x: screenSize.width/2.5, y: screenSize.height/3)
        
        let texture = SKTexture(imageNamed: "CrashLife")
        let liveIcon = SKSpriteNode(texture: texture)
        liveNode.addChild(liveIcon)
        
        let liveValue = SKLabelNode(text: String(crash.lives))
        liveValue.fontName = "CrashFont"
        liveValue.fontSize = 20
        liveValue.fontColor = UIColor.white
        liveValue.name = SceneElement.Hud.lives
        liveValue.position = CGPoint(x: texture.size().width/1.5, y: -texture.size().height/2.5)
        liveNode.addChild(liveValue)
        
        
        hudNode.addChild(buttonPause)
        hudNode.addChild(buttonAttack)
        hudNode.addChild(liveNode)
    }
    
    func loadingScreen() {
        
        isGamePaused = true
        let loadingScreen = ScreenOverlay(labelText: "Loading...", layoutName: "loadingLayout")
        
        hudNode.addChild(loadingScreen)
    }
}
