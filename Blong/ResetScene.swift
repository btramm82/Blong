//
//  ResetScene.swift
//  Blong
//
//  Created by BRIAN TRAMMELL on 4/20/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

import SpriteKit

let GameResetCategoryName = "gameReset"

class ResetScene: SKScene {

    var scored : Bool = false {
        // 1.
        didSet {
            let gameResetLabel = childNodeWithName(GameResetCategoryName) as! SKLabelNode!
            let gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene!
            gameResetLabel.text = scored ? "Point for Player" : "Point for CPU"
            if score >= 21 {
                gameResetLabel.text = "Player Wins The Game"
            } else if CPUScore >= 21 {
                gameResetLabel.text = "CPU Wins The Game"
            }
        }
    }


    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let view = view {
            // 2. 
            let gameScene = GameScene.unarchiveFromFile("GameScene") as! GameScene!
            view.presentScene(gameScene)
        }
    }
}
