//
//  Game.swift
//  TicTacToe
//
//  Created by Gilles David on 15/06/2022.
//

class Game {
    
    // Only one game
    static let shared = Game()
    private init(){}
    
    public var table: [Element] = []
    public var playerOneScore = 0
    public var playerTwoScore = 0
    public let sizeSquare = 3
    
    func initializeGame() {
        table = []
        for i in 1...sizeSquare {
            for j in 1...sizeSquare {
                let tag = i * 10 + j
                let element = Element(state: .empty, tag: tag)
                table.append(element)
            }
        }
    }
    
    func thisBoxIsEmpty(tag: Int) -> Bool {
        var test = false
        table.forEach { element in
            if element.tag == tag && element.state == .empty {
                test = true
            }
        }
        return test
    }
    
    func addMark(tag: Int, playerNb: Int) {
        table.forEach { element in
            if element.tag == tag {
                element.state = playerNb == 1 ? .circle : .cross
            }
        }
    }
    
    func countNbEmptyBox() -> Int {
        let filtered = table.filter { ele in
            return ele.state == .empty
        }
        return filtered.count
    }
    
    //MARK: - Test if the position is winning (lines/columns/diagonals)
    func testLine(lineNb: Int, playerNb: Int) -> Bool {
        let state: State = (playerNb == 1 ? .circle : .cross)
        let filtered = table.filter { ele in
            let unit = ele.tag % 10
            return unit == lineNb && ele.state == state
        }
        return filtered.count == 3
    }
    
    func testCol(colNb: Int, playerNb: Int) -> Bool {
        let state: State = (playerNb == 1 ? .circle : .cross)
        let filtered = table.filter { ele in
            let ten = Int (ele.tag / 10 )
            return ten == colNb && ele.state == state
        }
        return filtered.count == 3
    }
    
    func testDiaDown(playerNb: Int) -> Bool {
        let state: State = (playerNb == 1 ? .circle : .cross)
        let filtered = table.filter { ele in
            let unit = ele.tag % 10
            let ten = Int (ele.tag / 10 )
            return unit == ten && ele.state == state
        }
        return filtered.count == 3
    }
    
    func testDiaUp(playerNb: Int) -> Bool {
        let state: State = (playerNb == 1 ? .circle : .cross)
        let filtered = table.filter { ele in
            let unit = ele.tag % 10
            let ten = Int (ele.tag / 10 )
            return (unit + ten) == 4 && ele.state == state
        }
        return filtered.count == 3
    }
    
    //MARK: - Entity
    class Element {
        var state: State
        var tag: Int = 0
        
        init(state: State, tag: Int) {
            self.state = state
            self.tag = tag
        }
    }
    
    enum State {
        case empty
        case cross
        case circle
    }
}
