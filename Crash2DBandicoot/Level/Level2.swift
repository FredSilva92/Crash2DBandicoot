//
//  Level2.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 10/05/2024.
//

import SpriteKit
import GameplayKit

class Level2: LevelScene {
    
    override init(size: CGSize){
        super.init(size: size)
        
        buildLevel(levelFile: "Level2")
        
        addChild(crash)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let spiders = getNodes(withName: "Spider", ofType: Spider.self)
        
        for spider in spiders {
            spider.update()
        }
    }
}
