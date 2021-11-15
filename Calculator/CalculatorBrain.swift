//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 황희담 on 2021/11/15.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double{
    return op1 * op2
}

class CalculatorBrain {
    
    private var accumulator: Double = 0.0
    
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "±" : Operation.UnaryOperation({-$0}),
        "x" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let associatedValue):
                accumulator = associatedValue
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingOperation()
                pending = nil
            }
        }
    }
    
    private func executePendingOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    // class와 비슷하지만 상속할 수 없고 enum처럼 값으로 전달(passed by value)되는 구조체
    private struct PendingBinaryOperationInfo{
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    // get만 있으면 read-only property
    var result: Double{
        get{
            return accumulator
        }
    }
}
