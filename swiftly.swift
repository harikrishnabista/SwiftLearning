/* 1 ---------------------------------------------------------------- */
/* withCheckedContinuation */

func asyncOperation(completion: @escaping (Result<Int, Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        // Simulating an asynchronous operation
        let result = Int.random(in: 1...10)
        completion(.success(result))
    }
}

func fetchData() async -> Result<Int, Error> {
    return await withCheckedContinuation { continuation in
        asyncOperation { result in
            continuation.resume(returning: result)
        }
    }
}

let result = await fetchData()
print("Fetched data: \(result)")

/* 2 - some gists */

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
}

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

class BSTNode {
    public var val: Int
    public var left: BSTNode?
    public var right: BSTNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: BSTNode?, _ right: BSTNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
    
    func insert(node: BSTNode?){
        guard let node = node else {
            return
        }
        
        self.insert(node: node, into: self)
    }
    
    private func insert(node: BSTNode, into root: BSTNode) {
        if node.val < root.val {
            // insert into left node
            if let leftNode = root.left {
                self.insert(node: node, into: leftNode)
            } else {
                root.left = node
            }
            
        } else {
            // insert into right node
            if let rightNode = root.right {
                self.insert(node: node, into: rightNode)
            } else {
                root.right = node
            }
        }
    }
    
    func delete(node: BSTNode) {
        
    }
}

class TreeFactory {
    class func createTreeFromArray(arr: [Int?]) -> TreeNode? {
        
        let root: TreeNode = TreeNode(arr[0] ?? 0)
        var queue: [TreeNode] = [root]
        
        var i = 1
        while i < arr.count  {
            let currNode = queue.removeFirst()
            
            if let val = arr[i] {
                currNode.left = TreeNode(val)
            } else {
                currNode.left = nil
            }
            
            i = i + 1
            
            if let leftNode = currNode.left {
                queue.append(leftNode)
            }
            
            if i < arr.count {
                if let val = arr[i] {
                    currNode.right = TreeNode(val)
                } else {
                    currNode.right = nil
                }

                if let rightNode = currNode.right {
                    queue.append(rightNode)
                }
                i = i + 1
            }
        }
        
        return root
    }
}

class LinkedListFactory {
    class func convertArrayToLinkedList(arr:[Int]) -> ListNode? {
        if arr.count == 0 { return nil }
        
        let root: ListNode? = ListNode(arr[0])
        
        if arr.count == 1 {
            return root
        }
        
        var runnerNode: ListNode? = root
        for i in 1...(arr.count - 1) {
            runnerNode?.next = ListNode(arr[i])
            runnerNode = runnerNode?.next
        }
        
        return root
    }

    class func convertLinkedListToArray(list: ListNode?) -> [Int] {
        var runnerNode = list
        var result: [Int] = []
        
        while runnerNode != nil {
            if let runnerNode = runnerNode {
                result.append(runnerNode.val)
            }
            runnerNode = runnerNode?.next
        }
        return result
    }
}


// Function to measure the time taken by another function
func measureTime<T>(_ function: () -> T) -> (T, TimeInterval) {
    let startTime = Date()
    let result = function()
    let endTime = Date()
    let timeTaken = endTime.timeIntervalSince(startTime)
    return (result, timeTaken)
}


class RandomIntFactory {
    private func randomBetween(min: Int, max: Int) -> Int {
        Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
    
    func getRandomInts(size: Int, min: Int, max: Int) -> [Int] {
        var result: [Int] = []
        
        for i in 0...(size-1) {
            result.append(randomBetween(min: min, max: max))
        }
        
        return result
    }

}


func radixSort(_ array: [Int]) -> [Int] {
    // Determine the maximum number of digits in the array
    let maxDigits = String(array.max() ?? 0).count
    
    // Array to store the buckets
    var buckets = [[Int]](repeating: [], count: 10)
    
    // Collect elements into buckets based on the current digit
    for digitIndex in 0..<maxDigits {
        for number in array {
            let digit = (number / Int(pow(10, Double(digitIndex)))) % 10
            buckets[digit].append(number)
        }
    }
    
    // Create a DispatchGroup
    let group = DispatchGroup()
    
    // Create a concurrent queue for sorting
    let queue = DispatchQueue(label: "com.radixsort.queue", attributes: .concurrent)
    
    // Perform sorting on each bucket asynchronously
    for i in 0..<buckets.count {
        group.enter()
        queue.async {
            buckets[i].sort()
            group.leave()
        }
    }
    
    // Wait for all sorting tasks to complete
    group.wait()
    
    // Flatten the sorted buckets and return the result
    return buckets.flatMap { $0 }
}

struct DateDiffLogger {
    static func secondsDifferenceBetweenDates(startDate: Date, endDate: Date) {
        let interval = endDate.timeIntervalSince(startDate)
        print("Difference in seconds: \(interval)")
    }
}

func aBusyFunc() {
    var sum = 0
    for i in 0...500000 {
        sum = sum + i
    }
    print(sum)
}

import CryptoKit

func hashPassword(_ password: String) -> String {
    let inputData = Data(password.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
    return hashString
}

func authenticateUser(
    username: String,
    password: String,
    hashedPassword: String
) -> Bool {
    let enteredPasswordHash = hashPassword(password)
    return enteredPasswordHash == hashedPassword
}

func asyncMocked(seconds: Int) async -> String {
    try? await Task.sleep(nanoseconds: UInt64(1_000_000_000 * seconds))
    return "async"
}


// Glider test 1. move zero items to end without modifying the order of non-zero items, also
// do all this in place array(without using extra storage)

func moveNonZeroToLastInPlace(items: inout [Int]) {
    
    var zeroPosToSwap = -1
    
    for (i,item) in items.enumerated() {
        
        if item == 0 && zeroPosToSwap == -1 {
            zeroPosToSwap = i
            continue
        }
        
        if item != 0 && zeroPosToSwap > -1  {
            
            items[zeroPosToSwap] = item
            items[i] = 0
            zeroPosToSwap += 1
            
        }
    }
}

struct Player: Equatable {
    let playerName: String
    let rank: Int
    let score: Double
    let rating: Int
}

func sortPlayers(_ players: [Player]) -> [Player] {
    players.sorted {
        if $0.rank != $1.rank {
            return $0.rank < $1.rank
        } else if $0.score != $1.score {
            return $0.score > $1.score
        } else {
            return $0.rating > $1.rating
        }
    }
}

let a = Player(playerName: "Hari", rank: 1, score: 10.5, rating: 1)
let b = Player(playerName: "Krishna", rank: 2, score: 10.5, rating: 2)
let c = Player(playerName: "Bista", rank: 1, score: 11, rating: 3)
let d = Player(playerName: "H", rank: 2, score: 10.5, rating: 6)

let res1 = sortPlayers([a,b,c,d])

for item in res1 {
    print(item)
}


func fibonaci(limit: Int) -> [Int] {
    
    var fibSeries: [Int] = []
    
    var first = 0
    var second = 1
    
    var tempSum = first + second
    
    fibSeries.append(first)
    fibSeries.append(second)
    
    while first + second < limit {
        tempSum = first + second
        
        fibSeries.append(tempSum)
        
        first = second
        second = tempSum
    }
    
    return fibSeries
}

/*
 let fibSeries = fibonaci(limit: 30)
 
 for item in fibSeries {
 print(item)
 }
 */

// abcdef -> fedcba

// Hari -> irah
// exchange 0 and (count-1)
// exchange 1 and (count-2)

// ...
// ...
// exchange i'th and (count-i)'th item

// loop runs 0 to (count/2-1)

// Harik
//

func stringResersal1(str: String) -> String {
    
    var charArr = Array(str)
    
    var result = charArr
    result.removeAll()
    
    while charArr.isEmpty == false {
        result.append(charArr.removeLast())
    }
    
    return String(result)
}

func stringResersal2(str: String) -> String {
    
    var charArr = Array(str)
    
    var i = 0
    
    while i < charArr.count/2 {
        
        let temp = charArr[i]
        charArr[i] = charArr[charArr.count-1-i]
        charArr[charArr.count-1-i] = temp
        
        i = i + 1
    }
    
    return String(charArr)
}


/*
 print(stringResersal1(str: "abcdef"))
 print(stringResersal2(str: "abcdef"))
 */


// Integer to Roman on leetcode question

/*
 Symbol    Value
 I         1
 V         5
 X         10
 L         50
 C         100
 D         500
 M         1000
 */

/*
 
 3 = iii
 4 = iv
 5 = v
 6 = vi
 7 = viii
 
 8 = viii
 9 = ix
 
 */

class Solution {
    func intToRoman(_ num: Int) -> String {
        return ""
    }
}

/*
 Input: nums = [8,7,11,15,1], target = 9
 Output: [0,1]
 Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
 */

/*
 
 dict
 [
 1:0,
 2:1,
 -2:2,
 -6:3
 ]
 
 
 */


class Solution_twoSum {
    
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        
        var dict: [Int : Int] = [:]
        
        for (i,num) in nums.enumerated() {
            
            let diff = target - num
            
            if let index = dict[num] {
                return [index, i]
            }
            
            dict[diff] = i
        }
        
        return []
    }
    
}

//print(Solution_twoSum().twoSum([8,1,1,15,1,7], 9))

// https://leetcode.com/problems/rotate-array/description/
// Given an integer array nums, rotate the array to the right by k steps, where k is non-negative.

/*
 
 Input: nums = [1,2,3,4,5,6,7], k = 3
 Output: [5,6,7,1,2,3,4]
 Explanation:
 rotate 1 steps to the right: [7,1,2,3,4,5,6]
 rotate 2 steps to the right: [6,7,1,2,3,4,5]
 rotate 3 steps to the right: [5,6,7,1,2,3,4]
 
 */

/*
 
 temp = 6
 [7,1,2,3,4,5,6]
 
 [7,7,1,2,3,4,5]
 [7,7,1,2,3,4,5]
 
 */





class Solution_rotate1 {
    
    func rotate(_ nums: inout [Int], _ k: Int) {
        for i in 0...(k-1) {
            shift(arr: &nums)
        }
    }
    
    private func shift(arr: inout [Int]) {
        
        guard arr.count > 0 else { return }
        
        let temp = arr[arr.count-1]
        
        var index = arr.count-1
        
        while index > 0 {
            arr[index] = arr[index-1]
            index = index - 1
        }
        
        arr[0] = temp
    }
}

// [1,2,3,4,5,6,7]
//  0 1 2 ..

// "Hari", "Krishna", "Bista"

class Solution_rotate2 {
    func rotate(_ nums: inout [Int], _ k: Int) {
        
        var newArr = [Int](repeating: 0, count: nums.count)
        
        for (i, num) in nums.enumerated() {
            
            var newIndex = i + k
            if newIndex > (nums.count-1) {
                newIndex = newIndex - nums.count
            }
            
            newArr[newIndex] = num
        }
        
        nums = newArr
    }
}

/*
 var input_nums1 = [1,2,3,4,5,6,7]
 Solution_rotate1().rotate(&input_nums, 3)
 print(input_nums)
 */

// [1,2,3,4,5,6,7], 3
// [_,_,_,1,2,3,4], 5,6,7

/*
 var input_nums1 = [1,2,3,4,5,6,7]
 Solution_rotate2().rotate(&input_nums1, 3)
 print(input_nums1)
 */

class Solution_powerSet {
    // non recursive solution
    func subsets(_ nums: [Int]) -> [[Int]] {
        var result:[[Int]] = []
        result.append([])
        
        for item in nums {
            product(item: item, result: &result)
        }
        
        return result
    }
    
    private func product(item:Int, result: inout [[Int]]) {
        
        print(item, result)
        
        for items in result {
            var newItems = items
            newItems.append(item)
            result.append(newItems)
        }
    }
}

// let res = Solution_powerSet().subsets([1,2,3])


/*
 Write a program that prints the numbers from 1 to n. But for multiples of three, print "Fizz" instead of the number,
 and for the multiples of five, print "Buzz". For numbers that are multiples of both three and five, print "FizzBuzz".
 */

func fizzBuzz(n: Int) {
    
    for number in 1...n {
        
        if number % (3*5) == 0 {
            print("FizzBuzz")
        } else if number % 3 == 0 {
            print("Fizz")
        } else if number % 5 == 0 {
            print("Buzz")
        }
    }
    
}

//fizzBuzz(n: 100)


// "listen" and "silent" are anagrams
func areAnagrams(_ str1: String, _ str2: String) -> Bool {
    str1.sorted() == str2.sorted()
}


class Solution_findAnagrams {
    func findAnagrams(_ s: String, _ p: String) -> [Int] {
        
        guard s.count >= p.count else { return [] }
        
        let strings = getAllSubStrings(str: s, subStringSize: p.count)
        
        let key = p.sorted()
        
        var result: [Int] = []
        
        for (i,str) in strings.enumerated() {
            if str.sorted() == key {
                result.append(i)
            }
        }
        
        return result
    }
    
    private func getAllSubStrings(str: String, subStringSize: Int) -> [String] {
        var result: [String] = []
        
        for i in 0...(str.count - subStringSize) {
            let subStr = getSubString(fromStr: str, startIndex: i, length: subStringSize)
            result.append(subStr)
        }
        
        return result
    }
    
    private func getSubString(fromStr: String, startIndex: Int, length: Int) -> String {
        
        var result: [Character] = []
        
        let charArr = Array(fromStr)
        
        for i in startIndex...(startIndex + length - 1) {
            result.append(charArr[i])
        }
        
        return String(result)
    }
}

//print(Solution_findAnagrams().findAnagrams("cbaebabacd", "abc"))
//print(Solution_findAnagrams().findAnagrams("abab", "ab"))

//print(getSubString(fromStr: "Harik", startIndex: 0, length: 3) == "Har")
//print(getSubString(fromStr: "Harik", startIndex: 1, length: 4) == "arik")

class Solution_isValidSudoku {
    
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        isRowsValid(board: board) && isColumnsValid(board: board)
    }
    
    func isRowsValid(board: [[Character]]) -> Bool {
        for row in board {
            if isItemsUnique(items: row) == false {
                return false
            }
        }
        return true
    }
    
    func isColumnsValid(board: [[Character]]) -> Bool {
        var col = 0
        let size = board.count
        
        while col < size {
            
            var tempItems: [Character] = []
            
            for row in 0..<size {
                let item = board[row][col]
                tempItems.append(item)
            }
            
            if isItemsUnique(items: tempItems) == false {
                return false
            }
            
            col = col + 1
            
        }
        
        return true
    }
    
    
    
    func isItemsUnique (items: [Character]) -> Bool {
        
        var seen = Set<Character>()
        
        for item in items {
            if seen.contains(item) {
                return false
            }
            
            if item != "." {
                seen.insert(item)
            }
        }
        
        return true
    }
}


//print(Solution_isValidSudoku().isValidSudoku(sodukuGrid))

import Darwin

func isValidSudoku(_ board: [[Character]]) -> Bool {
    
    let boardSize = board.count
    
    var rows = Array(repeating: Set<Character>(), count: boardSize)
    var columns = Array(repeating: Set<Character>(), count: boardSize)
    
    var boxes = Array(repeating: Set<Character>(), count: boardSize)
    var boxCounter = 0
    
    let miniBoardSize = Int(sqrt(Double(boardSize)))
    
    for i in 0..<boardSize {
        for j in 0..<boardSize {
            let char = board[i][j]
            
            if char != "." {
                if rows[i].contains(char) || columns[j].contains(char) || boxes[j / miniBoardSize].contains(char) {
                    return false
                }
                
                rows[i].insert(char)
                columns[j].insert(char)
                
                boxes[j / miniBoardSize].insert(char)
            }
            
            boxCounter = boxCounter + 1
            
            if boxCounter == boardSize * miniBoardSize {
                boxCounter = 0
                boxes = Array(repeating: Set<Character>(), count: 3)
            }
        }
    }
    
    return true
}

let sodukuGrid:[[Character]] =
[
    ["5","3",".",".","7",".",".",".","."],
    ["6",".",".","1","9","5",".",".","."],
    [".","9","8",".",".",".",".","6","."],
    ["8",".",".",".","6",".",".",".","3"],
    ["4",".",".","8",".","3",".",".","1"],
    ["7",".",".",".","2",".",".",".","6"],
    [".","6",".",".",".",".","2","8","."],
    [".",".",".","4","1","9",".",".","5"],
    [".",".",".",".","8",".",".","7","9"]
]

func printCharacterMatrix(_ matrix: [[Character]]) {
    
    for i in 0..<matrix.count {
        
        for j in 0..<matrix[i].count {
            if i % 3 == 0 && j % 3 == 0 {
                print("🟢 [\(i),\(j)] - \(matrix[i][j])", terminator: "  ")
            } else {
                print("💜 (\(i),\(j)) - \(matrix[i][j])", terminator: "  ")
            }
        }
        print("")
        print("")
    }
    
}

printCharacterMatrix(sodukuGrid)

print(isValidSudoku(sodukuGrid))

print("")

