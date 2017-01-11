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
    
    let BLOCKHEIGHT = 10.0
    let VARBLOCKWIDTH = 50.0
    let NUMBLOCKWIDTH = 20.0
    
    //Type is either number or variable
    var type: BlockType
    var value: Double
    var label = SKLabelNode(fontNamed: "Arial")
    var innerBlockColor = SKSpriteNode()
    
    init(type: BlockType) {
        self.type = type
        self.value = 1.0
        
        switch self.type {
        case .number:
            super.init(texture: nil, color: .white, size: CGSize(width: NUMBLOCKWIDTH, height : BLOCKHEIGHT))
            self.color = .white
            innerBlockColor = SKSpriteNode(texture: nil, color: .white, size: CGSize(width: NUMBLOCKWIDTH, height : BLOCKHEIGHT))
            innerBlockColor.color = .purple
            label.text = String(value)
        case .variable:
            super.init(texture: nil, color: .white, size: CGSize(width: VARBLOCKWIDTH, height : BLOCKHEIGHT))
            self.color = .white
            innerBlockColor = SKSpriteNode(texture: nil, color: .white, size: CGSize(width: VARBLOCKWIDTH, height : BLOCKHEIGHT))
            innerBlockColor.color = .green
            label.text = "variable"
        }
        innerBlockColor.xScale = 0.9
        innerBlockColor.yScale = 0.9
        
        self.addChild(innerBlockColor)
        innerBlockColor.zPosition = 1
        
        //Set the look of the label and attach the label to this block
        label.fontSize = 6
        label.fontColor = .black
        label.position = CGPoint(x:self.position.x, y:self.position.y)
        self.addChild(label)
        label.zPosition = 2
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
    
    func getHeight() -> Double{
        return BLOCKHEIGHT
    }
    
    func getVarWidth() -> Double{
        return VARBLOCKWIDTH
    }
    
    func getNumWidth() -> Double{
        return NUMBLOCKWIDTH
    }
    
    func getWidth() -> Double{
        switch self.type {
        case .number:
            return Double(NUMBLOCKWIDTH) * self.value
        case .variable:
            return Double(VARBLOCKWIDTH)
        }
    }
    
    func getTopRightX() -> Double{
        return Double(self.position.x) + self.getWidth() / 2
        
    }
    
    func getTopRightY() -> Double{
        return Double(self.position.y) + self.getHeight() / 2
    }
    
    func getLabel() ->SKLabelNode{
        return self.label
    }
    
    func getBlockColorRectangle() ->SKSpriteNode{
        return self.innerBlockColor
    }

}
