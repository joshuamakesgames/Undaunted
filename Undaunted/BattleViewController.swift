//
//  BattleViewController.swift
//  Undaunted
//
//  Created by Joshua Moore on 10/12/23.
//

import UIKit
import AVFoundation

class BattleViewController: UIViewController {
    
    @IBOutlet weak var playerHealthText: UILabel!
    
    @IBOutlet weak var enemyHealthText: UILabel!
    
    @IBOutlet weak var runUnableText: UILabel!
    
    @IBOutlet weak var dialougeText: UILabel!
    
    @IBOutlet weak var missText: UILabel!
    
    @IBOutlet weak var attackTappedOutlet: UIButton!
    
    @IBOutlet weak var healTappedOutlet: UIButton!
    
    @IBOutlet weak var blockTappedOutlet: UIButton!
    
    @IBOutlet weak var runTappedOutlet: UIButton!
    
    @IBOutlet weak var enemyImage: UIImageView!
    
    var playerHealth = 99
    var enemyHealth = 500
    var playerAttack = 30
    var enemyAttack = 40
    var playerTurn = true
    var timer = Timer()
    var counter = 1
    var music: AVAudioPlayer?
    var sound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playMusic(fileName: "8battle")
        runUnableText.isHidden = true
        missText.isHidden = true
    }
    @IBAction func attackTapped(_ sender: UIButton) {
        startPlayerAttack()
        playerTurn = false
    }
    @IBAction func blockTapped(_ sender: UIButton) {
        func playerBlock() {
            enemyAttack /= 5
            //  playerHealth -=
            playerHealthText.text = "\(playerHealth)"
        }
        playerTurn = false
    }
    @IBAction func healTapped(_ sender: UIButton) {
        if playerHealth < 99 {
            playerHealth += 30
            playerHealthText.text = "\(playerHealth)"
            healTappedOutlet.isHidden = true
        } else {
            playerHealth += 0
        }
    }
    @IBAction func runTapped(_ sender: Any) {
        runUnableText.isHidden = false
    }
    func startPlayerAttack() {
        missText.isHidden = true
        let attackRoll = Int.random(in: 0...100)
        if attackRoll <= 15 {
            missText.isHidden = false
        } else if attackRoll <= 80 {
            missText.isHidden = true
            enemyHealth -= 30
            enemyHealthText.text = "\(enemyHealth)"
            playSound(fileName: "hit")
            enemyImage.image = UIImage(named: "UndauntedKnightBossDamage")
//            imageView.image = UIImage(named:"foo")
        } else {
            missText.isHidden = true
            enemyHealth -= 80
            enemyHealthText.text = "\(enemyHealth)"
            playSound(fileName: "hit")
            enemyImage.image = UIImage(named: "UndauntedKnightBossDamage")
        }
        if enemyHealth <= 0 {
            performSegue(withIdentifier: "goWin", sender: nil)
            playerTurn = true
        }
        buffer()
    }
    func startEnemyAttack() {
        missText.isHidden = true
        let attackRoll = Int.random(in: 0...100)
        if attackRoll <= 25 {
            missText.isHidden = false
        } else if attackRoll <= 90 {
            missText.isHidden = true
            playerHealth -= 40
            playerHealthText.text = "\(playerHealth)"
            playSound(fileName: "hit")
        } else {
            missText.isHidden = true
            playerHealth -= 70
            playerHealthText.text = "\(playerHealth)"
            playSound(fileName: "hit")
        }
        playerTurn = true
        if playerTurn == true {
            attackTappedOutlet.isHidden = false
            healTappedOutlet.isHidden = false
            blockTappedOutlet.isHidden = false
            runTappedOutlet.isHidden = false
            timer.invalidate()
        }
        if playerHealth <= 0 {
            performSegue(withIdentifier: "goLose", sender: nil)
        }
    }
    func buffer() {
        if playerTurn == false {
            enemyImage.image = UIImage(named: "UndauntedBossBoss")
            attackTappedOutlet.isHidden = true
            healTappedOutlet.isHidden = true
            blockTappedOutlet.isHidden = true
            runTappedOutlet.isHidden = true
            runUnableText.isHidden = true
            // Timer
            // End of timer / play sound
            // Launch enemy attack
            counter = 1
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    @ objc func timerAction() {
        counter -= 1
        if counter <= 0 {
            startEnemyAttack()
            timer.invalidate()
        } else if enemyHealth <= 0 || playerHealth <= 0 {
            timer.invalidate()
        }
    }
    func playMusic(fileName: String){
        if let path = Bundle.main.path(forResource: fileName, ofType: "wav"){
            let url = URL(fileURLWithPath: path)
            do {
                self.music = try AVAudioPlayer(contentsOf: url)
                self.music?.play()
                self.music?.numberOfLoops = -1
            } catch {
                print("Can't find the file.")
            }
        }
    }
    func playSound(fileName: String){
        if let path = Bundle.main.path(forResource: fileName, ofType: "wav"){
            let url = URL(fileURLWithPath: path)
            do {
                self.sound = try AVAudioPlayer(contentsOf: url)
                self.sound?.play()
            } catch {
                print("Can't find the file.")
            }
        }
    }
}
