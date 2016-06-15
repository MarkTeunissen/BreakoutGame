//
//  GameBehavior.swift
//  BreakoutGame
//
//  Created by Mark on 26-05-16.
//  Copyright © 2016 MarkTeunissen. All rights reserved.
//

import UIKit

class GameBehavior: UIDynamicBehavior {

    let gravity = UIGravityBehavior()
    
    lazy var collision: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
    }()
    
    lazy var brickBehaviour: UIDynamicItemBehavior = {
        let lazilyCreatedBrickBehaviour = UIDynamicItemBehavior()
        lazilyCreatedBrickBehaviour.allowsRotation = false
        lazilyCreatedBrickBehaviour.elasticity = 1.0
        lazilyCreatedBrickBehaviour.friction = 0.0
        lazilyCreatedBrickBehaviour.resistance = 0.0
        return lazilyCreatedBrickBehaviour
    }()
    
    lazy var ballBehaviour: UIDynamicItemBehavior = {
        let lazilyCreatedBallBehaviour = UIDynamicItemBehavior()
        lazilyCreatedBallBehaviour.allowsRotation = true
        lazilyCreatedBallBehaviour.elasticity = 1.0
        lazilyCreatedBallBehaviour.friction = 0.0
        lazilyCreatedBallBehaviour.resistance = 0.0
        lazilyCreatedBallBehaviour.density = 0.0001
        return lazilyCreatedBallBehaviour
    }()
    
    lazy var paddleBehaviour: UIDynamicItemBehavior = {
        let paddleDynamicProperties = UIDynamicItemBehavior()
        paddleDynamicProperties.density = 10000000
        paddleDynamicProperties.allowsRotation = false
        return paddleDynamicProperties
    }()
    
    override init() {
        super.init()
        addChildBehavior(collision)
        addChildBehavior(gravity)
        addChildBehavior(brickBehaviour)
        addChildBehavior(ballBehaviour)
        addChildBehavior(paddleBehaviour)
    }
    
    func addDrop(view: UIView) {
        dynamicAnimator?.referenceView?.addSubview(view)
        collision.addItem(view)
        brickBehaviour.addItem(view)
    }
    
    func childmodeEnabled(view: UIView) {
        collision.addItem(view)
    }
    
    func paddleBehaviour(paddle: UIView) {
    }
    
    func pushBall(ball: UIView) {
        let push = UIPushBehavior(items: [ball], mode: .Instantaneous)
        let speed = CGFloat(Settings().Speed!)
        push.magnitude = speed / 30000
        
        push.angle = CGFloat(Double(arc4random()) * M_PI * 2 / Double(UINT32_MAX))
        push.action = { [weak push] in
            if !push!.active {
                self.removeChildBehavior(push!)
            }
        }
        collision.addItem(ball)
        addChildBehavior(push)
    }
    
    func removeBall(view: UIView) {
        collision.removeItem(view)
        view.removeFromSuperview()

    }
    
    func removePaddle(view: UIView) {
        collision.removeItem(view)
        paddleBehaviour.removeItem(view)
        view.removeFromSuperview()
    }
    
    func removeDrop(view: UIView) {
        gravity.removeItem(view)
        collision.removeItem(view)
        brickBehaviour.removeItem(view)
        view.removeFromSuperview()
    }
    
    func addBarrier(path: UIBezierPath, named name: NSCopying) {
        removeBarrier(name)
        collision.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(name: NSCopying) {
        collision.removeBoundaryWithIdentifier(name)
    }
}
