//
//  Block.swift
//  AppsComps
//
//  Created by Zoe Peterson on 11/11/16.
//  Copyright © 2016 appscomps. All rights reserved.
//

import UIKit
import SpriteKit

class Block: SKSpriteNode {
    
    enum BlockType {
        case number
        case variable
    }
    
    let BLOCKHEIGHT = 10
    let VARBLOCKWIDTH = 50
    let NUMBLOCKWIDTH = 20
    
    var type: BlockType
    var value: Double
    var label = SKLabelNode(fontNamed: "Arial")
    
    init(type: BlockType) {
        self.type = type
        self.value = 0.0
        super.init(texture: nil, color: .white, size: CGSize(width: NUMBLOCKWIDTH, height : BLOCKHEIGHT))
        
        switch self.type {
        case .number:
            self.color = .purple
        case .variable:
            self.color = .green
        }
        
        //Add the information to the label and attach the label to this block
        label.text = "YAY!!!"
        label.fontSize = 8
        label.position = CGPoint(x:self.position.x, y:self.position.y)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(value: Double) -> Void{
        self.value = value
    }
    
    func getValue() -> Double{
        return value
    }
    
    func getHeight() -> Int{
        return BLOCKHEIGHT
    }
    
    func getVarWidth() -> Int{
        return VARBLOCKWIDTH
    }
    
    func getNumWidth() -> Int{
        return NUMBLOCKWIDTH
    }
    
    func getLabel() ->SKLabelNode{
        return self.label
    }
}
