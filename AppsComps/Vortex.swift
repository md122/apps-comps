//
//  Hammer.swift
//
//
//  Created by Zoe Peterson on 2/7/17.
//
//
import UIKit
import SpriteKit

class Vortex: Block {
    init() {
        let texture = SKTexture(imageNamed: "vortex")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
