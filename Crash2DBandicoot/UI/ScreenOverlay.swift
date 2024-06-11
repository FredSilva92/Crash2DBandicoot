//
//  ScreenOverlay.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 31/05/2024.
//

import Foundation
import SpriteKit

class ScreenOverlay : SKShapeNode {
    
    init(labelText: String, layoutName: String) {
        let screenSize = UIScreen.main.bounds.size
        let textPos = CGPoint(x: -20, y: 10)
        let labelNode = ButtonNode(size: CGSize(width: 90, height: 30), labelText: labelText, position: textPos)
        
        let rect = CGRect(origin: CGPoint(x: -screenSize.width/2, y: -screenSize.height/2), size: CGSize(width: 2000, height: 3000))
        super.init()
        self.path = CGPath(rect: rect, transform: nil)
        
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.fillColor = color
        self.name = layoutName
        self.addChild(labelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
