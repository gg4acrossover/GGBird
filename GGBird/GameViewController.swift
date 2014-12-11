//
//  GameViewController.swift
//  GGBird
//
//  Created by hq viet on 9/23/14.
//  Copyright (c) 2014 __GG4aCrossover__. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var _scenePlay : GGScene!;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var screen = self.view as SKView;
        
        self._scenePlay = GGScene(size: screen.bounds.size);
        screen.presentScene( self._scenePlay);
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
