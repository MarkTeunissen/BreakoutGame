//
//  SettingsViewController.swift
//  BreakoutGame
//
//  Created by Mark on 24-05-16.
//  Copyright © 2016 MarkTeunissen. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    var balls = 0
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var specialBricksLabel: UILabel!
    @IBOutlet weak var specialBricksStepper: UIStepper!
    @IBOutlet weak var bricksLabel: UILabel!
    @IBOutlet weak var bricksStepper: UIStepper!
    @IBOutlet weak var ballsSegment: UISegmentedControl!
    @IBOutlet weak var childMode: UISwitch!
    
    @IBAction func speedSliderValueChanged(sender: UISlider) {
        var currentValue = Double(sender.value)
        currentValue = Double(round(100*currentValue)/100)
        Settings().Speed = currentValue
        speedLabel.text? =  "\(Settings().Speed!)"
        speedSlider.value = Float(Settings().Speed!)
       
    }

    @IBAction func specialBricksStepperValueChanged(sender: UIStepper) {
        let specialBricksAmount = Int(sender.value)
        specialBricksLabel.text = "\(specialBricksAmount)"
        Settings().SpecialBricks = specialBricksAmount
        brickAmount()
    }
    
    @IBAction func bricksStepperValueChanged(sender: UIStepper) {
        let bricksAmount = Int(sender.value)
        bricksLabel.text = "\(bricksAmount)"
        Settings().Bricks = bricksAmount
        brickAmount()
    }
    
    @IBAction func BallsSegmentValueChanged(sender: UISegmentedControl) {
        switch ballsSegment.selectedSegmentIndex
        {
        case 0:     Settings().Balls = 1
        case 1:     Settings().Balls = 2
        case 2:     Settings().Balls = 3
        default:    Settings().Balls = 1
        }
    }
    
    @IBAction func childmodeValueChanged(sender: UISwitch) {
        if childMode.on {
            Settings().Childmode = true
        } else {
            Settings().Childmode = false
        }
    }
    
    func brickAmount() {
        let maxAmountOfBricks = 20
        var currentAmountOfBricks = 0
        currentAmountOfBricks = totalBricksCount() + totalSpecialBricksCount()
        
        if currentAmountOfBricks == maxAmountOfBricks {
            specialBricksStepper.maximumValue = Double(specialBricksLabel.text!)!
            bricksStepper.maximumValue = Double(bricksLabel.text!)!
        }
        else {
            specialBricksStepper.maximumValue = 20
            bricksStepper.maximumValue = 20
        }
    }
    
    func totalBricksCount() -> Int{
        return Int(bricksLabel.text!)!
    }
    
    func totalSpecialBricksCount() -> Int{
        return Int(specialBricksLabel.text!)!
    }
    
    func onStartUp() {
        self.speedSlider.value = Float(Settings().Speed!)
        ballsSegment.selectedSegmentIndex = (Settings().Balls! - 1)
        bricksLabel.text! = "\(Settings().Bricks!)"
        bricksStepper.value = Double(Settings().Bricks!)
        specialBricksLabel.text! = "\(Settings().SpecialBricks!)"
        specialBricksStepper.value = Double(Settings().SpecialBricks!)
        speedLabel.text! = "\(Settings().Speed!)"
        childMode.on = Settings().Childmode!
    }
    
    override func viewWillAppear(animated: Bool) {
        onStartUp()
    }
}
