//
//  GameScene.swift
//  GameTest
//
//  Created by Zoe Peterson on 10/29/16.
//  Copyright © 2016 Zoe Peterson. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        let block = SKSpriteNode(color: SKColor.orange, size: CGSize(width:50, height: 50))
        block.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        self.addChild(block)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        //The _ should maybe be touch
        for _: AnyObject in touches {
            
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}

