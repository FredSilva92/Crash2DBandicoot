//
//  MyExtensions.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 08/05/2024.
//

import Foundation
import SpriteKit

extension CGSize {
    static func * (size: CGSize, multiplier: CGFloat) -> CGSize {
        return CGSize(width: size.width * multiplier, height: size.height * multiplier)
    }

    static func / (size: CGSize, divisor: CGFloat) -> CGSize {
        guard divisor != 0 else { return size }
        return CGSize(width: size.width / divisor, height: size.height / divisor)
    }
}

extension CGPoint {
    static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        let epsilon: CGFloat = 0.1 // Adjust epsilon as needed
        return abs(lhs.x - rhs.x) < epsilon && abs(lhs.y - rhs.y) < epsilon
    }
    
    static func != (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return !(lhs == rhs)
    }
}

extension SKSpriteNode {
    
    
    func runAnimation(animations: [String:SKAction], key: String, repeatAction: Bool = true) {
        let defaulAnimation = SKAction.moveBy(x: 0, y: 0, duration: 1.0)
        let action = (animations[key]) ?? defaulAnimation
        
        removeAllActions()
        
        if repeatAction {
            run(SKAction.repeatForever(action), withKey: key)
        } else {
            run(action, withKey: key)
        }
        
    }
}
