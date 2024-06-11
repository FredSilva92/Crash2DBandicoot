//
//  SceneElements.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 09/05/2024.
//

import Foundation

struct SceneElement {
    static let platform: Character = "p"
    static let wood: Character = "w"
    static let hole: Character = " "
    static let star: Character = "s"
    static let enemy: Character = "e"
    
    struct Names {
        static let platform = "Platform"
        static let wood = "WoodPath"
        static let star = "Star"
        static let spider = "Spider"
    }
    
    struct Hud {
        static let lives = "lives"
    }
}
