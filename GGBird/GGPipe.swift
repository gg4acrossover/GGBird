//
//  GGPipe.swift
//  GGBird
//
//  Created by hq viet on 9/23/14.
//  Copyright (c) 2014 __GG4aCrossover__. All rights reserved.
//

import Foundation
import SpriteKit

class GGPipe : SKSpriteNode
{
    /* =========================================
     * TODO: initialize properties
     * ========================================= */
    var _pipeDown : SKSpriteNode!;
    let DISTANCE_2_PIPE = 140.0;
    
    /* =========================================
    * TODO: init func
    * ========================================= */
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init( texture: texture, color: color, size: size);
        
        self._pipeDown = SKSpriteNode(texture: self.texture);
        self._pipeDown.position.y = self.position.y - self.size.height/2 - CGFloat(DISTANCE_2_PIPE);
        self._pipeDown.zRotation = CGFloat(M_PI);
        self.addChild(self._pipeDown);
        
        self.setScale(2);
    }
    
    override convenience init()
    {
        let color = UIColor()
        let texture = SKTexture(imageNamed: "PipeDown")
        let size = texture.size();
        self.init(texture: texture, color: color, size: size);
    }
    
    /* =========================================
     * TODO: getPipe Down
     * ========================================= */

    func getPipeDown() ->SKSpriteNode
    {
        return self._pipeDown;
    }    
}