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


//5. Ticket numbers usually consist of an even number of digits. A ticket number is considered lucky if the sum of the first half of the digits is equal to the sum of the second half.


func getDigits(of number: Int) -> [Int]{
    var digits = [Int]()
    var x = number
    
    repeat{
        digits.append(x % 10)
        x /= 10
    } while x != 0
    
    return digits
}

extension Array {
    func split() -> [[Element]] {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return [Array(leftSplit), Array(rightSplit)]
    }
}


func isLucky(n: Int) -> Bool {
    
    let numOfDigits = getDigits(of: n)
    let halfOfN = numOfDigits.count/2
    let splitArray = numOfDigits.split()
    let left = splitArray[0]
    let right = splitArray[1]
    
    if left.reduce(0, +) == right.reduce(0, +){
        return true
    }
    
    return false
    
}

isLucky(n: 1230)
isLucky(n: 123456)

print("***Break Q5***")


//6. Some people are standing in a row in a park. There are trees between them which cannot be moved. Your task is to rearrange the people by their heights in a non-descending order without moving the trees. ( -1 means trees and other numbers are all people)

func sortByHeight(a: [Int]) -> [Int] {
    
    var arr = [Int]()
    
    let sortedArray = a.sorted(by: <).filter{ $0 != -1 }
    print(sortedArray)
    
    var iterator = 0
    for value in a {
        //if value is not -1, add the sortedArray
        if value != -1 {
            arr.append(sortedArray[iterator])
            //            print(arr)
            iterator += 1
        } else {
            arr.append(value)
            //            print(arr)
        }
    }
    
    return arr
}


sortByHeight(a: [-1, 150, 190, 170, -1, -1, 160, 180])

//7. Write a function that reverses characters in (possibly nested) parentheses in the input string.
// *** practice -

func reverseInParentheses(inputString: String) -> String {
    
    var s = inputString
    //make sure s contains "(", put it in openIdx
    guard let openIdx = s.lastIndex(of: "(") else {return "error"}
    // Should really use a guard let here, but the problem states that all parens are well formed
    //
    let closeIdx = s[openIdx...].firstIndex(of:")")!
    s.replaceSubrange(openIdx...closeIdx, with: s[s.index(after: openIdx)..<closeIdx].reversed())
    
    
    return s
}

reverseInParentheses(inputString: "(bar)")


//8. Several people are standing in a row and need to be divided into two teams. The first person goes into team 1, the second goes into team 2, the third goes into team 1 again, the fourth into team 2, and so on. You are given an array of positive integers - the weights of the people. Return an array of two integers, where the first element is the total weight of team 1, and the second element is the total weight of team 2 after the division is complete.

func alternatingSums(a: [Int]) -> [Int] {
    var team1 = [Int]()
    var team2 = [Int]()
    var array = [Int]()
    
    for index in 0..<a.count{
        if index == 0{
            team1.append(a[0])
        } else if index % 2 == 0{
            team1.append(a[index])
        } else{
            team2.append(a[index])
        }
        
    }
    
    
    array.insert(team1.reduce(0, +), at: 0)
    array.insert(team2.reduce(0, +), at: 1)
    //    return team1
    //    return team2
    return  array
}

alternatingSums(a: [100, 51, 50, 100])

//9. Given a rectangular matrix of characters, add a border of asterisks(*) to it.

// Example: picture = ["abc",
//                     "ded"]
//
// Output:
//naddBorder(picture) = ["*****",
//                       "*abc*",
//                       "*ded*",
//                       "*****"]

func addBorder(picture: [String]) -> [String] {
    
    var mutatingPicture = picture
    var asterikWall = ""
    let totalNumb = picture[0].count
    
    for _ in 1...totalNumb{
        asterikWall.append("*")
    }
    
    mutatingPicture.insert(asterikWall, at: 0)
    mutatingPicture.insert(asterikWall, at: picture.count+1)
    mutatingPicture = mutatingPicture.map{"*"+$0+"*"}
    
    
    return mutatingPicture
}

addBorder(picture: ["abc",
                    "ded"])

//10. Two arrays are called similar if one can be obtained from another by swapping at most one pair of elements in one of the arrays.
//exp: TRUE below
//a: [2, 3, 1]
//b: [1, 3, 2]

func areSimilar(a: [Int], b: [Int]) -> Bool {
    
    var emptya = [Int]()
    var emptyb = [Int]()
    
    for index in 0..<a.count{
        if a[index] != b[index]{
            emptyb.append(b[index])
            emptya.append(a[index])
        }
    }
    
    if emptya.count > 2{
        return false
    } else if emptya.count == 2{
        emptya.swapAt(0, 1)
    }
    
    return emptya == emptyb
}

areSimilar(a: [1, 2, 3],
           b: [1, 10, 2])

//11. You are given an array of integers. On each move you are allowed to increase exactly one of its element by one. Find the minimal number of moves required to obtain a strictly increasing sequence from the input.
//
//For inputArray = [1, 1, 1], the output should be 3.

func arrayChange(inputArray: [Int]) -> Int {
    var turns = 0
    var mutableInput = inputArray
    
    for index in 0..<mutableInput.count - 1{
        if mutableInput[index+1] <= mutableInput[index]{
            //find how many it takes to be greater
            let sum = mutableInput[index] - mutableInput[index+1] + 1
            turns += sum
            mutableInput[index+1] = sum + mutableInput[index+1]
        }
    }
    
    return turns
}

arrayChange(inputArray: [1,1,1])


//12. Given a string, find out if its characters can be rearranged to form a palindrome. ( string that doesn't change when reversed )

func palindromeRearranging(inputString: String) -> Bool {
    
    var emptyStr: Set<Character> = []
    print("initial:\(emptyStr)")
    
    for ltr in inputString{
        if emptyStr.contains(ltr){
            emptyStr.remove(ltr)
            print("removed:\(emptyStr)")
            continue
        }
        emptyStr.insert(ltr)
        print("inserted: \(emptyStr)")
        
    }
    
    return emptyStr.count <= 1
    
}

palindromeRearranging(inputString: "abca")
