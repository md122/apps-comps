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
    
    var isSorted = false
    var blockTouched:Block? = nil
    
    var numBlockInBank = Block(type:.number)
    var varBlockInBank = Block(type: .variable)
    var numBlockBankPosition = CGPoint(x:100, y:100)
    var varBlockBankPosition = CGPoint(x:200, y:100)
    
    override func didMove(to view: SKView) {
        //Add the original block in the number block bank and the variable block bank
        numBlockInBank.position = numBlockBankPosition
        self.addChild(numBlockInBank)
        
        varBlockInBank.position = varBlockBankPosition
        self.addChild(varBlockInBank)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        for child in self.children {
            if let block = child as? Block {
                if block == self.atPoint(touchLocation) {
                    blockTouched = block
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Check if the block is currently being touched
        if blockTouched != nil {
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
            
            //Are we dragging a block from the n
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

