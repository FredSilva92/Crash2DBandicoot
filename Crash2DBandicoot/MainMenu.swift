//
//  MainMenu.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 18/05/2024.
//

import Foundation
import SpriteKit
import AVFoundation

class MainMenu: SKScene {
    
    private var audioPlayer: AVAudioPlayer?
    
    override init(size : CGSize) {
        
        let sceneSize = Utils.getAspectRatio(screenSize: UIScreen.main.bounds.size)
        
        super.init(size: sceneSize)
        
        let borderNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: sceneSize.width*10, height: sceneSize.height*10)), cornerRadius: 10)
        
        borderNode.fillColor = .systemGreen
        addChild(borderNode)
        
        // Set up label
        let iCrashText = SKLabelNode(text: "ICrash")
        iCrashText.fontName = "Arial"
        iCrashText.fontSize = 30
        iCrashText.fontColor = UIColor.white
        iCrashText.position = CGPoint(x: sceneSize.width/2, y: sceneSize.height / 1.5)
        borderNode.addChild(iCrashText)
        
        let playPos = CGPoint(x: sceneSize.width/2, y: sceneSize.height/2)
        let btnSize = CGSize(width: 100, height: 40)
        
        let playBtn = ButtonNode(name: "play", size: btnSize, position: playPos)
        playBtn.action = { (touches: Set<UITouch>) in
            
            self.audioPlayer?.stop()
            
            self.run(SKAction.sequence([
                SKAction.wait(forDuration: 1),
                SKAction.run {
                    let reveal = SKTransition.flipVertical(withDuration: 0.5)
                    let level1 = Level1(size: self.size, lives: 3)
                    self.view?.presentScene(level1, transition: reveal)
                }
            ]))
        }
        borderNode.addChild(playBtn)
        
        let creditsPos = CGPoint(x: sceneSize.width/2, y: sceneSize.height/3);
        let creditsBtn = ButtonNode(name: "credits", size: btnSize, position: creditsPos);
        
        creditsBtn.action = {(touches: Set<UITouch>) in
            self.goToCredits()
        }
        borderNode.addChild(creditsBtn)
        
        if let soundURL = Bundle.main.url(forResource: "MainMenu", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error: Could not find or play the sound file.")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goToCredits() {
        
        let screenSize = UIScreen.main.bounds.size
        let sceneSize = self.size
        
        var borderNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: sceneSize.width*10, height: sceneSize.height*10)), cornerRadius: 10)
        
        borderNode.fillColor = .systemGreen
        borderNode.zPosition = 2
        addChild(borderNode)
        
        let closePos = CGPoint(x: 40, y: screenSize.height / 1.1)
        let closeBtn = ButtonNode(name: "close", size: CGSize(width: 25, height: 25), position: closePos)
        closeBtn.action = { (touches: Set<UITouch>) in
            borderNode.removeFromParent()
        }
        //borderNode.zPosition = 3
        borderNode.addChild(closeBtn)
        
        let creditsText = "Pedro Frederico Silva a20721\nJosé Pedro Lourenço a23496"
        
        let creditsNode = SKLabelNode(text: creditsText)
        creditsNode.fontName = "Arial"
        creditsNode.fontSize = 20
        creditsNode.numberOfLines = 0
        creditsNode.fontColor = UIColor.white
        //creditsNode.horizontalAlignmentMode = .center
        //creditsNode.verticalAlignmentMode = .top
        creditsNode.position = CGPoint(x: sceneSize.width/2, y: sceneSize.height/2)
        borderNode.addChild(creditsNode)
    }
}
