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

class GameScene: SKScene, UITextFieldDelegate {
    let parentViewController:UIViewController
    
    // Makes the blocks stack in the correct order
    // Based on the order they were last touched
    // Value incremented every time a block is touched
    var currentBlockZ:CGFloat
    
    var topBar = [Block]()
    var bottomBar = [Block]()
    var garbage:SKSpriteNode
    var clearButton:SKSpriteNode
    var vortex:SKSpriteNode
    
    // The starting coordinates and fixed widths
    let width:CGFloat
    let height:CGFloat
    let HEIGHTUNIT:CGFloat
    let WIDTHUNIT:CGFloat
    let BARX:CGFloat
    let TOPBARY:CGFloat
    let BOTTOMBARY:CGFloat
    let NUMBLOCKBANKPOSITION:CGPoint
    let SUBNUMBLOCKBANKPOSITION:CGPoint
    let VARBLOCKBANKPOSITION:CGPoint
    let SUBVARBLOCKBANKPOSITION:CGPoint
    let BLOCKHEIGHT:CGFloat
    let VARBLOCKWIDTH:CGFloat
    var VARBLOCKSCALE:CGFloat
    let NUMBLOCKWIDTH:CGFloat
    let NUMBLOCKSIZE:CGSize
    let VARBLOCKSIZE:CGSize
    let GARBAGEPOSITION:CGPoint
    let VORTEXPOSITION:CGPoint
    let CLEARBUTTONPOSITION:CGPoint
    let GARBAGESIZE:CGSize
    let SNAPDISTANCE:Double
    let BORDERWIDTH:Double
    
    
    // Set as the block that is touched so that
    // in touchesMoved, the block will move
    // If no block is touched, stays nil
    var blockTouched:Block? = nil
    
    // The block in the bank
    var numBlockInBank:Block
    var varBlockInBank:Block
    var subNumBlockInBank:Block
    var subVarBlockInBank:Block
    
    init(size: CGSize, parent: UIViewController) {
        self.parentViewController = parent
        width = size.width
        height = size.height
        HEIGHTUNIT = height/16
        WIDTHUNIT = width/16
        BARX = 1*WIDTHUNIT
        TOPBARY = 12*HEIGHTUNIT
        BOTTOMBARY = 9*HEIGHTUNIT
        BLOCKHEIGHT = 2*HEIGHTUNIT
        VARBLOCKWIDTH = 2*WIDTHUNIT
        NUMBLOCKWIDTH = 1*WIDTHUNIT
        VARBLOCKSCALE = 1
        NUMBLOCKSIZE = CGSize(width: NUMBLOCKWIDTH, height : BLOCKHEIGHT)
        VARBLOCKSIZE = CGSize(width: VARBLOCKWIDTH, height : BLOCKHEIGHT)
        GARBAGESIZE = CGSize(width: 3*WIDTHUNIT, height:1.2*3*WIDTHUNIT)
        
        GARBAGEPOSITION = CGPoint(x: 0.5*WIDTHUNIT+0.5*GARBAGESIZE.width, y: 0.25*HEIGHTUNIT+0.5*GARBAGESIZE.height)
        
        //padding between each block is 1/4*VARBLOCKWIDTH
        NUMBLOCKBANKPOSITION = CGPoint(x: GARBAGEPOSITION.x+1*VARBLOCKWIDTH+0.5*NUMBLOCKWIDTH, y: GARBAGEPOSITION.y)
        VARBLOCKBANKPOSITION = CGPoint(x: NUMBLOCKBANKPOSITION.x+0.5*NUMBLOCKWIDTH+0.75*VARBLOCKWIDTH, y: NUMBLOCKBANKPOSITION.y)
        SUBNUMBLOCKBANKPOSITION = CGPoint(x: VARBLOCKBANKPOSITION.x+0.75*VARBLOCKWIDTH+0.5*NUMBLOCKWIDTH, y: NUMBLOCKBANKPOSITION.y)
        SUBVARBLOCKBANKPOSITION = CGPoint(x: SUBNUMBLOCKBANKPOSITION.x+0.5*NUMBLOCKWIDTH+0.75*VARBLOCKWIDTH, y: NUMBLOCKBANKPOSITION.y)
        VORTEXPOSITION = CGPoint(x: SUBVARBLOCKBANKPOSITION.x+1.5*VARBLOCKWIDTH, y: GARBAGEPOSITION.y+0.25*GARBAGESIZE.height)
        CLEARBUTTONPOSITION = CGPoint(x: SUBVARBLOCKBANKPOSITION.x+1.5*VARBLOCKWIDTH, y: GARBAGEPOSITION.y-0.25*GARBAGESIZE.height)

        
        currentBlockZ = 1.0
        numBlockInBank = Block(type:.number, size: NUMBLOCKSIZE, value: "1")
        varBlockInBank = Block(type:.variable, size: VARBLOCKSIZE, value: "1")
        subNumBlockInBank = Block(type:.subNumber, size: NUMBLOCKSIZE, value: "-1")
        subVarBlockInBank = Block(type:.subVariable, size: VARBLOCKSIZE, value: "-1")
        
        garbage = SKSpriteNode(imageNamed: "garbage.png")
        clearButton = SKSpriteNode(imageNamed: "clearButton.phg")
        vortex = Vortex()
        
        SNAPDISTANCE = 20.0
        BORDERWIDTH = 2
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Removes all blocks from the problem screen besides the block banks and the vortex
    func clearProblemScreen() {
        for case let child as Block in self.children {
            if child != varBlockInBank && child != numBlockInBank && child != subNumBlockInBank && child != subVarBlockInBank && child != vortex {
                child.removeFromParent()
            }
            //We need to set the bars back to empty because removing a block from its parent doesn't remove it from a bar
            topBar = [Block]()
            bottomBar = [Block]()
        }
        VARBLOCKSCALE = 1
    }
    
    //Instead of calling addChild, call this function to add a block and set it to the correct z value
    func addBlockChild(_ node: SKNode) {
        node.zPosition = CGFloat(currentBlockZ)
        currentBlockZ += 6
        super.addChild(node)
    }
    
    //takes in a block and scales the inner rectange so the border is length border width
    func scaleBorder(block: Block) {
            block.getBlockColorRectangle().xScale = (CGFloat(-1*BORDERWIDTH) + (CGFloat(block.getOriginalWidth()) * block.xScale)) / (block.xScale * CGFloat(block.getOriginalWidth()))
            block.getBlockColorRectangle().yScale = (CGFloat(-1*BORDERWIDTH) + (BLOCKHEIGHT * block.yScale)) / (block.yScale * BLOCKHEIGHT)
    }
    
    // Called immediately after a scene is loaded
    // Sets the layout of all components in the problem screen
    override func didMove(to view: SKView) {

        self.backgroundColor = .white
        
        garbage.position = GARBAGEPOSITION
        vortex.position = VORTEXPOSITION
        clearButton.position = CLEARBUTTONPOSITION
        garbage.size = GARBAGESIZE
        vortex.size = CGSize(width: 1.5*WIDTHUNIT, height: 1.5*WIDTHUNIT)
        clearButton.size = CGSize(width: 2*WIDTHUNIT, height: 0.9*WIDTHUNIT)
        self.addChild(garbage)
        self.addChild(vortex)
        self.addChild(clearButton)
        
        //Add the original block in the number block bank and the variable block bank
        numBlockInBank.position = NUMBLOCKBANKPOSITION
        self.addBlockChild(numBlockInBank)
        scaleBorder(block: numBlockInBank)
        varBlockInBank.position = VARBLOCKBANKPOSITION
        self.addBlockChild(varBlockInBank)
        scaleBorder(block: varBlockInBank)
        subNumBlockInBank.position = SUBNUMBLOCKBANKPOSITION
        self.addBlockChild(subNumBlockInBank)
        scaleBorder(block: subNumBlockInBank)
        subVarBlockInBank.position = SUBVARBLOCKBANKPOSITION
        self.addBlockChild(subVarBlockInBank)
        scaleBorder(block: subVarBlockInBank)
        
        //These are the rectangles that show where the bars start
        let barStarterColor1 = UIColor(hexString: "#323641")
        let topBarStarter = SKSpriteNode(texture: nil, color: barStarterColor1, size: CGSize(width: WIDTHUNIT/3.5, height : BLOCKHEIGHT))
        topBarStarter.position = CGPoint(x:CGFloat(BARX), y:CGFloat(TOPBARY))
        self.addChild(topBarStarter)
        
        let bottomBarStarter = SKSpriteNode(texture: nil, color: barStarterColor1, size: CGSize(width: WIDTHUNIT/3.5, height : BLOCKHEIGHT))
        bottomBarStarter.position = CGPoint(x:CGFloat(BARX), y:CGFloat(BOTTOMBARY))
        self.addChild(bottomBarStarter)
        
        //Create the pinch gesture recognizer for scaling and add it to the view
        //http://stackoverflow.com/questions/41278079/pinch-gesture-to-rescale-sprite
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchFrom(_:)))
        self.view?.addGestureRecognizer(pinchGesture)
        
        //Create the doubleTap gesture recognizer for changing the value of a block and add it to the view
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.view?.addGestureRecognizer(doubleTapGesture)
    }
    
    //First snaps blocks into place and then calls changeBlockValueAlert
    func handleDoubleTap(_ sender: UILongPressGestureRecognizer) {
        if blockTouched != nil && blockTouched != varBlockInBank && blockTouched != numBlockInBank && blockTouched != subNumBlockInBank && blockTouched != subVarBlockInBank && blockTouched != vortex{
            if blockTouched?.getType() == "number" || blockTouched?.getType() == "variable" {
                snapPositiveBlockIntoPlace(block: blockTouched!)
            }
            else {
                snapNegativeBlockIntoPlace(block: blockTouched!)
            }
            changeBlockValueAlert(block: blockTouched!)
        }
    }
    
    //The framework for this method is from the stack overflow post linked earlier
    func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            //We want to snap the block back into the correct bar(or put it back in it's position in the block bank or remove it from the bar before the stretching starts
            if blockTouched != nil {
                //We set the sender scale to start at the current scale for the current block so as it changes the block will change correctly
                sender.scale = (blockTouched?.xScale)!
                if blockTouched?.getType() == "number" || blockTouched?.getType() == "variable" {
                    snapPositiveBlockIntoPlace(block: blockTouched!)
                }
                else {
                    snapNegativeBlockIntoPlace(block: blockTouched!)
                }
            }
        }
            
        else if sender.state == .changed {
            let pinchScale = sender.scale
            //If the pinch starts with a touch on a block. We can't stretch blocks while they are in the bank
            if blockTouched != nil && blockTouched != varBlockInBank && blockTouched != numBlockInBank && blockTouched != subNumBlockInBank && blockTouched != subVarBlockInBank && blockTouched != vortex {
                //We need to shift all of the blocks after the one being stretched over by the amount the pinch changed the block
                var indexInTopBar = findIndexOfBlock(bar: topBar, block:blockTouched!)
                var indexInBottomBar = findIndexOfBlock(bar: bottomBar, block:blockTouched!)
                //The difference in the bar size is how big the bar was before the stretch - how big the bar is after the stretch

                var differenceInBlockSize = (Double(pinchScale) * blockTouched!.getOriginalWidth() - Double(blockTouched!.xScale) * blockTouched!.getOriginalWidth())
               
                //This will be changed for the negative blocks attached to a parent block, so they move over the right amount
                if indexInTopBar > -1 {
                    shiftBlocks(bar: topBar, width:differenceInBlockSize, index:indexInTopBar)
                }
                if indexInBottomBar > -1 {
                    shiftBlocks(bar: bottomBar, width:differenceInBlockSize, index:indexInBottomBar)
                }
                //If we are dealing with a subtraction block that is currently the child of a positive block don't scoot it over, but do mess with the scale factor because it is in it's parent world
                if (blockTouched?.parent as? Block) != nil {
                    let scale1 = Double((blockTouched?.xScale)!)
                    let scale2 = Double((blockTouched?.parent?.xScale)!)
                    let previousBlockSize = scale1 * scale2 * Double((blockTouched?.getOriginalWidth())!)
                    let currentBlockSize = (Double(pinchScale)) * blockTouched!.getOriginalWidth()
                    differenceInBlockSize = currentBlockSize - previousBlockSize
                    
                    //Scale the subtraction number, but not the subtraction variable because that will get scaled with it's parent
                    if blockTouched?.getType() == "subNumber" {
                        blockTouched?.xScale = (pinchScale / (blockTouched?.parent?.xScale)!)
                        scaleBorder(block: blockTouched!)
                        blockTouched?.getLabel().xScale = (1 / pinchScale)
                        blockTouched?.position = CGPoint(x:((blockTouched?.position.x)! - ((CGFloat(differenceInBlockSize) / (blockTouched?.parent?.xScale)!)) / 2), y:(blockTouched?.position.y)!)
                    }
                    else if blockTouched?.getType() == "subVariable" {
                            let blockParent = blockTouched?.parent as! Block
                            blockTouched?.getLabel().xScale = (1 / pinchScale) / CGFloat((blockParent.getValue()))
                    }
                }
                
                //Make the block only increase to the right for positive numbers and only increase to the left for negative
                else if (blockTouched?.getType() == "variable" || blockTouched?.getType() == "number") {
                    blockTouched?.xScale = pinchScale
                    scaleBorder(block: blockTouched!)
                    blockTouched?.position = CGPoint(x:((blockTouched?.position.x)! + ((CGFloat(differenceInBlockSize)) / 2)), y:(blockTouched?.position.y)!)
                    
                    blockTouched?.getLabel().xScale = 1/(blockTouched?.xScale)!
                    
                    //If this block has a child, make sure that child's label is scaled to 1
                    if blockTouched?.getSubtractionBlock() != nil {
                        blockTouched?.getSubtractionBlock()?.getLabel().xScale = (1 / pinchScale) / (blockTouched?.getSubtractionBlock()?.xScale)!
                    }
                }
                //The subtractions stretch to the left
                else if blockTouched?.getType() == "subNumber" || blockTouched?.getType() == "subVariable" {
                    blockTouched?.xScale = pinchScale
                    scaleBorder(block: blockTouched!)
                    blockTouched?.position = CGPoint(x:((blockTouched?.position.x)! - (CGFloat(differenceInBlockSize) / 2)), y:(blockTouched?.position.y)!)
                    blockTouched?.getLabel().xScale = 1/(blockTouched?.xScale)!
                }
                //If we are scaling a variable or subtraction variable we want the change to actually be for 1x not nx
                //Yes I know this is dumb...
                var differenceInBlockSizeFor1x = 0.0
                if blockTouched!.getType() == "variable" || blockTouched!.getType() == "subVariable" {
                    differenceInBlockSizeFor1x = differenceInBlockSize / abs(blockTouched!.getValue())
                }

                //If changing a variable block, scale all of the variable blocks and set the VARBLOCKSCALE so the new blocks from the bank are correct
                if blockTouched?.getType() == "variable" || blockTouched?.getType() == "subVariable" {
                    VARBLOCKSCALE = pinchScale
                    //go through each of the game scene children that are blocks
                    for case let child as Block in self.children {
                        differenceInBlockSize = differenceInBlockSizeFor1x * abs(child.getValue())
                        //If the block is a variable (and not the one we are currently moving or the one in the bank we need to stretch it also
                        if (child.getType() == "variable" || child.getType() == "subVariable") && child != blockTouched && child != varBlockInBank && child != subVarBlockInBank {
                            child.xScale = pinchScale
                            scaleBorder(block: child)

                            //Move the block over so it's only increasing to the right for addition and to the left for subtraction
                            if (child.getType() == "variable") {
                                child.position = CGPoint(x:((child.position.x) + (CGFloat(differenceInBlockSize) / 2)), y:(child.position.y))
                            }
                            else {
                                child.position = CGPoint(x:((child.position.x) - (CGFloat(differenceInBlockSize) / 2)), y:(child.position.y))
                            }
                            
                            //We need to shift all of the blocks after the one being stretched over by the amount the pinch changed the block
                            indexInTopBar = findIndexOfBlock(bar: topBar, block:child)
                            indexInBottomBar = findIndexOfBlock(bar: bottomBar, block:child)
                            //The difference in the bar size is how big the bar was before the stretch - how big the bar is after the stretch
                            if indexInTopBar > -1 {
                                shiftBlocks(bar: topBar, width:differenceInBlockSize, index:indexInTopBar)
                            }
                            if indexInBottomBar > -1 {
                                shiftBlocks(bar: bottomBar, width:differenceInBlockSize, index:indexInBottomBar)
                            }
                            child.getLabel().xScale = 1 / (child.xScale)
                            if child.getSubtractionBlock() != nil {
                                child.getSubtractionBlock()?.getLabel().xScale = 1 / pinchScale
                            }
                        }
                    }
                }
                self.scaleBorder(block: blockTouched!)
            }
        }
            
        else if sender.state == .ended {
            //This check is because the block might have been moved into the trash during the snapback done before stretching and it not exist
            if blockTouched != nil {
                blockTouched?.color = .black
            }
            //We don't want you to still be selecting the block after the pinch has ended
            blockTouched = nil
        }
    }
    
    
    //Block is touched first checks if it's child is touched, and then checks to see if it is touched
    func blockIsTouched(touchLocation: CGPoint, child: SKNode?) -> String {
        if let block = child as? Block {
            //Need to implement the logic of seeing if the child has been touched
            if blockIsTouched(touchLocation: touchLocation, child: block.getSubtractionBlock()) == "thisBlock" {
                return "subtractionBlock"
            }
            else if (block == self.atPoint(touchLocation) || block.getLabel() == self.atPoint(touchLocation) || block.getBlockColorRectangle() == self.atPoint(touchLocation)) {
                return "thisBlock"
            }
        }
        return "no"
    }
    
    //Removes the negative block and also does the correct scaling to enter the negative block into the scaling of the game scene
    func removeNegativeBlockFromPositive(positiveBlock: Block) {
        blockTouched = positiveBlock.getSubtractionBlock()
        positiveBlock.removeSubtractionBlock()
        //Now the subtraction block is in game scene, so get fix the scaling from when it was with parent
        blockTouched?.xScale = (blockTouched?.xScale)! * positiveBlock.xScale
        scaleBorder(block: blockTouched!)

        //Set the subtraction block position so it doesn't jump when it goes back on the game scene
        let theXScale = positiveBlock.position.x + (CGFloat(positiveBlock.getWidth()) - CGFloat((blockTouched?.getWidth())!)) / 2
        blockTouched?.position = CGPoint(x:theXScale, y:positiveBlock.position.y)
        self.addChild(blockTouched!)
        blockTouched?.color = .red
        blockTouched?.zPosition = currentBlockZ
        currentBlockZ += 6
    }

    //Called by changeBlockValueAlert and creates a new block with the new value and makes it look just like the old block or bigger if it's a variable block. Also transfers over any child this block may have or keepts the block as a child if it was one before the stretch
    func changeBlockValue(value: String, block: Block) {
        //Start by snapping block into place, so if the block is negative attached to positive it will be a child for all of this.
        if block.getType() == "number" || block.getType() == "variable" {
            self.snapPositiveBlockIntoPlace(block: block)
        }
        else {
            self.snapNegativeBlockIntoPlace(block: block)
        }
        var newBlock: Block
        if block.getType() == "variable" {
            newBlock = Block(type: .variable, size:self.VARBLOCKSIZE, value: value)
            scaleBorder(block: newBlock)
        }
        else if block.getType() == "subVariable"{
            newBlock = Block(type: .subVariable, size:self.VARBLOCKSIZE, value: value)
            scaleBorder(block: newBlock)
        }
        else if block.getType() == "number" {
            newBlock = Block(type: .number, size:self.NUMBLOCKSIZE, value: value)
            scaleBorder(block: newBlock)
        }
        //subNumber case, not specified so new block always initializes
        else {
            newBlock = Block(type: .subNumber, size:self.NUMBLOCKSIZE, value: value)
            scaleBorder(block: newBlock)
        }
        //If the block has a child, transfer it over
        if block.getSubtractionBlock() != nil {
            let subBlock = block.getSubtractionBlock()
            subBlock?.removeFromParent()
            //Probs need to scale up!!!
            newBlock.setSubtractionBlock(block: subBlock)
        }
        //If the block is a child, add the new child to the parent
        if (block.parent as? Block) != nil {
            let parent = block.parent as! Block
            block.removeFromParent()
            if block.getType() == "subVariable" {
                newBlock.xScale = self.VARBLOCKSCALE
                scaleBorder(block: newBlock)

            }
            newBlock.getLabel().xScale = 1 / newBlock.xScale
            parent.setSubtractionBlock(block: newBlock)
        }
        //if the new block is not a child do the stuff to add it correctly to the game scene
        else {
            //But the scale should be the same
            newBlock.xScale = block.xScale
            scaleBorder(block: newBlock)

            //Not quite old position, old position + half the change in block size
            if block.getType() == "variable" || block.getType() == "number" {
                let xPosition = block.position.x + CGFloat(((newBlock.getWidth() - block.getWidth()) / 2))
                newBlock.position = CGPoint(x: xPosition, y: block.position.y)
            }
            else {
                let xPosition = block.position.x - CGFloat(((newBlock.getWidth() - block.getWidth()) / 2))
                newBlock.position = CGPoint(x: xPosition, y: block.position.y)
            }
            //If the old block was in a bar, we do not need to scoot it over
            //WHY THE SELF all of the sudden? !!!!!!!
            let indexInTopBar = self.findIndexOfBlock(bar: self.topBar, block:block)
            let indexInBottomBar = self.findIndexOfBlock(bar: self.bottomBar, block:block)
            let shift = newBlock.getWidth() - block.getWidth()
            if indexInTopBar > -1 {
                //Add new block to bar, remove old block from bar
                self.topBar.remove(at: indexInTopBar)
                self.topBar.insert(newBlock, at:indexInTopBar)
                self.shiftBlocks(bar:self.topBar, width: shift, index: indexInTopBar)
            }
            else if indexInBottomBar > -1 {
                //Add new block to bar, remove old block from bar
                self.bottomBar.remove(at: indexInBottomBar)
                self.bottomBar.insert(newBlock, at:indexInBottomBar)
                self.shiftBlocks(bar:self.bottomBar, width: shift, index: indexInBottomBar)
            }
            
            block.removeFromParent()
            self.addBlockChild(newBlock)
            //Scale the label because the block scale changed after it was created
            newBlock.getLabel().xScale = 1 / newBlock.xScale
        }
    }
    
    func sanitizePosVariableValue(input: String) -> String {
        if let value = Double(input) {
            if value > 0 && value < 1000 {
                return input
            }
            return ""
        }
        else {
            return ""
        }
    }
    
    func sanitizeNegVariableValue(input: String) -> String {
        if let value = Double(input) {
            if value < 0 {
                if value > -1000 {
                    return input
                }
                return ""
            } else {
                if value < 1000 {
                    let negInput = "-"+input
                    return negInput
                }
                return ""
            }
        }
        else {
            return ""
        }
    }
    
    func sanitizePosNumberValue(input: String) -> String {
        if let value = Double(input) {
            if value > 0 && value < 1000 {
                return input
            }
            return ""
        }
        else {
            return ""
        }
    }
    
    func sanitizeNegNumberValue(input: String) -> String {
        if let value = Double(input) {
            if value < 0 {
                if value > -1000 {
                    return input
                }
                return ""
            } else {
                if value < 1000 {
                    let negInput = "-"+input
                    return negInput
                }
                return ""
            }
        }
        else {
            return ""
        }
    }

    //Pops up an allert to get the value the user wants to change the block value too, if the user enters an incorrect value another alert pops us to let them retry.
    func changeBlockValueAlert(block: Block) {
        
        let invalidInputAlert = UIAlertController(title: "Invalid input", message: "Your submission was invalid :(", preferredStyle: UIAlertControllerStyle.alert)
        invalidInputAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (action: UIAlertAction!) in
            self.changeBlockValueAlert(block: block)
        }))
        invalidInputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.blockTouched?.color = .black
            self.blockTouched = nil
        }))
        
        let changeValueAlert = UIAlertController(title: "Change Block Value", message: "Enter the value you want your block to have", preferredStyle: UIAlertControllerStyle.alert)
        
        changeValueAlert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.keyboardType = UIKeyboardType.numberPad
        })
        
        changeValueAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            self.blockTouched?.color = .black
            self.blockTouched = nil
        }))
        changeValueAlert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (action: UIAlertAction!) in
            //Removed in merging conflict
            //let valueEntered = changeValueAlert.textFields![0].text
            //SANATIZE THE INPUTS!!!!!
            //self.changeBlockValue(value: valueEntered!, block: block)

            if var valueEntered = changeValueAlert.textFields![0].text {
                var newBlock: Block? = nil
                if block.getType() == "variable" {
                    valueEntered = self.sanitizePosVariableValue(input: valueEntered)
                    if valueEntered != "" {
                        newBlock = Block(type: .variable, size:self.VARBLOCKSIZE, value: valueEntered)
                        self.scaleBorder(block: newBlock!)
                    } else {
                        self.parentViewController.present(invalidInputAlert, animated: true, completion: nil)
                    }
                }
                else if block.getType() == "subVariable"{
                    valueEntered = self.sanitizeNegVariableValue(input: valueEntered)
                    if valueEntered != "" {
                        newBlock = Block(type: .subVariable, size:self.VARBLOCKSIZE, value: valueEntered)
                        self.scaleBorder(block: newBlock!)
                    } else {
                        self.parentViewController.present(invalidInputAlert, animated: true, completion: nil)
                    }
                }
                //Number case
                else if block.getType() == "number" {
                    valueEntered = self.sanitizePosNumberValue(input: valueEntered)
                    if valueEntered != "" {
                        newBlock = Block(type: .number, size:self.NUMBLOCKSIZE, value: valueEntered)
                        self.scaleBorder(block: newBlock!)
                    } else {
                        self.parentViewController.present(invalidInputAlert, animated: true, completion: nil)
                    }
                }
                    //subNumber case, not specified so new block always initializes
                else {
                    valueEntered = self.sanitizeNegNumberValue(input: valueEntered)
                    if valueEntered != "" {
                        newBlock = Block(type: .subNumber, size:self.NUMBLOCKSIZE, value: valueEntered)
                        self.scaleBorder(block: newBlock!)
                    } else {
                        self.parentViewController.present(invalidInputAlert, animated: true, completion: nil)
                    }
                }
                
                if newBlock != nil {
                    //If the block has a child, transfer it over
                    if block.getSubtractionBlock() != nil {
                        let subBlock = block.getSubtractionBlock()
                        subBlock?.removeFromParent()
                        newBlock?.setSubtractionBlock(block: subBlock)
                    }
                    //If the block is a child, add the new child to the parent
                    if (block.parent as? Block) != nil {
                        let parent = block.parent as! Block
                        let blockScaleBeforeRemovingFromParent = block.xScale
                        let positionBeforeRemovingFromParent = block.position
                        block.removeFromParent()
                        if block.getType() == "subVariable" {
                            newBlock?.xScale = self.VARBLOCKSCALE
                            self.scaleBorder(block: newBlock!)
                        }
                        newBlock?.getLabel().xScale = 1 / (newBlock?.xScale)!
                        parent.setSubtractionBlock(block: newBlock)
                        //If the block is a subNumber
                        if block.getType() == "subNumber" {
                            newBlock?.xScale = blockScaleBeforeRemovingFromParent
                            newBlock?.position = positionBeforeRemovingFromParent
                            self.scaleBorder(block: newBlock!)
                            newBlock?.getLabel().xScale = (1 / (newBlock?.xScale)!) / parent.xScale
                        }
                        
                    }
                        //Else do the stuff to add it correctly to the game scene
                    else {
                        //But the scale should be the same
                        newBlock?.xScale = block.xScale
                        self.scaleBorder(block: newBlock!)

                        //Not quite old position, old position + half the change in block size
                        if block.getType() == "variable" || block.getType() == "number" {
                            let xPosition = block.position.x + CGFloat((((newBlock?.getWidth())! - block.getWidth()) / 2))
                            newBlock?.position = CGPoint(x: xPosition, y: block.position.y)
                        }
                        else {
                            let xPosition = block.position.x - CGFloat((((newBlock?.getWidth())! - block.getWidth()) / 2))
                            newBlock?.position = CGPoint(x: xPosition, y: block.position.y)
                        }
                        //If the old block was in a bar, we do not need to scoot it over
                        //WHY THE SELF all of the sudden? !!!!!!!
                        let indexInTopBar = self.findIndexOfBlock(bar: self.topBar, block:block)
                        let indexInBottomBar = self.findIndexOfBlock(bar: self.bottomBar, block:block)
                        let shift = (newBlock?.getWidth())! - block.getWidth()
                        if indexInTopBar > -1 {
                            //Add new block to bar, remove old block from bar
                            self.topBar.remove(at: indexInTopBar)
                            self.topBar.insert(newBlock!, at:indexInTopBar)
                            self.shiftBlocks(bar:self.topBar, width: shift, index: indexInTopBar)
                        }
                        else if indexInBottomBar > -1 {
                            //Add new block to bar, remove old block from bar
                            self.bottomBar.remove(at: indexInBottomBar)
                            self.bottomBar.insert(newBlock!, at:indexInBottomBar)
                            self.shiftBlocks(bar:self.bottomBar, width: shift, index: indexInBottomBar)
                        }
                        
                        block.removeFromParent()
                        self.addBlockChild(newBlock!)
                        //Scale the label because the block scale changed after it was created
                        newBlock?.getLabel().xScale = 1 / (newBlock?.xScale)!
                    }
                }
            }
        }))
        self.parentViewController.present(changeValueAlert, animated: true, completion: nil)
    }
    
    // Called when you touch the screen. Sets block touched to the correct block. If the block is a negative attached to a positive it makes that block now part of the game scene world not its parent. Also checks to see if clear button was touched.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if clearButton.contains(touchLocation) {
            self.clearProblemScreen()
        }
        
        for child in self.children {
            if let block = child as? Block {
                if blockIsTouched(touchLocation: touchLocation, child: block) == "thisBlock"{
                    blockTouched = block
                    blockTouched?.color = .red
                    block.zPosition = currentBlockZ
                    currentBlockZ += 6
                }
                else if blockIsTouched(touchLocation: touchLocation, child: block) == "subtractionBlock"{
                    //If we touch the subtraction block, we bring it back in to the normal game scene and make it the block touched
                    removeNegativeBlockFromPositive(positiveBlock: block)
                }
            }
        }
    }
    
    //If the block is over the garbage can reutrns true, else returns false
    func blockOverGarbageCan(block: Block) -> Bool {
        if garbage.intersects(block) {
            return true
        }
        return false
    }
    
    //Uses the same logic as is used to remove blocks using the vortex and if the blocks would be removed by the vortex at that moment the yscale is increased, if not the yscale is set to 1. Called repeatedly by touchesmoved.
    func highlightBlocksUnderVortex() {
        for case let blockToSubtractFrom as Block in self.children {
            if (blockToSubtractFrom.getType() == "variable" || blockToSubtractFrom.getType() == "number") && blockToSubtractFrom.getSubtractionBlock() != nil && (abs(blockToSubtractFrom.getSubtractionBlock()!.getValue()) <= blockToSubtractFrom.getValue()) &&
                (((blockToSubtractFrom.getSubtractionBlock()!.getWidth() * Double(blockToSubtractFrom.xScale)) < blockToSubtractFrom.getWidth()) || (blockToSubtractFrom.getValue() == -1 * (blockToSubtractFrom.getSubtractionBlock()?.getValue())!)) && vortex.intersects(blockToSubtractFrom){
                blockToSubtractFrom.yScale = 1.1
            }
            else {
                blockToSubtractFrom.yScale = 1
            }
        }
    }
    
    // Called over and over at small intervas when you are moving your finger.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightBlocksUnderVortex()
        //Check if a block is currently being touched
        if blockTouched != nil {
            //We set the scale when we move the block so the block in the variable block in the bank has a scale of 1
            if blockTouched!.getType() == "variable" || blockTouched!.getType() == "subVariable"{
                blockTouched!.xScale = VARBLOCKSCALE
                scaleBorder(block: blockTouched!)
                blockTouched!.getLabel().xScale = 1/VARBLOCKSCALE
            }
            
            let block = blockTouched!
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            
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
            if (blockOverGarbageCan(block: block)) && block != vortex {
                garbage.setScale(1.2)
            }
            else {
                garbage.setScale(1.0)
            }
        }
    }
    
    //Given a block and a bar, if that block is at a position where it should be inserted in the bar it does the insertion it returns the insertion index to that we can shift over all of the blocks after it. There were mutation issues with trying to do this final step in this function.
    func tryToInsertBlockInBar(bar: [Block], block: Block) -> Int {
        // We are going to align with the upper left corner
        let blockTopLeftX = block.getTopLeftX()
        
        //Go through blocks in bar from left to right. Once we find one that our block is close too we add it and shift the rest of the blocks over by its width
        var added = false
        var insertionIndex = -1
        
        //Check to see if it should be added at the beginning of the top bar
        if (bar == topBar) && (abs(blockTopLeftX - Double(BARX)) < SNAPDISTANCE) && (abs(block.position.y - CGFloat(TOPBARY)) < CGFloat(SNAPDISTANCE)) {
            added = true
            insertionIndex = 0
            //Snap the bar into position at the start of the bar
            block.position = CGPoint(x:(CGFloat(Double(BARX) + block.getWidth() / 2)), y:CGFloat((TOPBARY)))
        }
        
        //Check to see if it should be added at the beginning of the bottom bar
        if (bar == bottomBar) && (abs(blockTopLeftX - Double(BARX)) < SNAPDISTANCE) && (abs(block.position.y - CGFloat(BOTTOMBARY)) < CGFloat(SNAPDISTANCE)) {
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
                if abs(blocki.getTopRightX() - blockTopLeftX) < SNAPDISTANCE {
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
    
    //This used to be called shiftBarsLeft
    //Now if you put in a negative width it will shift the blocks after the index left, if you put in a positive width it will shift all blocks after the index right
    func shiftBlocks(bar: [Block], width: Double, index: Int) {
        //This if statement is a bit squishy. Not sure exactly what it does, but don't want to loop with bad inputs
        if (bar.count - 1 >= index + 1) {
            for i in (index + 1)...(bar.count - 1) {
                bar[i].position = CGPoint(x:((bar[i].position.x) + CGFloat(width)), y:(bar[i].position.y))
            }
        }
    }
    
    //If the block is in the top bar or the bottom bar, this function removes it and scoots the blocks that come after it over.
    func removeBlockFromBarAndScootBlocksOver(block: Block) {
        let indexInTopBar = findIndexOfBlock(bar: topBar, block: block)
        let indexInBottomBar = findIndexOfBlock(bar: bottomBar, block:block)
        
        //The block is in the top bar
        if (indexInTopBar > -1) {
            shiftBlocks(bar: topBar, width:-1*block.getWidth(), index:indexInTopBar)
            topBar.remove(at: indexInTopBar)
        }
        
        //The block is in the bottom bar
        if (indexInBottomBar > -1) {
            shiftBlocks(bar: bottomBar, width:-1*block.getWidth(), index:indexInBottomBar)
            bottomBar.remove(at: indexInBottomBar)
        }
        block.removeFromParent()
    }
    
    //Returns the x coordinate for the end of the last block in the bar passed in. Used to see if a block has been dragged out of a bar or not.
    func getEndOfBar(bar: [Block]) -> Double {
        var endOfBar = Double(BARX)
        for i in 0...(bar.count - 1) {
            endOfBar += bar[i].getWidth()
        }
        return endOfBar
    }
    
    //At the end of a touch or when the pinch action starts put the block back into place and update stuff based on where it goes
    //Might make block touched nil, because it might snap the block into the garbage can
    func snapPositiveBlockIntoPlace(block: Block) {
        let indexInTopBar = findIndexOfBlock(bar: topBar, block: block)
        let indexInBottomBar = findIndexOfBlock(bar: bottomBar, block:block)
        //The block is in the top bar
        if (indexInTopBar > -1) {
            //If we move the block outside of the bar, by moving it too high, too left, or too right
            if (   (Double(block.position.y) > Double(TOPBARY) + block.getHeight())   ||
                (Double(block.position.y) < Double(TOPBARY) - block.getHeight())   ||
                ((abs(Double(TOPBARY) - Double(block.position.y)) < block.getHeight()) && (Double(block.position.x) < Double(BARX) - block.getWidth() / 2)                                                   ||
                    (abs(Double(TOPBARY) - Double(block.position.y)) < block.getHeight())  && (Double(block.position.x) - (block.getWidth() / 2) > getEndOfBar(bar: topBar)))) {
                shiftBlocks(bar: topBar, width:-1*block.getWidth(), index:indexInTopBar)
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
        else if abs(Double(TOPBARY) - Double(block.position.y)) < SNAPDISTANCE {
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
                shiftBlocks(bar: bottomBar, width:-1*block.getWidth(), index:indexInBottomBar)
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
        else if abs(Double(BOTTOMBARY) - Double(block.position.y)) < SNAPDISTANCE {
            let insertionIndex = tryToInsertBlockInBar(bar: bottomBar, block: block)
            if insertionIndex > -1 {
                bottomBar.insert(block, at:insertionIndex)
            }
        }
        
        // Are you dragging a block from the number bank? If you moved it "far enough", repopulate the numBlockBank.
        // If not, put the block back where it came from
        if (block == numBlockInBank) {
            //Block has moved outside of block bank
            if (abs(block.position.x - NUMBLOCKBANKPOSITION.x) > CGFloat(block.getWidth()) || abs(block.position.y - NUMBLOCKBANKPOSITION.y) > CGFloat(block.getHeight())) {
                let newBlock = Block(type: .number, size: NUMBLOCKSIZE, value: "1")
                scaleBorder(block: newBlock)
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
                let newBlock = Block(type: .variable, size: VARBLOCKSIZE, value: "1")
                scaleBorder(block: newBlock)
                newBlock.position = VARBLOCKBANKPOSITION
                varBlockInBank = newBlock
                self.addBlockChild(newBlock)
            }
            else {
                //When we snap a block back into the var block bank we set the scale back to 1
                block.xScale = 1
                scaleBorder(block: block)
                block.getLabel().xScale = 1
                block.position = VARBLOCKBANKPOSITION
            }
        }
        //Remove the block from the gamescene if it is on top of the garbage can when the touch ends
        if (blockOverGarbageCan(block: block)) {
            block.removeFromParent()
            blockTouched = nil
            garbage.setScale(1.0)
        }
    }
    
    //Similar to snapPositiveBlockIntoPlace, but instead of snapping into bars tries to snap the block into a positive block. Called at the end of a touch.
    //Might make block touched nil, because it might snap the block into the garbage can
    func snapNegativeBlockIntoPlace(block: Block) {
        //If on top of a positive block, snap it on top of that block.
        for case let child as Block in self.children {
            if (child.getType() == "number" && blockTouched?.getType() == "subNumber") || (child.getType() == "variable" && blockTouched?.getType() == "subVariable")  {
                //We can only add one child, and we can't snap to blocks in the block banks
                if (abs(child.getTopRightY() - blockTouched!.getTopRightY()) < SNAPDISTANCE) && (abs(child.getTopRightX() - blockTouched!.getTopRightX()) < SNAPDISTANCE) && child.getSubtractionBlock() == nil && child != numBlockInBank && child != varBlockInBank{
                    //Send the subtraction block to be the child of the current block
                    child.setSubtractionBlock(block: blockTouched!)
                    //Aparently the zposition of the child doesn't matter it's all about the parent
                    child.zPosition = currentBlockZ
                    currentBlockZ += 6
                }
            }
        }
        // Are you dragging a block from the number bank? If you moved it "far enough", repopulate the numBlockBank.
        // If not, put the block back where it came from
        if (block == subNumBlockInBank) {
            //Block has moved outside of block bank
            if (abs(block.position.x - SUBNUMBLOCKBANKPOSITION.x) > CGFloat(block.getWidth()) || abs(block.position.y - SUBNUMBLOCKBANKPOSITION.y) > CGFloat(block.getHeight())) {
                let newBlock = Block(type: .subNumber, size: NUMBLOCKSIZE, value: "-1")
                scaleBorder(block: newBlock)
                newBlock.position = SUBNUMBLOCKBANKPOSITION
                subNumBlockInBank = newBlock
                self.addBlockChild(newBlock)
            }
            else {
                block.position = SUBNUMBLOCKBANKPOSITION
            }
        }
        
        // Are you dragging a block from the variable bank? If you moved it "far enough", repopulate the varBlockBank.
        // If not, put the block back where it came from
        if (block == subVarBlockInBank) {
            //Block has moved outside of block bank
            if (abs(block.position.x - SUBVARBLOCKBANKPOSITION.x) > CGFloat(block.getWidth()) || abs(block.position.y - SUBVARBLOCKBANKPOSITION.y) > CGFloat(block.getHeight())) {
                let newBlock = Block(type: .subVariable, size: VARBLOCKSIZE, value: "-1")
                scaleBorder(block: newBlock)
                newBlock.position = SUBVARBLOCKBANKPOSITION
                subVarBlockInBank = newBlock
                self.addBlockChild(newBlock)
            }
            else {
                //When we snap a block back into the var block bank we set the scale back to 1
                block.xScale = 1
                scaleBorder(block: block)
                block.getLabel().xScale = 1
                block.position = SUBVARBLOCKBANKPOSITION
            }
        }
        //Remove the block from the gamescene if it is on top of the garbage can when the touch ends
        if (blockOverGarbageCan(block: block)) {
            if blockTouched == vortex {
                vortex.position = VORTEXPOSITION
            }
            else {
                block.removeFromParent()
            }
            blockTouched = nil
            garbage.setScale(1.0)
        }
    }
    
    //Built in function that is called when your finger is lifted after a touch.
    //Snaps blocks into place, makes the blockTouched unhighlighed and unselected, does the vortexing if the vortex was being dragged.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightBlocksUnderVortex()
        if blockTouched != nil {
            let block = blockTouched!
            
            if block.getType() == "number" || block.getType() == "variable" {
                snapPositiveBlockIntoPlace(block: block)
                //Set the color to the not selected color
                block.color = .black
            }
            else if block.getType() == "vortex" {
                //First make a list of the blocks to remove so that when you start removing things it doesn't make other blocks seem like they are over the vortex after they shift. If the vortex is touching two blocks do subtraction on both of them
                var blocksToSubtractOn = [Block]()
                for case let blockToSubtractFrom as Block in self.children {
                    //We only want to deal with positive blocks, that have a child both smaller than them and with a value less than them(unless the values are the same then the width doesn't matter) that intersect the vortex.
                    if (blockToSubtractFrom.getType() == "variable" || blockToSubtractFrom.getType() == "number") && blockToSubtractFrom.getSubtractionBlock() != nil && (abs(blockToSubtractFrom.getSubtractionBlock()!.getValue()) <= blockToSubtractFrom.getValue()) &&
                        (((blockToSubtractFrom.getSubtractionBlock()!.getWidth() * Double(blockToSubtractFrom.xScale)) < blockToSubtractFrom.getWidth()) || (blockToSubtractFrom.getValue() == -1 * (blockToSubtractFrom.getSubtractionBlock()?.getValue())!)) && vortex.intersects(blockToSubtractFrom){
                            blocksToSubtractOn.append(blockToSubtractFrom)
                    }
                }
                //go through each block we are doing the subtraction from
                for blockToSubtractFrom in blocksToSubtractOn {
                    var newBlockValue = String(blockToSubtractFrom.getValue() + (blockToSubtractFrom.getSubtractionBlock()?.getValue())!)
                    if floor(Double(newBlockValue)!) == Double(newBlockValue) {
                        //Take away the decimals!
                        newBlockValue = String(format:"%.0f", Double(newBlockValue)!)
                    }
                    if Double(newBlockValue) == 0 {
                        removeBlockFromBarAndScootBlocksOver(block: blockToSubtractFrom)
                    }
                    //For numbers change the scale of the block here
                    else if blockToSubtractFrom.getType() == "number" {
                        let oldWidth = blockToSubtractFrom.getWidth()
                        blockToSubtractFrom.xScale = blockToSubtractFrom.xScale - ((blockToSubtractFrom.getSubtractionBlock()?.xScale)! * blockToSubtractFrom.xScale)
                        scaleBorder(block: blockToSubtractFrom)

                        blockToSubtractFrom.getLabel().xScale = 1 / blockToSubtractFrom.xScale
                        blockToSubtractFrom.setValue(value: newBlockValue)
                        let newWidth = blockToSubtractFrom.getWidth()
                        let shiftAmount = (CGFloat(oldWidth - newWidth)) * -1
                        blockToSubtractFrom.position.x = blockToSubtractFrom.position.x + (shiftAmount / 2)
                        
                        //Probls should make a function, but I didn't...
                        let indexInTopBar = findIndexOfBlock(bar: topBar, block: blockToSubtractFrom)
                        let indexInBottomBar = findIndexOfBlock(bar: bottomBar, block: blockToSubtractFrom)
                        
                        //The block is in the top bar
                        if (indexInTopBar > -1) {
                            shiftBlocks(bar: topBar, width:Double(shiftAmount), index:indexInTopBar)
                        }
                        //The block is in the bottom bar
                        if (indexInBottomBar > -1) {
                            shiftBlocks(bar: bottomBar, width:Double(shiftAmount), index:indexInBottomBar)
                        }

                        blockToSubtractFrom.removeSubtractionBlock()
                    }
                    //For variables changeBlockValue does the changing size and scooting things over
                    else {
                        blockToSubtractFrom.removeSubtractionBlock()
                        self.changeBlockValue(value: newBlockValue, block: blockToSubtractFrom)
                    }
                }
                vortex.position = VORTEXPOSITION
                self.highlightBlocksUnderVortex()
                
            }
            else {
                snapNegativeBlockIntoPlace(block: block)
                //Set the color to the not selected color
                block.color = .white
            }
            blockTouched = nil
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

