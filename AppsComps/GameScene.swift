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
    var garbage: SKSpriteNode
    
    // The starting coordinates
    let width:CGFloat
    let height:CGFloat
    let HEIGHTUNIT:CGFloat
    let WIDTHUNIT:CGFloat
    let BARX:CGFloat
    let TOPBARY:CGFloat
    let BOTTOMBARY:CGFloat
    let NUMBLOCKBANKPOSITION:CGPoint
    let VARBLOCKBANKPOSITION:CGPoint
    let BLOCKHEIGHT:CGFloat
    let VARBLOCKWIDTH:CGFloat
    let NUMBLOCKWIDTH:CGFloat
    let NUMBLOCKSIZE:CGSize
    let VARBLOCKSIZE:CGSize
    
    // not implemented
    var isSorted = false
    
    // Set as the block that is touched so that
    // in touchesMoved, the block will move
    // If no block is touched, stays nil
    var blockTouched:Block? = nil
    
    // The block in the bank
    var numBlockInBank:Block
    var varBlockInBank:Block
    
    override init(size: CGSize) {
        width = size.width
        height = size.height
        HEIGHTUNIT = height/16
        WIDTHUNIT = width/16
        BARX = 2*HEIGHTUNIT
        TOPBARY = 11*HEIGHTUNIT
        BOTTOMBARY = 6*HEIGHTUNIT
        NUMBLOCKBANKPOSITION = CGPoint(x: WIDTHUNIT*4, y: HEIGHTUNIT)
        VARBLOCKBANKPOSITION = CGPoint(x: WIDTHUNIT*3, y: HEIGHTUNIT)
        BLOCKHEIGHT = 25
        VARBLOCKWIDTH = 60
        NUMBLOCKWIDTH = 40
        NUMBLOCKSIZE = CGSize(width: NUMBLOCKWIDTH, height : BLOCKHEIGHT)
        VARBLOCKSIZE = CGSize(width: VARBLOCKWIDTH, height : BLOCKHEIGHT)
        
        numBlockInBank = Block(type:.number, size: NUMBLOCKSIZE)
        varBlockInBank = Block(type:.variable, size: VARBLOCKSIZE)
    
        //MEG!!! Not sure where we want to store and initialize this garbage can. But we need to make it before we call the super init. But can't change it before the superinit, so how I made it now works, but not sure if it's good.
        garbage = SKSpriteNode(imageNamed: "garbage.png")
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addBlockChild(_ node: SKNode) {
        node.zPosition = CGFloat(currentBlockZ)
        currentBlockZ += 3
        super.addChild(node)
    }
    
    // Called immediately after a scene is loaded
    // Sets the layout of all components in the problem screen
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        
        garbage.position = CGPoint(x: 500, y: 500)
        garbage.size = CGSize(width: 100, height: 120)
        self.addChild(garbage)
        
        //Add the original block in the number block bank and the variable block bank
        numBlockInBank.position = NUMBLOCKBANKPOSITION
        self.addBlockChild(numBlockInBank)
        
        varBlockInBank.position = VARBLOCKBANKPOSITION
        self.addBlockChild(varBlockInBank)
        
        //These are the rectangles that show where the bars start. It's a bit hacky to get the height from varBlockInBank but the height is stored in the block class
        let topBarStarter = SKSpriteNode(texture: nil, color: .yellow, size: CGSize(width: 4, height : varBlockInBank.getHeight()))
        topBarStarter.position = CGPoint(x:CGFloat(BARX - 2), y:CGFloat(TOPBARY))
        
        self.addChild(topBarStarter)
        
        let bottomBarStarter = SKSpriteNode(texture: nil, color: .yellow, size: CGSize(width: 4, height : varBlockInBank.getHeight()))
        bottomBarStarter.position = CGPoint(x:CGFloat(BARX - 2), y:CGFloat(BOTTOMBARY))
        
        self.addChild(bottomBarStarter)
        
        
        
        
        //Pinchy stuff
        //http://stackoverflow.com/questions/41278079/pinch-gesture-to-rescale-sprite
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchFrom(_:)))
        self.view?.addGestureRecognizer(pinchGesture)

        
    }
    
    //Got this from the stack overflow post...
    func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        //We don't need to do anything when the pinch begins
        if sender.state == .began {
            
        }
        
        else if sender.state == .changed {
            //We need to scale the block that is under the first touch... not the garbage
            //Try and get the location of first pinch to print here...!!!
            let pinchScale = sender.scale
            
            if blockTouched != nil {
                //We need to not just scale, but change the old scale by the new scaling amount...
                blockTouched?.xScale = pinchScale
            }
        }
        else if sender.state == .ended {
            sender.scale = 1.0
        }
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
    
    //If the middle of the block is over the garbage can reutrns true, else returns false
    func blockOverGarbageCan(block: Block) -> Bool {
        if garbage.contains(block.position) {
            return true
        }
        return false
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
            
            //If we are close to the garbage can grow the garbage can in size a bit
            if (blockOverGarbageCan(block: block)) {
                garbage.setScale(1.2)
            }
            else {
                garbage.setScale(1.0)
            }
        }
    }
    
    func tryToInsertBlockInBar(bar: [Block], block: Block) -> Int {
        // We are going to align with the upper left corner
        let blockTopLeftX = Double(block.position.x) - block.getWidth() / 2
        
        //Go through blocks in bar from left to right. Once we find one that our block is close too we add it and shift the rest of the blocks over by its width
        var added = false
        var insertionIndex = -1
        
        //Check to see if it should be added at the beginning of the top bar
        if (bar == topBar) && (abs(blockTopLeftX - Double(BARX)) < 3) && (abs(block.position.y - CGFloat(TOPBARY)) < 3) {
            added = true
            insertionIndex = 0
            //Snap the bar into position at the start of the bar
            block.position = CGPoint(x:(CGFloat(Double(BARX) + block.getWidth() / 2)), y:CGFloat((TOPBARY)))
        }
        
        //Check to see if it should be added at the beginning of the bottom bar
        if (bar == bottomBar) && (abs(blockTopLeftX - Double(BARX)) < 3) && (abs(block.position.y - CGFloat(BOTTOMBARY)) < 3) {
            added = true
            insertionIndex = 0
            //Snap the bar into position at the start of the bar
            block.position = CGPoint(x:CGFloat((Double(BARX) + block.getWidth() / 2)), y:(CGFloat(BOTTOMBARY)))
        }
        
        //If nothing in our bar, we don't want to loop through the elements in the bar
        if (bar.count == 0) {
            return insertionIndex
        }
        
        //Don't need to check insertion index 0, because those cases are found above
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

    //Searches in a bar and finds the index of the block passed in. Returns that index of -1 if the block is not in the bar.
    func findIndexOfBlock(bar: [Block], block: Block) -> Int {
        if (bar.count == 0) {
            return -1
        }
        for i in 0...(bar.count - 1) {
            let blocki = bar[i]
            if (blocki == block) {
                return i
            }
            
        }
        return -1
    }
    
    //Shifts all of the blocks after the given index left by a shift amount
    func shiftBlocksLeft(bar: [Block], width: Double, index: Int) {
        //This if statement is a bit squishy. Not sure exactly what it does, but don't want to loop with bad inputs
        if (bar.count - 1 >= index + 1) {
            for i in (index + 1)...(bar.count - 1) {
                bar[i].position = CGPoint(x:((bar[i].position.x) - CGFloat(width)), y:(bar[i].position.y))
            }
        }
    }
    
    //Returns the x coordinate for the end of the last block in the bar passed in
    func getEndOfBar(bar: [Block]) -> Double {
        var endOfBar = Double(BARX)
        for i in 0...(bar.count - 1) {
            endOfBar += bar[i].getWidth()
        }
        return endOfBar
    }

    
    // Called when you lift up your finger
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if blockTouched != nil {
            
            let block = blockTouched!
            
            //This following code is new and kind of icky...
            let indexInTopBar = findIndexOfBlock(bar: topBar, block: block)
            let indexInBottomBar = findIndexOfBlock(bar: bottomBar, block:block)
            
            
            //The block is in the top bar
            if (indexInTopBar > -1) {
                //If we move the block outside of the bar, by moving it too high, too left, or too right
                if (   (Double(block.position.y) > Double(TOPBARY) + block.getHeight())   ||
                       (Double(block.position.y) < Double(TOPBARY) - block.getHeight())   ||
                    ((abs(Double(TOPBARY) - Double(block.position.y)) < block.getHeight()) && (Double(block.position.x) < Double(BARX) - block.getWidth() / 2)                                                   ||
                    (abs(Double(TOPBARY) - Double(block.position.y)) < block.getHeight())  && (Double(block.position.x) - (block.getWidth() / 2) > getEndOfBar(bar: topBar)))) {
                    shiftBlocksLeft(bar: topBar, width:block.getWidth(), index:indexInTopBar)
                    topBar.remove(at: indexInTopBar)
                }
                
                //if the y value didn't change enough, put the bar back in its spot
                //The spot it goes back into has the y-value of the bar height
                //And an x value of the previous block x location + half of the previous block width + half of this block width
                // I have no idea why I need the temps... but it doesn't work without them...
                else {
                    //xPosition is for where we need to put the block back to, we calculate it using the position of the previous block in the bar
                    var xPosition : CGFloat = 0.0
                    //If not the first block in the bar
                    if (indexInTopBar != 0) {
                        //The middle x position of the previous block in the bar
                        let temp = topBar[indexInTopBar - 1].position.x
                        xPosition += temp
                        //Half the width of the previous block in the bar
                        let temp2 = CGFloat(topBar[indexInTopBar - 1].getWidth() / 2)
                        xPosition += temp2
                        //Half the width of the block being added
                        xPosition += CGFloat(block.getWidth() / 2)
                    }
                    //First block in the bar
                    else {
                        xPosition += CGFloat(BARX) + CGFloat(block.getWidth() / 2)
                    }
                    
                    block.position = CGPoint(x:xPosition, y:CGFloat(TOPBARY))
                }
            }
            //If it's not already in the top bar, are you dragging it to the top bar?
            else if abs(Double(TOPBARY) - Double(block.position.y)) < 3 {
                let insertionIndex = tryToInsertBlockInBar(bar: topBar, block: block)
                if insertionIndex > -1 {
                    topBar.insert(block, at:insertionIndex)
                }
            }
            
            //The block is in the bottom bar
            if (indexInBottomBar > -1) {
                if (   (Double(block.position.y) > Double(BOTTOMBARY) + block.getHeight())   ||
                    (Double(block.position.y) < Double(BOTTOMBARY) - block.getHeight())   ||
                    ((abs(Double(BOTTOMBARY) - Double(block.position.y)) < block.getHeight()) && (Double(block.position.x) < Double(BARX) - block.getWidth() / 2)                                                   ||
                        (abs(Double(BOTTOMBARY) - Double(block.position.y)) < block.getHeight())  && (Double(block.position.x) - (block.getWidth() / 2) > getEndOfBar(bar: bottomBar)))) {
                    shiftBlocksLeft(bar: bottomBar, width:block.getWidth(), index:indexInBottomBar)
                    bottomBar.remove(at: indexInBottomBar)
                }
                //if the y value didn't change enough, put the bar back in its spot
                //The spot it goes back into has the y-value of the bar height
                //And an x value of the previous block x location + half of the previous block width + half of this block width
                // I have no idea why I need the temps... but it doesn't work without them...
                else {
                    //xPosition is for where we need to put the block back to, we calculate it using the position of the previous block in the bar
                    var xPosition : CGFloat = 0.0
                    //If not the first block in the bar
                    if (indexInBottomBar != 0) {
                        //The starting position of the previous block in the bar
                        let temp = bottomBar[indexInBottomBar - 1].position.x
                        xPosition += temp
                        //Half the width of the previous block in the bar
                        let temp2 = CGFloat(bottomBar[indexInBottomBar - 1].getWidth() / 2)
                        xPosition += temp2
                        //Half the width of the current block being added
                        xPosition += CGFloat(block.getWidth() / 2)
                    }
                    else {
                        xPosition += CGFloat(BARX) + CGFloat(block.getWidth() / 2)
                    }
                    
                    block.position = CGPoint(x:xPosition, y:CGFloat(BOTTOMBARY))
                }
            }
            //If it's not already in the bottom bar, are you dragging it to the bottom bar?
            else if abs(Double(BOTTOMBARY) - Double(block.position.y)) < 3 {
                let insertionIndex = tryToInsertBlockInBar(bar: bottomBar, block: block)
                if insertionIndex > -1 {
                    bottomBar.insert(block, at:insertionIndex)
                }
            }
            
            //Remove the block from the gamescene if it is on top of the garbage can when the touch ends
            if (blockOverGarbageCan(block: block)) {
                block.removeFromParent()
                garbage.setScale(1.0)
            }
            
            // Are you dragging a block from the number bank? If you moved it "far enough", repopulate the numBlockBank. 
            // If not, put the block back where it came from
            if (block == numBlockInBank) {
                //Block has moved outside of block bank
                if (abs(block.position.x - NUMBLOCKBANKPOSITION.x) > CGFloat(block.getWidth()) || abs(block.position.y - NUMBLOCKBANKPOSITION.y) > CGFloat(block.getHeight())) {
                    let newBlock = Block(type: .number, size: NUMBLOCKSIZE)
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
                if (abs(block.position.x - VARBLOCKBANKPOSITION.x) > CGFloat(block.getWidth()) || abs(block.position.y - VARBLOCKBANKPOSITION.y) > CGFloat(block.getHeight())) {
                    let newBlock = Block(type: .variable, size: VARBLOCKSIZE)
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

