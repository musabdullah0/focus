//
//  PomodoroModel.swift
//  Focus
//
//  Created by Musab Abdullah on 9/24/23.
//

import Foundation
import AVFoundation
import Cocoa

enum TimerType: String, CaseIterable {
    case pomodoro = "Pomodoro"
    case shortbreak = "Short Break"
    case longbreak = "Long Break"
    
    var order: Int {
        switch self {
        case .pomodoro: return 0
        case .shortbreak: return 1
        case .longbreak: return 2
        }
    }
    
    var duration: Int {
        switch self {
        case .pomodoro:
            return 25*60
        case .shortbreak:
//            return 5*60
            return 30
        case .longbreak:
            return 10*60
        }
    }
}

/*
 there are 3 different session
 1. 25 min focus
 2.  5 min break
 3. 10 min break
 */
class PomodoroModel: ObservableObject {
    @Published var time: String
    @Published var state: String
    @Published var buttonText: String
    @Published var progress: Float = 0.0
    private var audioPlayer: AVAudioPlayer?
    @Published var timerType: TimerType = .pomodoro
    
    private var secondsLeft: Int
    private var timer: Timer?
    
    init() {
        self.time = "25:00"
        self.state = "idle"
        self.buttonText = "start"
        self.secondsLeft = 25*60
    }
    
    func updateTime() {
        self.time = self.timeText()
        AppDelegate.instance.statusBarItem.button?.title = self.timeText()
        
        let done = max(self.timerType.duration - self.secondsLeft, 0)
        self.progress = Float(done) / Float(self.timerType.duration)
        
        print("\(done) / \( Float(self.timerType.duration)) = \(self.progress)")
        
    }
    
    func start() {
        print("starting timer with \(self.secondsLeft) sec left")
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsLeft > 0 {
                print("\(self.secondsLeft) sec left")
                self.secondsLeft -= 1
                self.updateTime()
            } else {
                self.playSound()
                Timer.invalidate()
            }
        }
        RunLoop.main.add(self.timer!, forMode: .common)

        if self.timerType == .pomodoro {
            self.state = "focus"
        } else if self.timerType == .shortbreak {
            self.state = "break"
        } else if self.timerType == .longbreak {
            self.state = "chill"
        }
        
        self.buttonText = "pause"
    }
    
    func pause() {
        guard let timer = self.timer else {return}
        timer.invalidate()
        self.state = "idle"
        self.buttonText = "start"
    }
    
    func statusText() -> String {
        let messages = [
            "focus": "time to work 🤓",
            "idle": "lazy ahh boi 😡",
            "break": "chill time 😎",
            "chill": "touch some grass 🚶🏽‍♂️"
        ]
        if let status = messages[self.state] {
            return status
        }
        return "wyd 🤨"
    }
    
    func timeText() -> String {
        return String(format: "%d:%02d", secondsLeft / 60, secondsLeft % 60)
    }
    
    func setTimerType(type: TimerType) {
        if let timer = self.timer {
            timer.invalidate()
            self.state = "idle"
            self.buttonText = "start"
        }
        self.timerType = type
        self.secondsLeft = type.duration
        self.updateTime()
    }
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "goofy", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
