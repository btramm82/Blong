//
//  GameScene.swift
//  Blong
//
//  Created by BRIAN TRAMMELL on 4/15/15.
//  Copyright (c) 2015 TDesigns. All rights reserved.
//

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let CPUPaddleCategoryName = "cpuPaddle"


let BallCategory : UInt32 = 0x1 << 0
let LeftWallCategory : UInt32 = 0x1 << 1
let RightWallCategory : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let CPUPaddleCategory : UInt32 = 0x1 << 4

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isFingerOnPaddle = false

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // 1. Create the physics body that borders the screen
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // 2. Set the friction of that physicsBody to 0
        borderBody.friction = 0
        // 3. Set physicsBody of the scene to borderBody
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        physicsWorld.contactDelegate = self
        
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(10, -10))
        
        let leftWall = SKNode()
        leftWall.physicsBody = SKPhysicsBody (edgeLoopFromRect: CGRectMake(1.0, 1.0, 1.0, CGRectGetHeight(self.frame)))
        self.addChild(leftWall)
        
        let rightWall = SKNode()
        rightWall.physicsBody = SKPhysicsBody (edgeLoopFromRect: CGRectMake(CGRectGetWidth(self.frame) - 1.0, 1.0, 1.0, CGRectGetHeight(self.frame)))
        self.addChild(rightWall)
        
        
        let paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode!
        let cpuPaddle = childNodeWithName(CPUPaddleCategoryName) as! SKSpriteNode!
        
        leftWall.physicsBody!.categoryBitMask = LeftWallCategory
        rightWall.physicsBody!.categoryBitMask = RightWallCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        cpuPaddle.physicsBody!.categoryBitMask = CPUPaddleCategory
        
        ball.physicsBody!.contactTestBitMask = LeftWallCategory | RightWallCategory
        
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            var touchLocation = touch.locationInNode(self)
            
            if let body = physicsWorld.bodyAtPoint(touchLocation) {
                if body.node!.name == PaddleCategoryName {
                    println("Began touch on paddle")
                    isFingerOnPaddle = true
                } else if let body = physicsWorld.bodyAtPoint(touchLocation) {
                    if body.node!.name == CPUPaddleCategoryName {
                        println("Began touch on CPU Paddle")
                        isFingerOnPaddle = true
                    }
                }
                super.touchesBegan(touches , withEvent:event)
            }
        }
    }


    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // 1. Check whether user touched the paddle
        if isFingerOnPaddle {
            // 2. Get touch location
            var touch = touches.first as! UITouch
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
             
            // 3. Get node for paddle
            var paddle = childNodeWithName(PaddleCategoryName) as! SKSpriteNode!
           
            
            // 4. Calculate new position along x for paddle
                var paddleY = paddle.position.y + (touchLocation.y - previousLocation.y)
            
            
            // 5. Limit Y so that paddle won't leave screen to top or bottom
            paddleY = max(paddleY, paddle.size.height)
            paddleY = min(paddleY, paddleY, size.width - paddle.size.height)
            
           
            
            // 6. Update paddle position
            paddle.position = CGPointMake(paddle.position.x , paddleY)
        
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    isFingerOnPaddle = false
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //1. Create Local Vairables for Two Physics Bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //2. Assign two physics bodies so that the one with the lower cateogry is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 3. react tot he contact between ball and left
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == LeftWallCategory {
            println("Hit Left Wall. First Contact has been Made")
        } else if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == RightWallCategory {
            println("Hit Right Wall. First Contact has been Made")
            }
        }
    }




