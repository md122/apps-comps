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
    
    let BLOCKHEIGHT:CGFloat
    let BLOCKWIDTH:CGFloat
    
    //Type is either number or variable
    var type: BlockType
    var value: Double // Holds the value. I.e. in a 5x block, 5 is the value
    var label = SKLabelNode(fontNamed: "Arial")
    var innerBlockColor = SKSpriteNode()
    
    init(type: BlockType, size: CGSize) {
        self.type = type
        self.value = 1.0
        
        BLOCKHEIGHT = size.height
        BLOCKWIDTH = size.width
        
        switch self.type {
            case .number:
                super.init(texture: nil, color: .black, size: size)
                innerBlockColor = SKSpriteNode(texture: nil, color: .purple, size: size)
                label.text = String(value)
            case .variable:
                super.init(texture: nil, color: .black, size:size)
                innerBlockColor = SKSpriteNode(texture: nil, color: .green, size: size)
                label.text = "x"
        }
        innerBlockColor.xScale = CGFloat(1-1.5*(1/self.getWidth()))
        innerBlockColor.yScale = CGFloat(1-1.5*(1/self.getHeight()))
        
        // Add block color to be child of Block and set it to be 1 unit higher than its parent
        self.addChild(innerBlockColor)
        innerBlockColor.zPosition = 1
        
        //Set the look of the label and attach the label to this block 2 units higher than its parent
        label.fontSize = 20
        label.fontColor = .black
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
        return Double(BLOCKHEIGHT)
    }
    
    func getOriginalWidth() -> Double{
        return Double(BLOCKWIDTH)
    }
    
    //Changing width by scale factor so width returns the width of the bar after it's scaled
    func getWidth() -> Double{
        return Double(BLOCKWIDTH) * Double(self.xScale)
    }
    
    func getTopRightX() -> Double{
        return Double(self.position.x) + (self.getWidth()) / 2
    }
    
    func getTopRightY() -> Double{
        return (Double(self.position.y) + Double(self.getHeight()) / 2)
    }
    
    func getTopLeftX() -> Double{
        return Double(self.position.x) - Double(self.getWidth()) / 2
    }
    
    //I don't think this is currently used...
    func getTopLeftY() -> Double{
        return Double(self.position.y) - Double(self.getHeight()) / 2
    }
    
    func getLabel() ->SKLabelNode{
        return self.label
    }
    
    func getBlockColorRectangle() -> SKSpriteNode{
        return self.innerBlockColor
    }

}
