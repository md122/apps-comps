//
//  ButtonNode.swift
//  AppsComps
//
//  Created by Meg Crenshaw on 1/29/17.
//  Copyright © 2017 appscomps. All rights reserved.
// from: https://www.raywenderlich.com/87873/make-game-like-candy-crush-tutorial-os-x-port

import SpriteKit

class ButtonNode: SKSpriteNode {
    
    var action: ((ButtonNode) -> Void)?
    
    var isSelected: Bool = false {
        didSet {
            alpha = isSelected ? 0.8 : 1
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
    }
    
    func userInteractionBegan(event: UITouch) {
        isSelected = true
    }
    
    func userInteractionContinued(event: UITouch) {
        let location = event.location(in: parent!)
        
        if frame.contains(location) {
            isSelected = true
        } else {
            isSelected = false
        }
    }
    
    func userInteractionEnded(event: UITouch) {
        isSelected = false
        
        let location = event.location(in: parent!)
        
        if frame.contains(location) {
            // 7
            action?(self)
        }
    }
}
