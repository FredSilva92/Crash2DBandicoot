//
//  BitMaskCategory.swift
//  Crash2DBandicoot
//
//  Created by Frederico Silva on 08/05/2024.
//

import Foundation

struct BitMaskCategory {
    static let none : UInt32 = 0
    static let all : UInt32 = UInt32.max
    static let rollingStoneMovePoint: UInt32 = 0b1
    static let rollingStone: UInt32 = 0b10
    static let woodPath: UInt32 = 0b110
    static let crash: UInt32 = 0b111
}
