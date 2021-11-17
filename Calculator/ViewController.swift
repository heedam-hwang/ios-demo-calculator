//
//  ViewController.swift
//  Calculator
//
//  Created by 황희담 on 2021/11/15.
//

import UIKit

class ViewController: UIViewController {
    
    private var userTyping = false
    
    //computed property
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBOutlet private weak var display: UILabel!
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userTyping{
            let textInDisplay = display.text!
            display.text = textInDisplay + digit
        } else {
            display.text = digit
        }
        userTyping = true
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userTyping{
            brain.setOperand(operand: displayValue)
            userTyping = false
        }
        if let symbol = sender.currentTitle{
            brain.performOperation(symbol: symbol)
            displayValue = brain.result
        }
        
    }

    var savedProgram: CalculatorBrain.PropertyList?
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
}

