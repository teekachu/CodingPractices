import UIKit

// MARK: map(), reduce(), filter()

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
//  Takes 2 arguments, the initial value (0) and a closure {}
let average = values.reduce(0) {$0+$1} / values.count
//  taking initial value 0 and add the first item in values, and then take the sum to repeat. Hence why its important to put initial value
print(average)


// filter():
//  similar to map, applys "IF" statement to sequence and return sequence only containing satisfying results.
let numbersToFilter = [11,13,14,17,21,33,22]
let evenNumber = numbersToFilter.filter{ $0.isMultiple(of: 2)}
print(evenNumber)
//with closures expanded
let even = numbersToFilter.filter { (num: Int) -> Bool in
    return num % 2 == 0
}


// use it all together by chaining:
let now = 2020
let years = [ 1989,1992,1993, 1996, 1970, 2014, 2001]
// Q: find the combined age of all students born before 2000
// find all students born before 2000 -> find their age -> then combine all
let results = years.filter({$0 <= 2000}).map({now - $0}).reduce(0, +)
print(results)


// flatMap():
//  same as map(), but flattens resulting sequence.
let numbers = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
let result = numbers.flatMap({ $0 })
print(result) // returns one single array with 1-9 in it.

let giraffes = [[5, 6, 9], [11, 2, 13, 20], [1, 13, 7, 8, 2]]
let tallerThan10 = giraffes.flatMap({$0}).filter({$0>10})
print(tallerThan10)

//flatmap() versus map()
let tallestFlatMap = giraffes.flatMap({ $0.filter({ $0 > 10 }) })
let tallestMap = giraffes.map({$0.filter({$0 > 10})})

print(tallestFlatMap) // [11, 13, 20, 13]
print(tallestMap) // [[], [11, 13, 20], [13]]


//compactMap():
//  working with optionals
let input = ["1","5","dog"]
let numbers = input.compactMap{Int($0)}
print(numbers)
//  This is because after compactMap, the results become [ optional(1), optional(5), and nil ], so the function got rid of the nil.


// MARK: Arrays : items in array must conform to the Equatable protocol - can be compared with the == operator to check if two items are equal.

var names = ["Ford", "Arthur", "Trillian", "Zaphod", "Marvin", "Deep Thought", "Eddie", "Slartibartfast", "Humma Kuvula"]

if let index = names.firstIndex(of: "Ford"){
    print(index)
}

if let nameIndex = names.firstIndex(of: "Deep Thought"){
    names[nameIndex] = "Teeks"
    print(nameIndex)
}

//firstIndex(where:) returns the index of the first item matching a predicate
//lastIndex(where:) returns the index of the last item matching a predicate

let grades = [8, 9, 10, 1, 2, 5, 3, 4, 8, 8]

if let index = grades.firstIndex(where: {$0 > 9}) {
    print("The index of first num greater than 9 is : \(index)")
}

//contains(where:) returns a boolean indicating if the array contains an element matching a predicate
grades.contains(where: {$0 == 10}) ? print("true") : print("false")

// ~= is pattern matching operator. essentially the same as (0...5).contains($0)
grades.contains(where: { 0...5 ~= $0}) // true

//allSatisfy(_:) returns a boolean indicating if all of the items in the array match a predicate
grades.allSatisfy({$0 > 0 && $0 < 9}) // false

//first(where:) returns the first item (not an index) of the array that matches a predicate
//last(where:) returns the last item (not an index) of the array that matches a predicate

// all(where: ) finding all items in an array that match a given predicate.
// function that takes param called predicate and returns an array, the param is a closure that takes a param of Element and returns bool

// CompactMap() similar to map() and also removes nil.

extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element]  {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}

let goodGrades = grades.all(where: {$0 > 8})
print(goodGrades)

