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
