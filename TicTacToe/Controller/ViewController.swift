//
//  ViewController.swift
//  TicTacToe
//
//  Created by Gilles David on 15/06/2022.
//

import UIKit

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var arrowPlayerOne: UIImageView!
    @IBOutlet weak var arrowPlayerTwo: UIImageView!
    @IBOutlet weak var scoreLabelPlayerOne: UILabel! // Circle
    @IBOutlet weak var scoreLabelPlayerTwo: UILabel! // Cross
    @IBOutlet weak var viewGame: UIView!
    
    // Variables
    private let game = Game.shared
    private var listButtons: [UIButton] = []
    private var playerNb: Int = 0
    private var scorePlayerOne = 0
    private var timer: Timer?
    private var runCount = 0
    private let thickness = CGFloat(5) // line thickness of the table 
    private let imgCircleStr = "circle.png"
    private let imgCrossStr = "cross.png"
    private let imgCircleRedStr = "circleRed.png"
    private let imgCrossRedStr = "crossRed.png"
    private let lineWinnerStr = "lineWinner"
    private let countDownMax = 30
    private var widthThird: CGFloat = 0
    private var heightThird: CGFloat = 0
    
    //MARK: - At opening
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get game
        game.initializeGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectPlayerNb(playerBn: 0)
    }
    
    fileprivate func updateScoreOnScreen() {
        scoreLabelPlayerOne.text = String(game.playerOneScore)
        scoreLabelPlayerTwo.text = String(game.playerTwoScore)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drawTable()
        updateScoreOnScreen()
        showMsgBeginGame()
    }
    
    //MARK: - Game status    
    private func playerLoose(playerNb: Int) {
        
        if playerNb == 1 {
            game.playerTwoScore += 1
        } else {
            game.playerOneScore += 1
        }
        updateScoreOnScreen()
    }
    
    private func showMsgBeginGame(){
        let alertVC = UIAlertController(title: title, message: "Begin new game", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.startGame() }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func showAlert(msg: String, title: String){
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Reset All", style: .default, handler: { _ in self.continuGame() }))
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.resetGame() }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func startGame() {
        startTimer()
        playerNb = 1
        selectPlayerNb(playerBn: playerNb)
    }
    
    private func resetGame() {
        startTimer()
        resetTable()
        game.initializeGame()
        game.playerOneScore = 0
        game.playerTwoScore = 0
        
        runCount = countDownMax
        playerNb = 1
        selectPlayerNb(playerBn: playerNb)
    }
    
    private func continuGame(){
        runCount = countDownMax
        
        resetTable()
        game.initializeGame()
        
        if playerNb == 1 {
            playerNb = 2
            selectPlayerNb(playerBn: 2)
        } else { 
            playerNb = 1
            selectPlayerNb(playerBn: 1)
        }
    }

    //MARK: - Timer
    func startTimer() {
        runCount = countDownMax
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
        }
    }

    @objc func loop() {
        if runCount == 0 {
            runCount -= 1 
            playerLoose(playerNb: playerNb)
            showAlert(msg: "Continue", title: "Game over")
        } else if runCount > 0{
            runCount -= 1  
            let minutes = Int(runCount) / 60 % 60
            let seconds = Int(runCount) % 60
            timerLabel.text = "\(minutes):\(seconds)"
        }
    }
    
    
    //MARK: - Actions on table
    
    fileprivate func ifSomeoneWins(_ tag: Int) -> Bool {
        let unit = tag % 10
        let ten = Int (tag / 10 )
        
        if game.testLine(lineNb: unit, playerNb: playerNb) {
            drawLineWinnerInRed(lineNb: unit, playerNb: playerNb)
            return true
        } else if game.testCol(colNb: ten, playerNb: playerNb) {
            drawColWinnerInRed(colNb: ten, playerNb: playerNb)
            return true
        } else if game.testDiaDown(playerNb: playerNb) {
            drawDiaDownWinnerInRed(playerNb: playerNb)
            return true
        } else if game.testDiaUp(playerNb: playerNb) {
            drawDiaUpWinnerInRed(playerNb: playerNb)
            return true
        }
        return false
    }
    
    fileprivate func togglePlyerNb() {
        if playerNb == 1 {
            playerNb = 2
            selectPlayerNb(playerBn: 2)
        } else {
            playerNb = 1
            selectPlayerNb(playerBn: 1)
        }
    }
    
    @objc private func buttonIsTouch(btn: UIButton!){
        let tag = btn.tag
        
        if game.thisBoxIsEmpty(tag : tag) {
            game.addMark(tag : tag, playerNb: playerNb)
            listButtons.forEach { btn in
                if btn.tag == tag {
                    let strNameImg = playerNb == 1 ? imgCircleStr : imgCrossStr
                    btn.setImage(UIImage(named: strNameImg), for: .normal)
                }
            }
            
            if ifSomeoneWins(tag) {
                playerLoose(playerNb: playerNb == 1 ? 2 : 1)
                showAlert(msg: "Player \(playerNb) wins", title: "Game over")
            } else {
                togglePlyerNb()
                if game.countNbEmptyBox() == 0 {
                    showAlert(msg: "There is no winner", title: "OK")
                } else {
                    runCount = countDownMax
                }
            }
        }
    }
    
    private func resetTable(){
        selectPlayerNb(playerBn: playerNb == 1 ? 2 : 1)
        listButtons.forEach { btn in
            btn.setImage(nil, for: .normal)
        }
    }
    
    //MARK: - Draw Table
    
    private func selectPlayerNb(playerBn: Int) {
        switch playerBn {
        case 1:
            arrowPlayerOne.layer.opacity = 1
            arrowPlayerTwo.layer.opacity = 0
        case 2:
            arrowPlayerOne.layer.opacity = 0
            arrowPlayerTwo.layer.opacity = 2
        default:
            arrowPlayerOne.layer.opacity = 0
            arrowPlayerTwo.layer.opacity = 0
        }
    }
    
    private func drawTable(){
        self.widthThird = self.viewGame.layer.bounds.width / CGFloat(game.sizeSquare)
        self.heightThird = self.viewGame.layer.bounds.height / CGFloat(game.sizeSquare)
        
        drawLinesTable(heightThird, widthThird)
        addButtonForEachBox(heightThird, widthThird)
    }
    
    private func addButtonForEachBox(_ heightThird: CGFloat, _ widthThird: CGFloat) {
        for i in 1...game.sizeSquare {
            for j in 1...game.sizeSquare {  
                let tag = i * 10 + j
                let button = UIButton(frame: CGRect(
                    x: CGFloat(i - 1) * heightThird, 
                    y: CGFloat(j - 1) * widthThird + CGFloat (thickness * CGFloat((j - 1))), 
                    width: widthThird, 
                    height: heightThird))
                button.backgroundColor = .clear
                button.tag = tag
                button.addTarget(self, action: #selector(buttonIsTouch), for: .touchUpInside)
                listButtons.append(button)
                self.viewGame.addSubview(button)
            }
        }
    }
    
    private func drawLinesTable(_ heightThird: CGFloat, _ widthThird: CGFloat) {
        let lineHorOne = UIView(frame: CGRect(x: 0, y: heightThird, width: widthThird * 3, height: thickness))
        lineHorOne.backgroundColor = .black
        self.viewGame.addSubview(lineHorOne)
        
        let lineHorTwo = UIView(frame: CGRect(x: 0, y: heightThird * 2, width: widthThird * 3, height: thickness))
        lineHorTwo.backgroundColor = .black
        self.viewGame.addSubview(lineHorTwo)
        
        let lineVertOne = UIView(frame: CGRect(x: widthThird, y: 0, width: thickness, height: widthThird * 3))
        lineVertOne.backgroundColor = .black
        self.viewGame.addSubview(lineVertOne)
        
        let lineVertTwo = UIView(frame: CGRect(x: widthThird * 2, y: 0, width: thickness, height: widthThird * 3))
        lineVertTwo.backgroundColor = .black
        self.viewGame.addSubview(lineVertTwo)
    }
    //MARK: - Manage the winning pieces
    private func drawLineWinnerInRed(lineNb: Int, playerNb: Int){
        listButtons.forEach { btn in
            let unit = btn.tag % 10
            if unit == lineNb {
                if playerNb == 1 {
                    btn.setImage(UIImage(named: imgCircleRedStr), for: .normal)
                } else {
                    btn.setImage(UIImage(named: imgCrossRedStr), for: .normal)
                }
            }
        }
    }
    private func drawColWinnerInRed(colNb: Int, playerNb: Int){
        listButtons.forEach { btn in
            let ten = Int (btn.tag / 10 )
            if ten == colNb {
                if playerNb == 1 {
                    btn.setImage(UIImage(named: imgCircleRedStr), for: .normal)
                } else {
                    btn.setImage(UIImage(named: imgCrossRedStr), for: .normal)
                }
            }
        }
    }
    private func drawDiaDownWinnerInRed(playerNb: Int){
        listButtons.forEach { btn in
            let ten = Int (btn.tag / 10 )
            let unit = btn.tag % 10
            if ten == unit {
                if playerNb == 1 {
                    btn.setImage(UIImage(named: imgCircleRedStr), for: .normal)
                } else {
                    btn.setImage(UIImage(named: imgCrossRedStr), for: .normal)
                }
            }
        }
    }
    private func drawDiaUpWinnerInRed(playerNb: Int){
        listButtons.forEach { btn in
            let ten = Int (btn.tag / 10 )
            let unit = btn.tag % 10
            if ten + unit == 4 {
                if playerNb == 1 {
                    btn.setImage(UIImage(named: imgCircleRedStr), for: .normal)
                } else {
                    btn.setImage(UIImage(named: imgCrossRedStr), for: .normal)
                }
            }
        }
    }
    
}

