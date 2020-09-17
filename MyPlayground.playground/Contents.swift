import UIKit

//**Matrix sample questions

//
//1. Do not count any of the 0, or ANY of the number below 0
//
//[[0,1,1,2],
// [0,5,0,0],
// [2,0,3,3]]
//
//
//Expected Output: 9

//Note that this runs vertically first, which is up and down instead of left and right.
func matrixElementsSum(matrix: [[Int]]) -> Int {

    var sum = 0

    for column in 0..<matrix[0].count {
        for row in 0..<matrix.count {

            if matrix[row][column] != 0 {
                print(matrix[row][column])
                sum += matrix[row][column]
            } else {
                print("skipped")
                break
            }
        }
    }
    return sum
}

matrixElementsSum(matrix:
                    [[1,1,1,0],
                     [0,5,0,1],
                     [2,1,3,10]])

print("***Break Q1***")

//2. calculate the determinant of 2x2 matrix
//[[a,b],[c,d]] -> ad - bc

func calc(_ matrix: [[Int]]) -> Int{
    //[row][column]
    let a = matrix[0][0]
    let b = matrix[0][1]
    let c = matrix[1][0]
    let d = matrix[1][1]

    return a*d - b*c
}

calc([[1,2], [3,4]])

print("***Break Q2***")

//3. Given an array of strings, return another array containing the longest strings

func allLongestStrings(inputArray: [String]) -> [String] {
    var longStringArr = [String]()
    var wordCount = 0

    for word in inputArray{
        if word.count > wordCount{
            wordCount = word.count
        }
    }
    print(wordCount)

    for word in inputArray{
        if word.count == wordCount{
            longStringArr.append(word)
        }
    }

    return longStringArr
}


allLongestStrings(inputArray: ["abc","eeee","abcd","dcd"])

print("***Break Q3***")

//4. Given 2 Strings, find number of common characters between both
// exp: For s1 = "aabcc" and s2 = "adcaa", the output should be
//commonCharacterCount(s1, s2) = 3 ("a,a,c")

//let line = "abcd"
//let lineItems = Array(line)
//print(lineItems)

func commonCharacterCount(s1: String, s2: String) -> Int {
    
    var sameLtr = 0
    var mutatingS2 = s2
    
    for ltr in s1{
        if mutatingS2.contains(ltr){
            let index = mutatingS2.firstIndex(of: ltr)
            mutatingS2.remove(at: index!)
            sameLtr += 1
        }
    }
    
    return sameLtr
    
}

commonCharacterCount(s1:"aabcc", s2: "adcaa")

print("***Break Q4***")


