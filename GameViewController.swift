//
//  GameViewController.swift
//  BreakoutGame
//
//  Created by Mark on 24-05-16.
//  Copyright © 2016 MarkTeunissen. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var gameView: UIView!
    
    private var numBalls: Int = 1
    private var numBricks: Int = 5
    private var numSpecialBricks: Int = 5
    private var speed: Double = 0.50
    private var childMode: Bool = true
    private let rowNumber = 5
    private var ball = UIView(frame: CGRect())
    private let crossbar = UIView(frame: CGRect())
    private var brickSpacing:CGFloat = 5.0
    private var brickTopSpacing:CGFloat = 40.0
    private var paddleBottomSpacing:CGFloat = 100.0
    private let gameBehavior = GameBehavior()
    private var attachment = UIAttachmentBehavior?.self
    private var getPos = CGPoint(x: 5.0, y: 20.0)
    private var paddleSize = CGSize(width: 80.0, height: 10.0)
    private var childSize = CGSize(width: 1080 , height: 5.0)
    private var ballSize = CGSize(width: 20.0, height: 20.0)
    private var position: Int = 0
    private var bricksRemaining: Int = 0
    private var collision = UICollisionBehavior()
    static let pathName = "paddlePath"
    
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedDynamicAnimator = UIDynamicAnimator(referenceView: self.gameView)
        return lazilyCreatedDynamicAnimator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameBehavior.collision.collisionDelegate = self
        if Settings().Balls == nil { Settings().setSettingsOnStartUp() }
        if Settings().Childmode == true { childmodeEnabled.willRemoveSubview(crossbar) }
        
        animator.addBehavior(gameBehavior)
        paddle.backgroundColor = UIColor.blueColor()
        bricksRemaining = Settings().SpecialBricks! + Settings().Bricks!
        placeSpecialBricks(Settings().SpecialBricks! / rowNumber)
        placeBricks(Settings().Bricks! / rowNumber)
        createBall()
    }
    
    private struct Brick {
        var view: UIView
    }
    
    var brickSize: CGSize {
        let width = (gameView.bounds.size.width - 30) / CGFloat(rowNumber)
        let height = width / 4
        return CGSize(width: width, height: height)
    }
    
    private lazy var childmodeEnabled: UIView = {
        let crossbar = UIView(
            frame: CGRect(origin: CGPoint(
            x: 0,
            y: self.gameView.bounds.size.height - 55),
            size: self.childSize))
        crossbar.backgroundColor = UIColor.lightGrayColor()
        print("childMode enabled")
        self.gameView.addSubview(crossbar)
        
        return crossbar
    }()
    
    private lazy var paddle: UIView = {
        let paddle = UIView(
            frame: CGRect(origin: CGPoint(
            x: (self.gameView.bounds.size.width / 2) - (self.paddleSize.width / 2),
            y: self.gameView.bounds.size.height - self.paddleBottomSpacing),
            size: self.paddleSize))
        paddle.backgroundColor = UIColor.blueColor()
        self.gameView.addSubview(paddle)
        return paddle
    }()
    
    private func createBall() {
        print(Settings().Balls!)
        var i = 0
        var pos = CGPoint(x: (self.gameView.bounds.size.width / 2) - (self.paddleSize.width / 2), y: self.gameView.bounds.size.height - (self.paddleBottomSpacing + (self.paddleSize.height * 2)))
        repeat {
            print("adding balls")
            ball = UIView(frame: CGRect(origin: pos, size: ballSize))
            ball.backgroundColor = UIColor.greenColor()
            ball.layer.cornerRadius = 10
            pos.x = pos.x + ballSize.width + 3.0
            i += 1
            placeBall(ball)
        } while i < Settings().Balls!
    }
    
    private func placeBall(ball: UIView) -> UIView  {
        var i = 0
        repeat {
            var center = paddle.center
            center.y -= paddleSize.height / 2.0 + paddleSize.height
            center.x += ballSize.width
            self.gameView.addSubview(ball)
            gameBehavior.ballBehaviour.addItem(ball)
            i += 1
            print("balls placed")
            gameBehavior.pushBall(ball)
        } while i < Settings().Balls
        return ball
    }

    @IBAction func controlPaddle(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Changed:
            paddleBounds(sender.translationInView(gameView))
            sender.setTranslation(CGPointZero, inView: gameView)
        case .Ended:
            fallthrough
        default:
            break
        }
    }
    
    @IBAction func controlBalls(sender: UITapGestureRecognizer) {
        gameBehavior.pushBall(ball)
    }
    
    func placeBricks(numColumns: Int) {
        var bricksRow = 0
        var columns = 0
        while columns < numColumns {
            while bricksRow < rowNumber {
                let frame = CGRect(origin: (getPos), size: brickSize)
                getPos.x += brickSize.width + brickSpacing
                let placeBrick = Brick.init(view: UIView(frame: frame))
                placeBrick.view.backgroundColor = UIColor.blueColor()
                gameView.addSubview(placeBrick.view)
                gameBehavior.addDrop(placeBrick.view)
                bricksRow += 1
                position += 1
            }
            columns += 1
            bricksRow = 0
            getPos.y = getPos.y + brickTopSpacing
            getPos.x = 5.0
        }
    }

    func placeSpecialBricks(numColumns: Int) {
        var bricksRow = 0
        var columns = 0
        while columns < numColumns {
            while bricksRow < rowNumber {
                let frame = CGRect(origin: (getPos), size: brickSize)
                getPos.x += brickSize.width + brickSpacing
                let placeBrick = Brick.init(view: UIView(frame: frame))
                placeBrick.view.backgroundColor = UIColor.redColor()
                gameView.addSubview(placeBrick.view)
                gameBehavior.addDrop(placeBrick.view)
                bricksRow += 1
                position += 1
            }
            columns += 1
            bricksRow = 0
            getPos.y = getPos.y + brickTopSpacing
            getPos.x = 5.0
        }
    }
    
    
    private func paddleBounds(translation: CGPoint) {
        var origin = paddle.frame.origin
        origin.x = max(min(origin.x + translation.x, gameView.bounds.maxX - paddleSize.width), 0.0)
        paddle.frame.origin = origin
        paddle.backgroundColor = UIColor.blueColor()
        gameBehavior.addBarrier(UIBezierPath(roundedRect: paddle.frame, cornerRadius: 5.0), named: "path")
        
    }
    
    private func loadSettings() {
        numBalls = Settings().Balls!
        numBricks = Settings().Bricks!
        numSpecialBricks = Settings().SpecialBricks!
        speed = Settings().Speed!
        childMode = Settings().Childmode!
    }


    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem) {
        if let view = item1 as? UIView  {
            if view.backgroundColor == UIColor.blueColor(){
                gameBehavior.removeDrop(view)
                bricksRemaining -= 1
            }
            else if view.backgroundColor == UIColor.redColor(){
                view.backgroundColor = UIColor(red: 1, green: 0.6196, blue: 0.6196, alpha: 1.0)
                print("ball colored")
                
            }
            else if view.backgroundColor == UIColor(red: 1, green: 0.6196, blue: 0.6196, alpha: 1.0) {
                gameBehavior.removeDrop(view)
                bricksRemaining -= 1
            }
            if bricksRemaining == 0 {
                for view in gameView.subviews {
                    gameBehavior.removeDrop(view)
                }
            }
        }
    }
}