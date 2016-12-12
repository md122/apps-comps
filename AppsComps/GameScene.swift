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
    
    var topBar = [Block]()
    var bottomBar = [Block]()
    let BARX = 100
    let TOPBARY = 300
    let BOTTOMBARY = 220
    
    var isSorted = false
    var blockTouched:Block? = nil
    
    var numBlockInBank = Block(type:.number)
    var varBlockInBank = Block(type: .variable)
    var numBlockBankPosition = CGPoint(x:100, y:100)
    var varBlockBankPosition = CGPoint(x:200, y:100)
    
    //Called immediately after a scene is presented by a view
    override func didMove(to view: SKView) {
        //Add the original block in the number block bank and the variable block bank
        numBlockInBank.position = numBlockBankPosition
        self.addChild(numBlockInBank)
        
        varBlockInBank.position = varBlockBankPosition
        self.addChild(varBlockInBank)
        
        
        
        //These blocks are temporary to figure out adding to bars
        var topBarBlock = Block(type:.number)
        topBarBlock.position = CGPoint(x:CGFloat(BARX), y:CGFloat(TOPBARY))
        self.addChild(topBarBlock)
        topBar.append(topBarBlock)
        
        var bottomBarBlock = Block(type:.variable)
        bottomBarBlock.position = CGPoint(x:CGFloat(BARX), y:CGFloat(BOTTOMBARY))
        self.addChild(bottomBarBlock)
        bottomBar.append(bottomBarBlock)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        for child in self.children {
            if let block = child as? Block {
                if block == self.atPoint(touchLocation) || block.getLabel() == self.atPoint(touchLocation) {
                    blockTouched = block
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Check if the block is currently being touched
        if blockTouched != nil {
            
            //????
            //Check to see if the block is in a list? If it is remove it and move everyone over. Or is this too much work???
            //????
            
            let block = blockTouched!
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if blockTouched != nil {
            let block = blockTouched!
            
            //Check to see if the block is close enough to snap into the bar
            //We are going to allign with the upper left corner
            let blockTopLeftX = Double(block.position.x) - block.getWidth() / 2
            let blockTopLeftY = Double(block.position.y) + block.getHeight() / 2
            
            
            
            //We do this checking think exactly the same for each bar. Should this be a function? Or is there some other way to avoid this repeated code???
            
            
            //Go through blocks in topbar from left to right. Once we find one that our block is close too we add it and shift the rest of the blocks over by its width
            var added = false
            var insertionIndex = 0
            //Set the number of times to loop before in case it changes by adding a block
            for i in 0...(topBar.count - 1) {
                let topBarBlocki = topBar[i]
                //We have added a block before this block and need to shift this block over
                if added == true {
                    topBarBlocki.position = CGPoint(x:(topBarBlocki.position.x + CGFloat(block.getWidth())), y:(topBarBlocki.position.y))
                }
                //Case where we haven't added the block yet
                else {
                    //If the block we are dragging is close enough to a block already in a bar add it
                    if abs(topBarBlocki.getTopRightX() - blockTopLeftX) < 3 && abs(topBarBlocki.getTopRightY() - blockTopLeftY) < 3 {
                        block.position = CGPoint(x:(topBarBlocki.getTopRightX() + block.getWidth() / 2), y:(topBarBlocki.getTopRightY() - block.getHeight() / 2))
                        added = true
                        //Insert this block after the block it lines up with
                        insertionIndex = i + 1
                    }
                }
            }
            
            //We do not mutate the top bar list until all items have been shifted over
            if (added == true) {
                topBar.insert(block, at:insertionIndex)
            }
            
            //Go through blocks in bottombar from left to right. Once we find one that our block is close too we add it and shift the rest of the blocks over by its width
            added = false
            insertionIndex = 0
            //Set the number of times to loop before in case it changes by adding a block
            for i in 0...(bottomBar.count - 1) {
                let bottomBarBlocki = bottomBar[i]
                //We have added a block before this block and need to shift this block over
                if added == true {
                    bottomBarBlocki.position = CGPoint(x:(bottomBarBlocki.position.x + CGFloat(block.getWidth())), y:(bottomBarBlocki.position.y))
                }
                    //Case where we haven't added the block yet
                else {
                    //If the block we are dragging is close enough to a block already in a bar add it
                    if abs(bottomBarBlocki.getTopRightX() - blockTopLeftX) < 3 && abs(bottomBarBlocki.getTopRightY() - blockTopLeftY) < 3 {
                        block.position = CGPoint(x:(bottomBarBlocki.getTopRightX() + block.getWidth() / 2), y:(bottomBarBlocki.getTopRightY() - block.getHeight() / 2))
                        added = true
                        //Insert this block after the block it lines up with
                        insertionIndex = i + 1
                    }
                }
            }
            
            //We do not mutate the top bar list until all items have been shifted over
            if (added == true) {
                bottomBar.insert(block, at:insertionIndex)
            }
            
            
            //Are we dragging a block from the number bank
            if (block == numBlockInBank) {
                //Block has moved outside of block bank
                if (abs(block.position.x - numBlockBankPosition.x) > CGFloat(block.getNumWidth()) || abs(block.position.y - numBlockBankPosition.y) > CGFloat(block.getHeight())) {
                    let newBlock = Block(type: .number)
                    newBlock.position = numBlockBankPosition
                    numBlockInBank = newBlock
                    self.addChild(newBlock)
                }
                else {
                    block.position = numBlockBankPosition
                }
            }
            
            if (block == varBlockInBank) {
                //Block has moved outside of block bank
                if (abs(block.position.x - varBlockBankPosition.x) > CGFloat(block.getVarWidth()) || abs(block.position.y - varBlockBankPosition.y) > CGFloat(block.getHeight())) {
                    let newBlock = Block(type: .variable)
                    newBlock.position = varBlockBankPosition
                    varBlockInBank = newBlock
                    self.addChild(newBlock)
                }
                else {
                    block.position = varBlockBankPosition
                }
            }
            blockTouched = nil
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}

