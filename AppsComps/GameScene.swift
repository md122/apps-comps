//
//  GameScene.swift
//  GameTest
//
//  Created by Zoe Peterson on 10/29/16.
//  Copyright © 2016 Zoe Peterson. All rights reserved.
//  Blocks moving based on tutorial https://www.raywenderlich.com/123393/how-to-create-a-breakout-game-with-sprite-kit-and-swift

// Creates blocks ever time a block is let go at a position greater than (200, 200). Doesn't yet snap back to original location of the block is not drag the block back to the original space.

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    // Makes the blocks stack in the correct order
    // Based on the order they were last touched
    // Value incremented every time a block is touched
    var currentBlockZ : CGFloat = 1.0
    
    var topBar = [Block]()
    var bottomBar = [Block]()
    
    // The starting coordinates
    let BARX = 100
    let TOPBARY = 300
    let BOTTOMBARY = 220
    let NUMBLOCKBANKPOSITION = CGPoint(x:100, y:100)
    let VARBLOCKBANKPOSITION = CGPoint(x:200, y:100)
    
    // not implemented
    var isSorted = false
    
    // Set as the block that is touched so that
    // in touchesMoved, the block will move
    // If no block is touched, stays nil
    var blockTouched:Block? = nil
    
    // The block in the bank
    var numBlockInBank = Block(type:.number)
    var varBlockInBank = Block(type: .variable)

    func addBlockChild(_ node: SKNode) {
        node.zPosition = CGFloat(currentBlockZ)
        currentBlockZ += 3
        super.addChild(node)
    }
    
    
    // Called immediately after a scene is loaded
    // Sets the layout of all components in the problem screen
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        
        let garbage = SKSpriteNode(imageNamed: "garbage.png")
        garbage.position = CGPoint(x: 500, y: 500)
        garbage.size = CGSize(width: 100, height: 120)
        self.addChild(garbage)
        
        //Add the original block in the number block bank and the variable block bank
        numBlockInBank.position = NUMBLOCKBANKPOSITION
        self.addBlockChild(numBlockInBank)
        
        varBlockInBank.position = VARBLOCKBANKPOSITION
        self.addBlockChild(varBlockInBank)
        
        //These blocks are temporary to figure out adding to bars
        let topBarBlock = Block(type:.number)
        topBarBlock.position = CGPoint(x:CGFloat(BARX), y:CGFloat(TOPBARY))
        self.addBlockChild(topBarBlock)
        topBar.append(topBarBlock)
        
        let bottomBarBlock = Block(type:.variable)
        bottomBarBlock.position = CGPoint(x:CGFloat(BARX), y:CGFloat(BOTTOMBARY))
        self.addBlockChild(bottomBarBlock)
        bottomBar.append(bottomBarBlock)
    }
    
    func blockIsTouched(touchLocation: CGPoint, child: SKNode) -> Bool {
        if let block = child as? Block {
            return (block == self.atPoint(touchLocation) || block.getLabel() == self.atPoint(touchLocation) || block.getBlockColorRectangle() == self.atPoint(touchLocation))
        }
        return false
    }
    
    // Called when you touch the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        for child in self.children {
            if let block = child as? Block {
                if blockIsTouched(touchLocation: touchLocation, child: block) {
                    blockTouched = block
                    block.zPosition = currentBlockZ
                    currentBlockZ += 3
                }
            }
        }
    }
    
    // Called when you are moving your finger
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Check if a block is currently being touched
        if blockTouched != nil {
            
            //????
            //This is where to put stretching the blocks
            //????
            
            let block = blockTouched!
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self) // Is this necessary??
            
            // new x and y coordinates for the block
            var blockX = block.position.x + (touchLocation.x - previousLocation.x)
            var blockY = block.position.y + (touchLocation.y - previousLocation.y)
            
            //Bottom left is (0, 0)
            //Make sure the block doesn't go off screen
            //Not to far to the left
            blockX = max(blockX, block.frame.width/2)
            //Not to far to the right
            blockX = min(blockX, size.width - block.frame.width/2)
            //Not to far down
            blockY = max(blockY, block.frame.height/2)
            //Not to far up
            blockY = min(blockY, size.height - block.frame.height/2)
            block.position = CGPoint(x:blockX, y:blockY)
        }
    }
    
    func tryToInsertBlockInBar(bar: [Block], block: Block) -> Int {
        // We are going to align with the upper left corner
        let blockTopLeftX = Double(block.position.x) - block.getWidth() / 2
        
        //Go through blocks in topbar from left to right. Once we find one that our block is close too we add it and shift the rest of the blocks over by its width
        var added = false
        var insertionIndex = 0
        
        for i in 0...(bar.count - 1) {
            let blocki = bar[i]
            //We have added a block before this block and need to shift this block over
            if added == true {
                blocki.position = CGPoint(x:(blocki.position.x + CGFloat(block.getWidth())), y:(blocki.position.y))
            }
                //Case where we haven't added the block yet
            else {
                //If the block we are dragging is close enough to a block already in a bar add it
                if abs(blocki.getTopRightX() - blockTopLeftX) < 3 {
                    block.position = CGPoint(x:(blocki.getTopRightX() + block.getWidth() / 2), y:(blocki.getTopRightY() - block.getHeight() / 2))
                    added = true
                    //Insert this block after the block it lines up with
                    insertionIndex = i + 1
                }
            }
        }
        
        //We do not mutate the top bar list until all items have been shifted over
        if (added == true) {
            return insertionIndex
        }
        
        return -1
    }
    
    // Called when you lift up your finger
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if blockTouched != nil {
            
            //????
            //Check to see if the block is in a list? If it is remove it and move everyone over. Or is this too much work???
            //????
            
            let block = blockTouched!
            

            // Are you dragging a block to a top bar? To a bottom bar? If so, insert it into bar and shift over the other blocks
            if abs(Double(TOPBARY) - Double(block.position.y)) < 3 {
                let insertionIndex = tryToInsertBlockInBar(bar: topBar, block: block)
                if insertionIndex > -1 {
                    topBar.insert(block, at:insertionIndex)
                }
            } else if abs(Double(BOTTOMBARY) - Double(block.position.y)) < 3 {
                let insertionIndex = tryToInsertBlockInBar(bar: bottomBar, block: block)
                if insertionIndex > -1 {
                    bottomBar.insert(block, at:insertionIndex)
                }
            }
            
            // Are you dragging a block from the number bank? If you moved it "far enough", repopulate the numBlockBank. 
            // If not, put the block back where it came from
            if (block == numBlockInBank) {
                //Block has moved outside of block bank
                if (abs(block.position.x - NUMBLOCKBANKPOSITION.x) > CGFloat(block.getNumWidth()) || abs(block.position.y - NUMBLOCKBANKPOSITION.y) > CGFloat(block.getHeight())) {
                    let newBlock = Block(type: .number)
                    newBlock.position = NUMBLOCKBANKPOSITION
                    numBlockInBank = newBlock
                    self.addBlockChild(newBlock)
                }
                else {
                    block.position = NUMBLOCKBANKPOSITION
                }
            }
            
            // Are you dragging a block from the variable bank? If you moved it "far enough", repopulate the varBlockBank.
            // If not, put the block back where it came from
            if (block == varBlockInBank) {
                //Block has moved outside of block bank
                if (abs(block.position.x - VARBLOCKBANKPOSITION.x) > CGFloat(block.getVarWidth()) || abs(block.position.y - VARBLOCKBANKPOSITION.y) > CGFloat(block.getHeight())) {
                    let newBlock = Block(type: .variable)
                    newBlock.position = VARBLOCKBANKPOSITION
                    varBlockInBank = newBlock
                    self.addBlockChild(newBlock)
                }
                else {
                    block.position = VARBLOCKBANKPOSITION
                }
            }
            
            blockTouched = nil
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}

