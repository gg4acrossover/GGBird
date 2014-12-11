//
//  GGScene.swift
//  GGBird
//
//  Created by hq viet on 9/23/14.
//  Copyright (c) 2014 __GG4aCrossover__. All rights reserved.
//

import Foundation
import SpriteKit

class GGScene : SKScene
{
    /* ======================================================
     * TODO: properties
     * ====================================================== */
    var _bird : SKSpriteNode!;
    var _land : SKSpriteNode!;
    var _pipe1 : GGPipe!;
    var _strScore : SKLabelNode!;
    var _startTime : Float!;
    var _force : Float!;
    var _score : Int!;
    var _isUpdateScore : Bool!;
    
    let VELOCITY_BG : CGFloat = 3.0;
    let VELOCITY_PIPE : CGFloat = 2.5;
    
    /* ======================================================
     * TODO: init
     * ====================================================== */
    required init(coder aDecoder: NSCoder)
    {
        fatalError("No NSCoder");
    }
    
    override init(size: CGSize)
    {
        super.init(size: size);
        
        ////////////////////// INIT VALUE
        self._startTime = 0.01;
        self._force = 0.8;
        self._score = 0;
        self._isUpdateScore = false;
        
        ////////////////////// SET GRAPHIC
        /** bird **/
        self._bird = SKSpriteNode(imageNamed: "bird-01");
        self._bird.position = CGPoint( x: 50.0, y: size.height - 200.0);
        self._bird.setScale(1.2);
        self.addChild( self._bird);
        self._bird.zPosition = 10;
        
        /** land **/
        self._land = SKSpriteNode(imageNamed: "land");
        self._land.anchorPoint = CGPointZero;
        self.addChild(self._land);
        
        var landClone = SKSpriteNode(texture: self._land.texture);
        landClone.position = CGPoint( x: self._land.size.width, y: 0.0);
        landClone.anchorPoint = CGPointZero;
        self._land.addChild(landClone);
        
        /** bg **/
        var bg = SKSpriteNode(imageNamed: "sky");
        bg.anchorPoint = CGPointZero;
        bg.position.y = landClone.size.height;
        bg.setScale(1.5);
        self.addChild( bg);
        
        //NSLog("size bg \(self._bg.size.width)");
        
        self._land.zPosition = 10;
        self.backgroundColor = UIColor(red: 0, green: 255, blue: 255, alpha: 1);
        
        /** Pipe **/
        self._pipe1 = GGPipe();
        self._pipe1.position = CGPoint(x: size.width/2, y: size.height);
        self.addChild(self._pipe1);
        
        /** Score **/
        self._strScore = SKLabelNode(text: "0");
        self._strScore.fontSize = 50;
        self._strScore.fontColor = UIColor.blackColor();
        self._strScore.position = CGPoint(x: self.size.width - 80.0, y: self.size.height - 80.0);
        self.addChild( self._strScore);
        
        //////////////////////// ACTION
        /** bird anim **/
        var arrTexture = [SKTexture](); // empty array
        for(var i = 1; i < 4; ++i)
        {
            var textureName = "bird-0\(i)";
            arrTexture.append(SKTexture(imageNamed: textureName));
        }
        
        let anim = SKAction.animateWithTextures( arrTexture, timePerFrame: 0.15);
        let repeatAnim = SKAction.repeatActionForever(anim);
        self._bird.runAction(repeatAnim);
    }
    
    /* ======================================================
     * TODO: update
     * ====================================================== */
    override func update(currentTime: NSTimeInterval)
    {
        if(self._land == nil && self._bird == nil) {return;}
        
        /** check game over **/
        if ( self.isBirdCollisionWithLand() || self.isBirdCollisionWithPipe())
        {
            return;
        }
        
        //NSLog("\(self._pipe1.frame.origin.x)");
        
        /* update score */
        self.updateScore();
        
        /** formula move along axis Y **/
        var dy = self._bird.position.y + CGFloat(self._force) +
                 CGFloat(-9.8*self._startTime*self._startTime*0.5);
        self._startTime! += 0.05;
        
        /** bird move along axis Y **/
        self._bird.position.y = dy;
        
        /** BG Move **/
        var dx = self._land.position.x - VELOCITY_BG;
        
        if(dx < -self._land.size.width)
        {
            dx += self._land.size.width;
        }
        
        /** Pipe move **/
        self.updatePipe();
        
        self._land.position.x = dx;
    }
    
    ////////////// UPDATE PIPE MOVE ///////////////////////
    func updatePipe() -> Void
    {
        if(self._pipe1 == nil) {return;}
        
        var dx = self._pipe1.position.x - VELOCITY_PIPE;
        
        if(self._pipe1.position.x < -self._pipe1.size.width/2)
        {
            dx = self.size.width + self._pipe1.size.width/2;
            self._isUpdateScore = false; // reset to update score
        }
        
        self._pipe1.position.x = dx;
    }
    
    ////////////// UPDATE COLLISION WITH LAND //////////////
    func isBirdCollisionWithLand() -> Bool
    {
        if(self._bird == nil) { return false };
        
        if( CGFloat(self._bird.position.y - self._bird.size.height/2) < self._land.size.height)
        {
            self._bird.removeAllActions();
            return true;
        }
        
        return false;
    }
    
    ////////////// UPDATE COLLISION WITH PIPE//////////////
    func isBirdCollisionWithPipe() -> Bool
    {
        if(self._pipe1 == nil) { return false; }
        
        if( CGRectIntersectsRect(self._pipe1.frame, self._bird.frame) )
        {
            //NSLog("COLLISON WITH PIPE");
            return true;
        }
        
        var recPipeDown = self._pipe1.frame;
        
        recPipeDown.origin.y =  self._pipe1.frame.origin.y -
                                self._pipe1.frame.size.height -
                                CGFloat( GGPipe().DISTANCE_2_PIPE) +
                                18.0 /* alpha */;
        
        recPipeDown.origin.x = self._pipe1.frame.origin.x;
        
        //NSLog("\( recPipeDown.origin.x)");
        
        if( CGRectIntersectsRect( recPipeDown, self._bird.frame) )
        {
            //NSLog("COLLISON WITH PIPE DOWN");
            return true;
        }

        
        return false;
    }
    
    ////////////// UPDATE SCORE //////////////
    func updateScore() -> Void
    {
        if( self._strScore == nil)
        {
            return;
        }
        
        if( (self._bird.position.x > self._pipe1.position.x) && !self._isUpdateScore )
        {
            ++self._score!;
            self._strScore.text = "\(self._score)";
            self._isUpdateScore = true;
        }
    }
    
    /* ======================================================
     *  TODO: touch event
     * ====================================================== */
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        if( (self._bird.position.y > self.size.height - 50.0) ||
            self.isBirdCollisionWithLand() )
        {
            return;
        }
        
        var touch : AnyObject! = touches.anyObject();
        var lo = touch.locationInNode(self);
        
        self._force = 4.0;
        self._startTime = 0.0;

    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        // ..nothing
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        // ..nothing
    }
}