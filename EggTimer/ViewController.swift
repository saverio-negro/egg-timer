//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimes = [
        "Soft": 300,
        "Medium": 480,
        "Hard": 720,
    ];
    
    var player: AVAudioPlayer?
    var secondsElapsed = 0.0
    var timer: Timer = Timer()
    var hardness = ""
    var totalTime = 0.0
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timerBar: UIProgressView!
    
    @IBAction func hardnessSelected(_ sender: UIButton)
    {
        // Resets
        timer.invalidate()
        secondsElapsed = 0
        timerBar.progress = 0
        
        hardness = sender.currentTitle!
        totalTime = Double(eggTimes[hardness]!)
        message.text = "Cooking a \(hardness.lowercased()) egg..."
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        
        secondsElapsed += 1
        timerBar.progress = Float(secondsElapsed / totalTime)
        
        if secondsElapsed == totalTime {
            timer.invalidate()
            self.playSound()
            message.text = "Your \(self.hardness.lowercased()) egg is ready!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.message.text = "How do you like your eggs?"
                self.timerBar.progress = 0
            }
        }
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        timer.invalidate()
        secondsElapsed = 0
        timerBar.progress = 0
        self.message.text = "How do you like your eggs?"
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "bip", withExtension: "wav")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
