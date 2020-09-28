import UIKit

// map():
//  loops every item in the sequence and apply the same function to each. Return same sequence after transformation.
//  Tranform array of temperatures in Celsius to Fahrenheit.
let celsius = [-5.0, 10.0, 21.0, 33.0, 50.0]
var fehrenheit: [Double] = celsius.map {$0 * 9/5 + 32}
print(fehrenheit)

//  the longer version:
var longerFehrenheit: [Double] =
    celsius.map { (input:Double) -> Double in
        return input * (9/5) + 32
    }
print(longerFehrenheit)


// reduce():
//  loops all items and reduce them into one single value. Return single value.
let values = [3,4,5]
let reducedSum = values.reduce(0, +)
print(reducedSum)
// Takes 2 arguments, the initial value (0) and a closure {}
let average = values.reduce(0) {$0+$1} / values.count
//taking initial value 0 and add the first item in values, and then take the sum to repeat. Hence why its important to put initial value
print(average)


// filter():
//  similar to map, applys "IF" statement to sequence and return sequence only containing satisfying results.



// flatMap():
//  same as map(), but flattens resulting sequence.
let input = ["1","5","dog"]
let numbers = input.compactMap{Int($0)}
print(numbers)
//  This is because after flatmap, the results become [ optional(1), optional(5), and nil ], so flatmap got rid of the nil.


//compactMap():
//
