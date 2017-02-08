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
        case subNumber
        case subVariable
    }
    
    let BLOCKHEIGHT:CGFloat
    let BLOCKWIDTH:CGFloat
    
    //Type is either number or variable
    var type: BlockType
    var value: Double // Holds the value. I.e. in a 5x block, 5 is the value
    var label = SKLabelNode(fontNamed: "Arial")
    var innerBlockColor = SKSpriteNode()
    var subtractionBlock: Block?
    var parentBlock: Block?
    
    init(type: BlockType, size: CGSize) {
        self.type = type
        self.value = 1.0
        subtractionBlock = nil
        
        BLOCKHEIGHT = size.height
        BLOCKWIDTH = size.width
        
        switch self.type {
        case .number:
            super.init(texture: nil, color: .black, size: size)
            innerBlockColor = SKSpriteNode(texture: nil, color: .purple, size: size)
            label.text = String(value)
            label.fontSize = 20
        case .variable:
            super.init(texture: nil, color: .black, size:size)
            innerBlockColor = SKSpriteNode(texture: nil, color: .green, size: size)
            label.text = "x"
            label.fontSize = 20
        case .subNumber:
            super.init(texture: nil, color: .black, size:size)
            innerBlockColor = SKSpriteNode(texture: nil, color: .red, size: size)
            label.text = String(-1 * value)
            self.alpha = 0.40
            label.alpha = 1 / 0.40
            label.position = CGPoint(x: self.getWidth() / 6, y: -1 * self.getHeight() / 4)
            //Add the line for the subtraction block
            let line_path:CGMutablePath = CGMutablePath()
            line_path.move(to: CGPoint(x:self.getTopLeftX(), y:self.getTopLeftY() - self.getHeight()))
            line_path.addLine(to: CGPoint(x:self.getTopRightX(), y:self.getTopRightY()))
            let shape = SKShapeNode()
            shape.path = line_path
            shape.strokeColor = .red
            shape.lineWidth = 2
            shape.alpha = 1 / 0.40
            self.addChild(shape)
            label.fontSize = 15
        case .subVariable:
            super.init(texture: nil, color: .black, size:size)
            innerBlockColor = SKSpriteNode(texture: nil, color: .orange, size: size)
            label.text = "-x"
            self.alpha = 0.40
            label.alpha = 1 / 0.40
            label.position = CGPoint(x: self.getWidth() / 4, y: -1 * self.getHeight() / 4)
            //Add the line for the subtraction block
            let line_path:CGMutablePath = CGMutablePath()
            line_path.move(to: CGPoint(x:self.getTopLeftX(), y:self.getTopLeftY() - self.getHeight()))
            line_path.addLine(to: CGPoint(x:self.getTopRightX(), y:self.getTopRightY()))
            let shape = SKShapeNode()
            shape.path = line_path
            shape.strokeColor = .red
            shape.lineWidth = 2
            shape.alpha = 1 / 0.40
            self.addChild(shape)
            label.fontSize = 15
        }
        self.xScale = xScale
        innerBlockColor.xScale = CGFloat(1-1.5*(1/self.getWidth()))
        innerBlockColor.yScale = CGFloat(1-1.5*(1/self.getHeight()))
        
        // Add block color to be child of Block and set it to be 1 unit higher than its parent
        self.addChild(innerBlockColor)
        innerBlockColor.zPosition = 1
        
        //Set the look of the label and attach the label to this block 2 units higher than its parent
        label.fontColor = .black
        //?????
        label.xScale = 1 / xScale
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
    
    func getTopLeftY() -> Double{
        return Double(self.position.y) + Double(self.getHeight()) / 2
    }
    
    func getLabel() ->SKLabelNode{
        return self.label
    }
    
    func getBlockColorRectangle() ->SKSpriteNode{
        return self.innerBlockColor
    }
    
    func getType() -> String{
        //Not sure what this describing thing is, but it works
        return String(describing: self.type)
    }
    
    func setSubtractionBlock(block: Block?) {
        print("adding a child")
        self.subtractionBlock = block
        block?.position = CGPoint(x:((self.getWidth() / 2) - (block?.getWidth())! / 2) / Double(self.xScale), y:0)
        block?.xScale = (block?.xScale)! / self.xScale
        block?.zPosition = 3
        block?.removeFromParent()
        self.addChild((block)!)
    }
    
    func removeSubtractionBlock() {
        subtractionBlock?.removeFromParent()
        self.subtractionBlock = nil
        
    }
    
    func getSubtractionBlock() -> Block? {
        return self.subtractionBlock
    }

}
