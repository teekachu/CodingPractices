import UIKit

////**Matrix sample questions
//
////
////1. Do not count any of the 0, or ANY of the number below 0
////
////[[0,1,1,2],
//// [0,5,0,0],
//// [2,0,3,3]]
////
////
////Expected Output: 9
//
////Note that this runs vertically first, which is up and down instead of left and right.
//func matrixElementsSum(matrix: [[Int]]) -> Int {
//
//    var sum = 0
//
//    for column in 0..<matrix[0].count {
//        for row in 0..<matrix.count {
//
//            if matrix[row][column] != 0 {
//                print(matrix[row][column])
//                sum += matrix[row][column]
//            } else {
//                print("skipped")
//                break
//            }
//        }
//    }
//    return sum
//}
//
//matrixElementsSum(matrix:
//                    [[1,1,1,0],
//                     [0,5,0,1],
//                     [2,1,3,10]])
//
//print("***Break Q1***")
//
////2. calculate the determinant of 2x2 matrix
////[[a,b],[c,d]] -> ad - bc
//
//func calc(_ matrix: [[Int]]) -> Int{
//    //[row][column]
//    let a = matrix[0][0]
//    let b = matrix[0][1]
//    let c = matrix[1][0]
//    let d = matrix[1][1]
//
//    return a*d - b*c
//}
//
//calc([[1,2], [3,4]])
//
//print("***Break Q2***")
//
////3. Given an array of strings, return another array containing the longest strings
//
//func allLongestStrings(inputArray: [String]) -> [String] {
//    var longStringArr = [String]()
//    var wordCount = 0
//
//    for word in inputArray{
//        if word.count > wordCount{
//            wordCount = word.count
//        }
//    }
//    print(wordCount)
//
//    for word in inputArray{
//        if word.count == wordCount{
//            longStringArr.append(word)
//        }
//    }
//
//    return longStringArr
//}
//
//
//allLongestStrings(inputArray: ["abc","eeee","abcd","dcd"])
//
//print("***Break Q3***")
//
////4. Given 2 Strings, find number of common characters between both
//// exp: For s1 = "aabcc" and s2 = "adcaa", the output should be
////commonCharacterCount(s1, s2) = 3 ("a,a,c")
//
////let line = "abcd"
////let lineItems = Array(line)
////print(lineItems)
//
//func commonCharacterCount(s1: String, s2: String) -> Int {
//
//    var sameLtr = 0
//    var mutatingS2 = s2
//
//    for ltr in s1{
//        if mutatingS2.contains(ltr){
//            let index = mutatingS2.firstIndex(of: ltr)
//            mutatingS2.remove(at: index!)
//            sameLtr += 1
//        }
//    }
//
//    return sameLtr
//
//}
//
//commonCharacterCount(s1:"aabcc", s2: "adcaa")
//
//print("***Break Q4***")
//
//
////5. Ticket numbers usually consist of an even number of digits. A ticket number is considered lucky if the sum of the first half of the digits is equal to the sum of the second half.
//
//
//func getDigits(of number: Int) -> [Int]{
//    var digits = [Int]()
//    var x = number
//
//    repeat{
//        digits.append(x % 10)
//        x /= 10
//    } while x != 0
//
//    return digits
//}
//
//extension Array {
//    func split() -> [[Element]] {
//        let ct = self.count
//        let half = ct / 2
//        let leftSplit = self[0 ..< half]
//        let rightSplit = self[half ..< ct]
//        return [Array(leftSplit), Array(rightSplit)]
//    }
//}
//
//
//func isLucky(n: Int) -> Bool {
//
//    let numOfDigits = getDigits(of: n)
//    let halfOfN = numOfDigits.count/2
//    let splitArray = numOfDigits.split()
//    let left = splitArray[0]
//    let right = splitArray[1]
//
//    if left.reduce(0, +) == right.reduce(0, +){
//        return true
//    }
//
//    return false
//
//}
//
//isLucky(n: 1230)
//isLucky(n: 123456)
//
//print("***Break Q5***")


//6. Some people are standing in a row in a park. There are trees between them which cannot be moved. Your task is to rearrange the people by their heights in a non-descending order without moving the trees. People can be very tall!


func sortByHeight(a: [Int]) -> [Int] {
    
    var mutableA = a
    var indexArrayOfPerson = [Int]()
    var numArrayOfPerson = [Int]()
    
    for number in mutableA{
        
        if number != -1{
            if let index = mutableA.firstIndex(of: number){
                indexArrayOfPerson.append(index)
                numArrayOfPerson.append(number)
            }
        }
    }//end of foreloop
    
    numArrayOfPerson = numArrayOfPerson.sorted()
    
    var emptyArray = [Int]()
    for _ in 0..<a.count{
        emptyArray.append(-1)
    }
    
    for index in indexArrayOfPerson{
        for number in numArrayOfPerson{

            emptyArray.remove(at: index)
            emptyArray.insert(number, at: index)

        }
    }
    
    return emptyArray

}


sortByHeight(a: [-1, 150, 190, 170, -1, -1, 160, 180])
// why the fffffffff is it only showing 190????
