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
    
    var topBar = [SKShapeNode]()
    var blockTouched:SKShapeNode? = nil
    let block = SKShapeNode(rectOf: CGSize(width: 50, height: 10))
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        block.position = CGPoint(x:100, y:100)
        topBar.append(block)
        self.addChild(block)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        for block in topBar {
            if block == self.atPoint(touchLocation) {
                blockTouched = block
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
            //Need to make this so outside of the box to just large enough x and y
            if (block.position.x > 200 && block.position.y > 200) {
                let newBlock = SKShapeNode(rectOf: CGSize(width: 50, height: 10))
                newBlock.position = CGPoint(x:100, y:100)
                topBar.append(newBlock)
                self.addChild(newBlock)
            }
        
            blockTouched = nil
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}

