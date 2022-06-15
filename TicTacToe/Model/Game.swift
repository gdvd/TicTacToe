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
    
    //TODO: test if win
    func testLine(lineNb: Int, playerNb: Int) -> Int {
        var nbElementsFound = 0
        table.forEach { ele in
            let unit = ele.tag % 10
            if unit == lineNb {
                if ele.state == .circle && playerNb == 1 {
                    nbElementsFound += 1
                }
                //TODO: Player2
            }
        }
        return nbElementsFound
    }
    
    func testCol(colNb: Int, playerNb: Int) -> Int {
        
        return 0
    }
    
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
