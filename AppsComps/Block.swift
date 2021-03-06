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
        case vortex
    }
    
    let BLOCKHEIGHT:CGFloat
    let BLOCKWIDTH:CGFloat
    
    //Type is one of the enum values for BlockType
    var type: BlockType
    var value: String // Holds the value. I.e. in a 5x block, 5 is the value
    var label = SKLabelNode(fontNamed: "Arial")
    var innerBlockColor = SKSpriteNode()
    var subtractionBlock: Block?
    var parentBlock: Block?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        BLOCKHEIGHT = 1
        BLOCKWIDTH = 1
        self.type = .vortex
        self.value = "1"
        super.init(texture: texture, color: color, size: size)
    }
    
    init(type: BlockType, size: CGSize, value: String) {
        var blockSize = CGSize(width: size.width, height: size.height)
        self.type = type
        self.value = value
        subtractionBlock = nil
        
        BLOCKHEIGHT = blockSize.height
        if type == .variable || type == .subVariable {
            BLOCKWIDTH = blockSize.width * CGFloat(abs(Double(value)!))
        }
        else {
             BLOCKWIDTH = blockSize.width
        }
    
        switch self.type {
        case .number:
            let numberColor = UIColor(hexString: "#00A1E4")
            super.init(texture: nil, color: .black, size: size)
            innerBlockColor = SKSpriteNode(texture: nil, color: numberColor, size: size)
            label.text = getValueString()
            label.fontSize = 18
        case .variable:
            let variableColor = UIColor(hexString: "#89fc00")
            blockSize = CGSize(width: BLOCKWIDTH, height: BLOCKHEIGHT)
            super.init(texture: nil, color: .black, size:blockSize)
            innerBlockColor = SKSpriteNode(texture: nil, color: variableColor, size: blockSize)
            if self.value == "1" {
                label.text = "x"
            }
            else {
                label.text = getValueString() + "x"
            }
            label.fontSize = 18
        case .subNumber:
            super.init(texture: nil, color: .white, size:blockSize)
            innerBlockColor = SKSpriteNode(texture: nil, color: .red, size: blockSize)
            label.text = String(value)
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
            label.fontSize = 18
        case .subVariable:
            blockSize = CGSize(width: BLOCKWIDTH, height: BLOCKHEIGHT)
            super.init(texture: nil, color: .white, size:blockSize)
            innerBlockColor = SKSpriteNode(texture: nil, color: .orange, size: blockSize)
            if self.value=="-1" {
                label.text = "-x"
            }
            else {
                label.text = String(self.value) + "x"
            }
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
            label.fontSize = 18
        //This should never get called
        case .vortex:
            self.type = .vortex
            self.value = "1"
            subtractionBlock = nil
            super.init(texture: nil, color: .black, size:blockSize)
        }
        
        //self.xScale = xScale
        innerBlockColor.xScale = CGFloat(1-1.5*(1/self.getWidth()))
        innerBlockColor.yScale = CGFloat(1-1.5*(1/self.getHeight()))
        
        // Add block color to be child of Block and set it to be 1 unit higher than its parent
        self.addChild(innerBlockColor)
        innerBlockColor.zPosition = 1
        
        //Set the look of the label and attach the label to this block 2 units higher than its parent
        label.fontColor = .black
        self.addChild(label)
        label.xScale = 1 / self.xScale
        label.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(value: String) -> Void{
        self.value = value
        self.label.text = value
    }
    
    func getValue() -> Double{
        return Double(value)!
    }
    
    func getValueString() -> String {
        return self.value
    }
    
    func getHeight() -> Double{
        return Double(BLOCKHEIGHT)
    }
    //Changing width by scale factor so width returns the width of the bar after it's scaled
    func getWidth() -> Double{
        return Double(BLOCKWIDTH) * Double(self.xScale)
        
    }
    
    func getOriginalWidth() -> Double{
        return Double(BLOCKWIDTH)
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
    
    func getBlockColorRectangle() -> SKSpriteNode{
        return self.innerBlockColor
    }
    
    func getType() -> String{
        //Not sure what this describing thing is, but it works
        return String(describing: self.type)
    }
    
    //Sets the subtraction block as the child of this current block. Also does the scaling to move the subtraction block into the world of this block and have it look the same to the user
    func setSubtractionBlock(block: Block?) {
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
