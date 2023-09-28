//
//  PomodoroModel.swift
//  Focus
//
//  Created by Musab Abdullah on 9/24/23.
//

import Foundation
import Cocoa
import AVFoundation


enum TimerType: String, Equatable, CaseIterable {
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
    
    var displayText: String {
        switch self {
        case .pomodoro: return "pomodoro"
        case .shortbreak: return "short break"
        default: return "long break"
        }
    }
    
    var duration: Int {
        switch self {
        case .pomodoro:
            return 25*60
        case .shortbreak:
//            return 5*60
            return 5
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
class PomodoroModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    @Published var time: String
    @Published var isRunning: Bool
    @Published var progress: Float = 0.0
    @Published var timerType: TimerType = .pomodoro
    
    private var secondsLeft: Float
    private var timer: Timer?
    var audioPlayer = AVAudioPlayer()
    
    override init() {
        self.time = "25:00"
        self.secondsLeft = 25.0 * 60.0
        self.isRunning = false
        
        // set up audio player
        let sound = Bundle.main.path(forResource: "ringer", ofType:"mp3")
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch let error {
            print(error.localizedDescription)
        }
        super.init()
        self.audioPlayer.delegate = self

    }
    
    func updateTime() {
        self.time = self.timeText()
        AppDelegate.instance.statusBarItem.button?.title = self.timeText()
        
        let done = max(Float(self.timerType.duration) - self.secondsLeft, 0.0)
        self.progress = Float(done) / Float(self.timerType.duration)
    }
    
    func start() {
        print("starting timer with \(self.secondsLeft) sec left")
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            if self.secondsLeft > 0.0 {
                self.secondsLeft -= 0.1
                self.updateTime()
            } else {
                Timer.invalidate()
                AppDelegate.instance.openMenu()
                self.playSound()
            }
        }
        RunLoop.main.add(self.timer!, forMode: .common)
        
        self.isRunning = true
    }
    
    func pause() {
        guard let timer = self.timer else {return}
        timer.invalidate()
        self.isRunning = false
    }
    
    func playPause() {
        if !self.isRunning {
            self.start()
        } else if self.isRunning && self.secondsLeft > 0 {
            self.pause()
        } else if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            self.isRunning = false
            self.secondsLeft = Float(self.timerType.duration)
            self.updateTime()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("The song ended")
        audioPlayer.currentTime = 0
        self.isRunning = false
        self.secondsLeft = Float(self.timerType.duration)
        self.updateTime()
    }
    
    func timeText() -> String {
        let secsLeft = Int(ceil(self.secondsLeft))
        return String(format: "%d:%02d", secsLeft / 60, secsLeft % 60)
    }
    
    func setTimerType(type: TimerType) {
        if let timer = self.timer {
            timer.invalidate()
            self.isRunning = false
        }
        self.timerType = type
        self.secondsLeft = Float(type.duration)
        self.updateTime()
    }
    
    func playSound() {
        audioPlayer.play()
    }
    
}
