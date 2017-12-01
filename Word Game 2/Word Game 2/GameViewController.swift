//
//  GameViewController.swift
//  Word Game 2
//
//  Created by Elizabeth Hanley on 11/30/17.
//  Copyright (c) 2017 Elizabeth Hanley. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var guessField: UITextField!
    
    var guesses = [String]()
    var responses = [String]()
    var answer = ""
    var attempts = 0
    var wordBank: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        do {
            // This solution assumes  you've got the file in your bundle
            if let path = Bundle.main.path(forResource: "wordlist", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                wordBank = data.components(separatedBy: "\r\n")
                wordBank?.removeLast()
                // print(wordBank)
            }
        } catch let err as NSError {
            // do something with Error
            print(err)
        }
        let randomIndex = Int(arc4random_uniform(UInt32((wordBank?.count)!)))
        answer = wordBank![randomIndex]
        print(answer)
    }
    
    func check(guess: String) {
        if guesses.count == 30 && guess != answer {
            responses.append("You lose!")
            guessField.isEnabled = false
        } else {
            if guess < answer {
                responses.append("Go Further")
            } else if guess > answer {
                responses.append("Too Far")
            } else {
                responses.append("Correct, you win!")
                guessField.isEnabled = false
            }
        }
        
        attempts += 1

        tableView.reloadData()
    }
    
    @IBAction func guessEntered(_ sender: Any) {
        let guess = guessField.text!
        guessField.text = ""
        guesses.append(guess)
        check(guess: guess)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        guessField.isEnabled = true
        guesses.removeAll()
        responses.removeAll()
        let index = Int(arc4random_uniform(UInt32((wordBank?.count)!)))
        answer = wordBank![index]
        print(answer)
        attempts = 0
        tableView.reloadData()
    }
    
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = guesses[guesses.count-1-indexPath.row]
        cell.detailTextLabel?.text = responses[responses.count-1-indexPath.row]
        return cell
    }
}
